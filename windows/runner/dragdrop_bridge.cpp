#include "dragdrop_bridge.h"

#include <flutter/standard_method_codec.h>
#include <flutter/event_stream_handler.h>
#include <flutter/event_stream_handler_functions.h>

bridge::DragDropBridge::DragDropBridge(flutter::FlutterEngine* flutter_instance)
    : flutter_instance_(flutter_instance),
      messenger_(flutter_instance->messenger()),
      name_("dnd_channel") {
        event_channel_ = std::make_unique<flutter::EventChannel<flutter::EncodableValue>>(
            messenger_, name_, &flutter::StandardMethodCodec::GetInstance());
        auto handler = std::make_unique<flutter::StreamHandlerFunctions<flutter::EncodableValue>>(
          [this](
            const flutter::EncodableValue* arguments,
            std::unique_ptr<flutter::EventSink<flutter::EncodableValue>>&& events) {
              event_sink_ = std::move(events);
              return nullptr;
            },
            [this](const flutter::EncodableValue* arguments) {
              event_sink_ = nullptr;
              return nullptr;
            }
        );
        event_channel_->SetStreamHandler(std::move(handler));
}

bridge::DragDropBridge::~DragDropBridge() {
    event_channel_->SetStreamHandler(nullptr);
}

void bridge::DragDropBridge::MessageHandler(HWND window, UINT const message, WPARAM const wparam, LPARAM const lparam) noexcept {
    switch (message) {
      case WM_DROPFILES: {
        HDROP hdrop = reinterpret_cast<HDROP>(wparam);
        UINT file_count = DragQueryFileW(hdrop, 0xFFFFFFFF, nullptr, 0);
        if (file_count == 0) {
            return;
        }
        flutter::EncodableList files;
        for (UINT i = 0; i < file_count; ++i) {
            wchar_t filename[MAX_PATH];
            if (DragQueryFileW(hdrop, i, filename, MAX_PATH)) {
                std::wstring wS = filename;
                int iBufferSize = ::WideCharToMultiByte(CP_UTF8, 0, wS.c_str(), -1, NULL, 0, NULL, NULL);
                char* cpBufUTF8 = new char[iBufferSize];
                ::WideCharToMultiByte(CP_UTF8, 0, wS.c_str(), -1, cpBufUTF8, iBufferSize, NULL, NULL);
                std::string s(cpBufUTF8, cpBufUTF8 + iBufferSize - 1);
                delete[] cpBufUTF8;
                flutter::EncodableValue file(std::move(s));
                files.push_back(std::move(file));
            }
        }
        DragFinish(hdrop);
        ReceiveEvent(std::move(files));
        return;
      }
    }
    return;
}


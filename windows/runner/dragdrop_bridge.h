#ifndef RUNNER_DRAGDROP_WINDOW_H_
#define RUNNER_DRAGDROP_WINDOW_H_

#include "flutter_window.h"

#include <flutter/binary_messenger.h>
#include <flutter/event_channel.h>
#include <flutter/event_sink.h>

namespace bridge {

class DragDropBridge {
  public:
    DragDropBridge(flutter::FlutterEngine* flutter_instance);
    ~DragDropBridge();
    void MessageHandler(HWND window, UINT const message, WPARAM const wparam, LPARAM const lparam) noexcept;

  private:
    flutter::FlutterEngine* flutter_instance_;
    flutter::BinaryMessenger* messenger_;
    std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> event_sink_;
    std::unique_ptr<flutter::EventChannel<flutter::EncodableValue>> event_channel_;
    std::string name_;

    template <typename T>
    void ReceiveEvent(const T& value) {
      if (event_sink_) {
        event_sink_->Success(value);
      }
    }
};

}
#endif

import 'package:apack/constants.dart';
import 'package:apack/providers/compression_option.dart';
import 'package:apack/providers/global.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingView extends HookConsumerWidget {
  const SettingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeProvider);
    final compressionImageOptions = ref.watch(compressionImageOptionProvider);

    final themeModeListView = [
      Text('Theme mode', style: FluentTheme.of(context).typography.subtitle),
      spacer,
      ...List.generate(ThemeMode.values.length, (index) {
        final mode = ThemeMode.values[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RadioButton(
            checked: appTheme.mode == mode,
            onChanged: (value) {
              if (value) {
                ref.read(appThemeProvider.notifier).update(mode: mode);
              }
            },
            content: Text('$mode'.replaceAll('ThemeMode.', '')),
          ),
        );
      })
    ];

    final imageCompressionListView = [
      Text('Compression image options',
          style: FluentTheme.of(context).typography.subtitle),
      Text('Affects reduce size process and format conversion.',
          style: FluentTheme.of(context).typography.bodyStrong),
      spacer,
      Row(
        children: [
          Expanded(
            child: TextFormBox(
              initialValue: '${compressionImageOptions.width}',
              header: 'maxWidth',
              placeholder: '1920',
              onChanged: (value) {
                int? width = int.tryParse(value);
                if (width != null) {
                  ref
                      .read(compressionImageOptionProvider.notifier)
                      .update(width: width);
                }
              },
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.always,
              validator: (text) {
                if (text == null) return 'Required';
                if (text.isEmpty) return 'Required';
                if (int.tryParse(text) == null) return 'Invalid only number';
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: TextFormBox(
              initialValue: '${compressionImageOptions.height}',
              header: 'maxHeight',
              placeholder: '1080',
              onChanged: (value) {
                int? height = int.tryParse(value);
                if (height != null) {
                  ref
                      .read(compressionImageOptionProvider.notifier)
                      .update(height: height);
                }
              },
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.always,
              validator: (text) {
                if (text == null) return 'Required';
                if (text.isEmpty) return 'Required';
                if (int.tryParse(text) == null) return 'Only number';
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: TextFormBox(
              initialValue: '${compressionImageOptions.quality}',
              header: 'Quality',
              placeholder: '100',
              onChanged: (value) {
                int? quality = int.tryParse(value);
                if (quality != null) {
                  ref
                      .read(compressionImageOptionProvider.notifier)
                      .update(quality: quality);
                }
              },
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.always,
              validator: (text) {
                if (text == null) return 'Required';
                if (text.isEmpty) return 'Required';
                final int? quality = int.tryParse(text);
                if (quality == null) return 'Only number';
                if (quality < 0 || quality > 100) return 'Quality 1-100';
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
          )
        ],
      ),
    ];

    final remainDebugView = [
      Text('Remain Debug', style: FluentTheme.of(context).typography.subtitle),
      spacer,
      ElevatedButton(
        onPressed: () {
          if (ref.read(remainItemCountProvider.state).state == 15) {
            ref.read(remainItemCountProvider.state).state = 0;
          } else {
            ref.read(remainItemCountProvider.state).state++;
          }
        },
        child: const Text("update remain"),
      ),
    ];

    return ScaffoldPage(
      header: const PageHeader(title: Text('Settings')),
      content: ListView(
        padding: EdgeInsets.only(
          bottom: kPageDefaultVerticalPadding,
          left: PageHeader.horizontalPadding(context),
          right: PageHeader.horizontalPadding(context),
        ),
        children: [
          ...imageCompressionListView,
          biggerSpacer,
          ...themeModeListView,
          biggerSpacer,
          ...remainDebugView,
        ],
      ),
    );
  }
}

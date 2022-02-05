import 'package:apack/constants.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FormatConversionView extends HookConsumerWidget {
  const FormatConversionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage(
      header:
          const PageHeader(title: Text('Format Conversion JPG, PNG, and WebP')),
      content: ListView(
        padding: EdgeInsets.only(
          bottom: kPageDefaultVerticalPadding,
          left: PageHeader.horizontalPadding(context),
          right: PageHeader.horizontalPadding(context),
        ),
        children: [
          Text('Select archive',
              style: FluentTheme.of(context).typography.subtitle),
          spacer,
        ],
      ),
    );
  }
}

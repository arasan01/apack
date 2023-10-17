import 'package:apack/constants.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class AboutView extends HookConsumerWidget {
  const AboutView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> sourceLaunchView = [
      Text('Source Code', style: FluentTheme.of(context).typography.subtitle),
      spacer,
      Button(
        onPressed: () {
          url_launcher.launch(kGithubRepositoryUrl);
        },
        child: Row(
          children: [
            const Icon(FluentIcons.open_source),
            spacer,
            Text('GitHub Repository',
                style: FluentTheme.of(context).typography.bodyStrong),
          ],
        ),
      )
    ];

    List<Widget> twitterLaunchView = [
      Text('Twitter', style: FluentTheme.of(context).typography.subtitle),
      spacer,
      Button(
        onPressed: () {
          url_launcher.launch(kTwitterUrl);
        },
        child: Row(
          children: [
            const Icon(FluentIcons.user_followed),
            spacer,
            Text('Author Twitter @arasan01_dev',
                style: FluentTheme.of(context).typography.bodyStrong),
          ],
        ),
      )
    ];

    return ScaffoldPage(
      header: const PageHeader(title: Text('About')),
      content: ListView(
        padding: EdgeInsets.only(
          bottom: kPageDefaultVerticalPadding,
          left: PageHeader.horizontalPadding(context),
          right: PageHeader.horizontalPadding(context),
        ),
        children: [
          ...sourceLaunchView,
          biggerSpacer,
          ...twitterLaunchView,
        ],
      ),
    );
  }
}

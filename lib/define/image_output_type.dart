enum AppImageOutputType { jpg, png, gif }

extension AppExt on AppImageOutputType {
  String get extensionName {
    switch (this) {
      case AppImageOutputType.jpg:
        return 'jpg';
      case AppImageOutputType.png:
        return 'png';
      case AppImageOutputType.gif:
        return 'gif';
    }
  }

  String get mimeType {
    switch (this) {
      case AppImageOutputType.jpg:
        return 'image/jpeg';
      case AppImageOutputType.png:
        return 'image/png';
      case AppImageOutputType.gif:
        return 'image/gif';
    }
  }
}

extension AppImageOutputTypeExt on String {
  AppImageOutputType toAppImageOutputType() {
    return AppImageOutputType.values.firstWhere((type) => type.name == this,
        orElse: () => AppImageOutputType.jpg);
  }
}

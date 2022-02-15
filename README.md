# apack

images utility tools for me.

## In progress

[途中経過](https://twitter.com/arasan01_me/status/1492837275725873153)

## How to build

Flutter setup
`$ flutter config --enable-windows-desktop`

1. Clone this repository
2. `$ flutter pub run build_runner build`
3. `$ flutter run -d windows`
4. If run is ok, `$ flutter build windows`
5. If build passed, `$ flutter pub run msix:create`

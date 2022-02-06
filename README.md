# apack

A new Flutter project.

## How to build

Flutter setup
`$ flutter config --enable-windows-desktop`

1. Clone this repository
2. `$ flutter pub run build_runner build`
3. `$ flutter run -d windows`
4. If run is ok, `$ flutter build windows`
5. If build passed, `$ flutter pub run msix:create`

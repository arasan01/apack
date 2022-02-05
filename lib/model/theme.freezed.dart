// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AppThemeTearOff {
  const _$AppThemeTearOff();

  _AppTheme call({AccentColor? color, ThemeMode mode = ThemeMode.system}) {
    return _AppTheme(
      color: color,
      mode: mode,
    );
  }
}

/// @nodoc
const $AppTheme = _$AppThemeTearOff();

/// @nodoc
mixin _$AppTheme {
  AccentColor? get color => throw _privateConstructorUsedError;
  ThemeMode get mode => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppThemeCopyWith<AppTheme> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppThemeCopyWith<$Res> {
  factory $AppThemeCopyWith(AppTheme value, $Res Function(AppTheme) then) =
      _$AppThemeCopyWithImpl<$Res>;
  $Res call({AccentColor? color, ThemeMode mode});
}

/// @nodoc
class _$AppThemeCopyWithImpl<$Res> implements $AppThemeCopyWith<$Res> {
  _$AppThemeCopyWithImpl(this._value, this._then);

  final AppTheme _value;
  // ignore: unused_field
  final $Res Function(AppTheme) _then;

  @override
  $Res call({
    Object? color = freezed,
    Object? mode = freezed,
  }) {
    return _then(_value.copyWith(
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as AccentColor?,
      mode: mode == freezed
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
    ));
  }
}

/// @nodoc
abstract class _$AppThemeCopyWith<$Res> implements $AppThemeCopyWith<$Res> {
  factory _$AppThemeCopyWith(_AppTheme value, $Res Function(_AppTheme) then) =
      __$AppThemeCopyWithImpl<$Res>;
  @override
  $Res call({AccentColor? color, ThemeMode mode});
}

/// @nodoc
class __$AppThemeCopyWithImpl<$Res> extends _$AppThemeCopyWithImpl<$Res>
    implements _$AppThemeCopyWith<$Res> {
  __$AppThemeCopyWithImpl(_AppTheme _value, $Res Function(_AppTheme) _then)
      : super(_value, (v) => _then(v as _AppTheme));

  @override
  _AppTheme get _value => super._value as _AppTheme;

  @override
  $Res call({
    Object? color = freezed,
    Object? mode = freezed,
  }) {
    return _then(_AppTheme(
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as AccentColor?,
      mode: mode == freezed
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
    ));
  }
}

/// @nodoc

class _$_AppTheme with DiagnosticableTreeMixin implements _AppTheme {
  _$_AppTheme({this.color, this.mode = ThemeMode.system});

  @override
  final AccentColor? color;
  @JsonKey()
  @override
  final ThemeMode mode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppTheme(color: $color, mode: $mode)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppTheme'))
      ..add(DiagnosticsProperty('color', color))
      ..add(DiagnosticsProperty('mode', mode));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AppTheme &&
            const DeepCollectionEquality().equals(other.color, color) &&
            const DeepCollectionEquality().equals(other.mode, mode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(color),
      const DeepCollectionEquality().hash(mode));

  @JsonKey(ignore: true)
  @override
  _$AppThemeCopyWith<_AppTheme> get copyWith =>
      __$AppThemeCopyWithImpl<_AppTheme>(this, _$identity);
}

abstract class _AppTheme implements AppTheme {
  factory _AppTheme({AccentColor? color, ThemeMode mode}) = _$_AppTheme;

  @override
  AccentColor? get color;
  @override
  ThemeMode get mode;
  @override
  @JsonKey(ignore: true)
  _$AppThemeCopyWith<_AppTheme> get copyWith =>
      throw _privateConstructorUsedError;
}

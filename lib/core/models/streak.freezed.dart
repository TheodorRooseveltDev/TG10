// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streak.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Streak {
  int get id => throw _privateConstructorUsedError;
  String get date =>
      throw _privateConstructorUsedError; // ISO 8601 date string (YYYY-MM-DD)
  bool get completed => throw _privateConstructorUsedError;

  /// Create a copy of Streak
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StreakCopyWith<Streak> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreakCopyWith<$Res> {
  factory $StreakCopyWith(Streak value, $Res Function(Streak) then) =
      _$StreakCopyWithImpl<$Res, Streak>;
  @useResult
  $Res call({int id, String date, bool completed});
}

/// @nodoc
class _$StreakCopyWithImpl<$Res, $Val extends Streak>
    implements $StreakCopyWith<$Res> {
  _$StreakCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Streak
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? completed = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StreakImplCopyWith<$Res> implements $StreakCopyWith<$Res> {
  factory _$$StreakImplCopyWith(
    _$StreakImpl value,
    $Res Function(_$StreakImpl) then,
  ) = __$$StreakImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String date, bool completed});
}

/// @nodoc
class __$$StreakImplCopyWithImpl<$Res>
    extends _$StreakCopyWithImpl<$Res, _$StreakImpl>
    implements _$$StreakImplCopyWith<$Res> {
  __$$StreakImplCopyWithImpl(
    _$StreakImpl _value,
    $Res Function(_$StreakImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Streak
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? completed = null,
  }) {
    return _then(
      _$StreakImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$StreakImpl implements _Streak {
  const _$StreakImpl({
    required this.id,
    required this.date,
    required this.completed,
  });

  @override
  final int id;
  @override
  final String date;
  // ISO 8601 date string (YYYY-MM-DD)
  @override
  final bool completed;

  @override
  String toString() {
    return 'Streak(id: $id, date: $date, completed: $completed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.completed, completed) ||
                other.completed == completed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, date, completed);

  /// Create a copy of Streak
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakImplCopyWith<_$StreakImpl> get copyWith =>
      __$$StreakImplCopyWithImpl<_$StreakImpl>(this, _$identity);
}

abstract class _Streak implements Streak {
  const factory _Streak({
    required final int id,
    required final String date,
    required final bool completed,
  }) = _$StreakImpl;

  @override
  int get id;
  @override
  String get date; // ISO 8601 date string (YYYY-MM-DD)
  @override
  bool get completed;

  /// Create a copy of Streak
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StreakImplCopyWith<_$StreakImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

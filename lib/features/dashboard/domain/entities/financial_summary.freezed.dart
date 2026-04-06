// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FinancialSummary {
  double get totalIncome => throw _privateConstructorUsedError;
  double get totalExpense => throw _privateConstructorUsedError;
  double get currentBalance => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FinancialSummaryCopyWith<FinancialSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialSummaryCopyWith<$Res> {
  factory $FinancialSummaryCopyWith(
          FinancialSummary value, $Res Function(FinancialSummary) then) =
      _$FinancialSummaryCopyWithImpl<$Res, FinancialSummary>;
  @useResult
  $Res call({double totalIncome, double totalExpense, double currentBalance});
}

/// @nodoc
class _$FinancialSummaryCopyWithImpl<$Res, $Val extends FinancialSummary>
    implements $FinancialSummaryCopyWith<$Res> {
  _$FinancialSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? currentBalance = null,
  }) {
    return _then(_value.copyWith(
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as double,
      currentBalance: null == currentBalance
          ? _value.currentBalance
          : currentBalance // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancialSummaryImplCopyWith<$Res>
    implements $FinancialSummaryCopyWith<$Res> {
  factory _$$FinancialSummaryImplCopyWith(_$FinancialSummaryImpl value,
          $Res Function(_$FinancialSummaryImpl) then) =
      __$$FinancialSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double totalIncome, double totalExpense, double currentBalance});
}

/// @nodoc
class __$$FinancialSummaryImplCopyWithImpl<$Res>
    extends _$FinancialSummaryCopyWithImpl<$Res, _$FinancialSummaryImpl>
    implements _$$FinancialSummaryImplCopyWith<$Res> {
  __$$FinancialSummaryImplCopyWithImpl(_$FinancialSummaryImpl _value,
      $Res Function(_$FinancialSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? currentBalance = null,
  }) {
    return _then(_$FinancialSummaryImpl(
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as double,
      currentBalance: null == currentBalance
          ? _value.currentBalance
          : currentBalance // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$FinancialSummaryImpl implements _FinancialSummary {
  const _$FinancialSummaryImpl(
      {required this.totalIncome,
      required this.totalExpense,
      required this.currentBalance});

  @override
  final double totalIncome;
  @override
  final double totalExpense;
  @override
  final double currentBalance;

  @override
  String toString() {
    return 'FinancialSummary(totalIncome: $totalIncome, totalExpense: $totalExpense, currentBalance: $currentBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialSummaryImpl &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            (identical(other.currentBalance, currentBalance) ||
                other.currentBalance == currentBalance));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, totalIncome, totalExpense, currentBalance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialSummaryImplCopyWith<_$FinancialSummaryImpl> get copyWith =>
      __$$FinancialSummaryImplCopyWithImpl<_$FinancialSummaryImpl>(
          this, _$identity);
}

abstract class _FinancialSummary implements FinancialSummary {
  const factory _FinancialSummary(
      {required final double totalIncome,
      required final double totalExpense,
      required final double currentBalance}) = _$FinancialSummaryImpl;

  @override
  double get totalIncome;
  @override
  double get totalExpense;
  @override
  double get currentBalance;
  @override
  @JsonKey(ignore: true)
  _$$FinancialSummaryImplCopyWith<_$FinancialSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// Mocks generated by Mockito 5.2.0 from annotations
// in core/test/presentation/bloc/tv/tv_watchlist_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:core/domain/entities/tv/tv_series.dart' as _i7;
import 'package:core/domain/entities/tv/tv_series_detail.dart' as _i10;
import 'package:core/domain/repositories/tv_series_repository.dart' as _i3;
import 'package:core/domain/usecases/tv/get_watchlist_tv_series.dart' as _i4;
import 'package:core/domain/usecases/tv/get_watchlist_tv_series_status.dart'
    as _i8;
import 'package:core/domain/usecases/tv/remove_tv_series_watchlist.dart'
    as _i11;
import 'package:core/domain/usecases/tv/save_tv_series_watchlist.dart' as _i9;
import 'package:core/utils/failure.dart' as _i6;
import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeEither_0<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

class _FakeTvSeriesRepository_1 extends _i1.Fake
    implements _i3.TvSeriesRepository {}

/// A class which mocks [GetWatchlistTvSeries].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetWatchlistTvSeries extends _i1.Mock
    implements _i4.GetWatchlistTvSeries {
  MockGetWatchlistTvSeries() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i7.TvSeries>>> execute() =>
      (super.noSuchMethod(Invocation.method(#execute, []),
              returnValue:
                  Future<_i2.Either<_i6.Failure, List<_i7.TvSeries>>>.value(
                      _FakeEither_0<_i6.Failure, List<_i7.TvSeries>>()))
          as _i5.Future<_i2.Either<_i6.Failure, List<_i7.TvSeries>>>);
}

/// A class which mocks [GetWatchlistTvSeriesStatus].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetWatchlistTvSeriesStatus extends _i1.Mock
    implements _i8.GetWatchlistTvSeriesStatus {
  MockGetWatchlistTvSeriesStatus() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.TvSeriesRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTvSeriesRepository_1()) as _i3.TvSeriesRepository);
  @override
  _i5.Future<bool> execute(int? id) =>
      (super.noSuchMethod(Invocation.method(#execute, [id]),
          returnValue: Future<bool>.value(false)) as _i5.Future<bool>);
}

/// A class which mocks [SaveTvSeriesWatchlist].
///
/// See the documentation for Mockito's code generation for more information.
class MockSaveTvSeriesWatchlist extends _i1.Mock
    implements _i9.SaveTvSeriesWatchlist {
  MockSaveTvSeriesWatchlist() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.TvSeriesRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTvSeriesRepository_1()) as _i3.TvSeriesRepository);
  @override
  _i5.Future<_i2.Either<_i6.Failure, String>> execute(
          _i10.TvSeriesDetail? tv) =>
      (super.noSuchMethod(Invocation.method(#execute, [tv]),
              returnValue: Future<_i2.Either<_i6.Failure, String>>.value(
                  _FakeEither_0<_i6.Failure, String>()))
          as _i5.Future<_i2.Either<_i6.Failure, String>>);
}

/// A class which mocks [RemoveTvSeriesWatchlist].
///
/// See the documentation for Mockito's code generation for more information.
class MockRemoveTvSeriesWatchlist extends _i1.Mock
    implements _i11.RemoveTvSeriesWatchlist {
  MockRemoveTvSeriesWatchlist() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.TvSeriesRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTvSeriesRepository_1()) as _i3.TvSeriesRepository);
  @override
  _i5.Future<_i2.Either<_i6.Failure, String>> execute(
          _i10.TvSeriesDetail? tv) =>
      (super.noSuchMethod(Invocation.method(#execute, [tv]),
              returnValue: Future<_i2.Either<_i6.Failure, String>>.value(
                  _FakeEither_0<_i6.Failure, String>()))
          as _i5.Future<_i2.Either<_i6.Failure, String>>);
}

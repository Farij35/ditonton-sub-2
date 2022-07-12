import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_on_air.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_series/tv_series_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvOnTheAir,
  GetPopularTvSeries,
  GetTopRatedTvSeries
])

void main() {
  late TvListNotifier provider;
  late MockGetTvOnTheAir mockGetTvOnTheAir;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvOnTheAir = MockGetTvOnTheAir();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries= MockGetTopRatedTvSeries();
    provider = TvListNotifier(
      getTvOnTheAir: mockGetTvOnTheAir,
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvShows: mockGetTopRatedTvSeries,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  final tTv = TvSeries(
    backdropPath: 'backdropPath',
    genreIds: [1, 2],
    id: 1,
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
    name: 'name',
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
  );
  final tTvList = <TvSeries>[tTv];

  group('now playing tv shows', () {
    test('initialState should be Empty', () {
      expect(provider.tvOnTheAirState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetTvOnTheAir.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchTvOnTheAir();
      // assert
      verify(mockGetTvOnTheAir.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetTvOnTheAir.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchTvOnTheAir();
      // assert
      expect(provider.tvOnTheAirState, RequestState.Loading);
    });

    test('should change tv shows when data is gotten successfully', () async {
      // arrange
      when(mockGetTvOnTheAir.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchTvOnTheAir();
      // assert
      expect(provider.tvOnTheAirState, RequestState.Loaded);
      expect(provider.tvOnTheAir, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvOnTheAir.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvOnTheAir();
      // assert
      expect(provider.tvOnTheAirState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tv shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchPopularTvShows();
      // assert
      expect(provider.popularTvShowsState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change tv shows data when data is gotten successfully',
            () async {
          // arrange
          when(mockGetTopRatedTvSeries.execute())
              .thenAnswer((_) async => Right(tTvList));
          // act
          await provider.fetchPopularTvShows();
          // assert
          expect(provider.popularTvShowsState, RequestState.Loaded);
          expect(provider.popularTvShows, tTvList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTvShows();
      // assert
      expect(provider.popularTvShowsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tv shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchTopRatedTvShows();
      // assert
      expect(provider.topRatedTvShowsState, RequestState.Loading);
    });

    test('should change tv shows data when data is gotten successfully',
            () async {
          // arrange
          when(mockGetTopRatedTvSeries.execute())
              .thenAnswer((_) async => Right(tTvList));
          // act
          await provider.fetchTopRatedTvShows();
          // assert
          expect(provider.topRatedTvShowsState, RequestState.Loaded);
          expect(provider.topRatedTvShows, tTvList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTvShows();
      // assert
      expect(provider.topRatedTvShowsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
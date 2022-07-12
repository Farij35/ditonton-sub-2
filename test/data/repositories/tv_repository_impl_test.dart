import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/movie/genre_model.dart';
import 'package:ditonton/data/models/tv_series/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series/tv_series_model.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../dummy_data/tv series/tv_dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvModel = TvSeriesModel(
    backdropPath: '/path.jpg',
    genreIds: [1],
    id: 1,
    name: 'name',
    originalLanguage: 'en',
    originalName: 'originalName',
    overview:
        'overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTv = TvSeries(
    backdropPath: '/path.jpg',
    genreIds: [1],
    id: 1,
    name: 'name',
    originalLanguage: 'en',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTvModelList = <TvSeriesModel>[tTvModel];
  final tTvList = <TvSeries>[tTv];

  group('Tv Shows On The Air', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvOnTheAirApi())
          .thenAnswer((_) async => tTvModelList);
      // act
      final result = await repository.getTvOnTheAir();
      // assert
      verify(mockRemoteDataSource.getTvOnTheAirApi());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvOnTheAirApi())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvOnTheAir();
      // assert
      verify(mockRemoteDataSource.getTvOnTheAirApi());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvOnTheAirApi())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvOnTheAir();
      // assert
      verify(mockRemoteDataSource.getTvOnTheAirApi());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Popular Tv Shows', () {
    test('should return tv shows list when call to data source is success',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvShowsApi())
          .thenAnswer((_) async => tTvModelList);
      // act
      final result = await repository.getPopularTvShows();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvShowsApi())
          .thenThrow(ServerException());
      // act
      final result = await repository.getPopularTvShows();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvShowsApi())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularTvShows();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Tv Shows', () {
    test('should return tv shows list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvShowsApi())
          .thenAnswer((_) async => tTvModelList);
      // act
      final result = await repository.getTopRatedTvShows();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvShowsApi())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTvShows();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvShowsApi())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedTvShows();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Tv Detail', () {
    final tId = 1;
    final tTvResponse = TvSeriesDetailResponse(
      backdropPath: 'backdropPath',
      episodeRunTime: [1],
      genres: [GenreModel(id: 0, name: 'Sci-Fi & Fantasy')],
      homepage: "homepage",
      id: 1,
      inProduction: true,
      languages: ['languages'],
      name: 'name',
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
      originCountry: ['US'],
      originalLanguage: 'originalLanguage',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1.0,
      posterPath: 'posterPath',
      status: 'status',
      tagline: 'tagline',
      type: 'type',
      voteAverage: 1.0,
      voteCount: 1,
    );

    test(
        'should return Tv Shows data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetailApi(tId))
          .thenAnswer((_) async => tTvResponse);
      // act
      final result = await repository.getTvDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvDetailApi(tId));
      expect(result, equals(Right(testTvDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetailApi(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvDetailApi(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetailApi(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvDetailApi(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Tv Shows Recommendations', () {
    final tTvList = <TvSeriesModel>[];
    final tId = 1;

    test('should return data (tv shows list) when the call is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendationsApi(tId))
          .thenAnswer((_) async => tTvList);
      // act
      final result = await repository.getTvRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTvRecommendationsApi(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendationsApi(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvRecommendations(tId);
      // assertbuild runner
      verify(mockRemoteDataSource.getTvRecommendationsApi(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendationsApi(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTvRecommendationsApi(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Search Tv Shows', () {
    final tQuery = 'the boys';

    test('should return tv shows list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvShowsApi(tQuery))
          .thenAnswer((_) async => tTvModelList);
      // act
      final result = await repository.searchTvShows(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvShowsApi(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchTvShows(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvShowsApi(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchTvShows(tQuery);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Save Tv Watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertTvWatchlist(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveTvWatchlist(testTvDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertTvWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveTvWatchlist(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeTvWatchlist(testTvTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeTvWatchlist(testTvDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeTvWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeTvWatchlist(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToTvWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist tv shows', () {
    test('should return list of Tv Shows', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTvShows())
          .thenAnswer((_) async => [testTvTable]);
      // act
      final result = await repository.getWatchlistTvShows();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });
}

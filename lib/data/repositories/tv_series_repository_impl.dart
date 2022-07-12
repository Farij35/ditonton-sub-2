import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/datasources/tv_series/tv_series_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_series/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tv_series/tv_series_table.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series_detail.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class TvSeriesRepositoryImpl implements TvRepository {
  final TvSeriesRemoteDataSource remoteDataSource;
  final TvSeriesLocalDataSource localDataSource;

  TvSeriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<Either<Failure, List<TvSeries>>> getTvOnTheAir() async {
    try {
      final result = await remoteDataSource.getTvOnTheAirApi();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  Future<Either<Failure, List<TvSeries>>> getPopularTvShows() async {
    try {
      final result = await remoteDataSource.getPopularTvShowsApi();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  Future<Either<Failure, List<TvSeries>>> getTopRatedTvShows() async {
    try {
      final result = await remoteDataSource.getTopRatedTvShowsApi();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  Future<Either<Failure, List<TvSeries>>> searchTvShows(String query) async {
    try {
      final result = await remoteDataSource.searchTvShowsApi(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  Future<Either<Failure, TvSeriesDetail>> getTvDetail(int id) async {
    try {
      final result = await remoteDataSource.getTvDetailApi(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  Future<Either<Failure, List<TvSeries>>> getTvRecommendations(int id) async {
    try {
      final result = await remoteDataSource.getTvRecommendationsApi(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  Future<Either<Failure, String>> saveTvWatchlist(TvSeriesDetail tv) async {
    try {
      final result =
      await localDataSource.insertTvWatchlist(TvSeriesTable.fromEntity(tv));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  Future<Either<Failure, String>> removeTvWatchlist(TvSeriesDetail tv) async {
    try {
      final result =
      await localDataSource.removeTvWatchlist(TvSeriesTable.fromEntity(tv));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  Future<bool> isAddedToTvWatchlist(int id) async {
    final result = await localDataSource.getTvById(id);
    return result != null;
  }

  Future<Either<Failure, List<TvSeries>>> getWatchlistTvShows() async {
    final result = await localDataSource.getWatchlistTvShows();
    return Right(result.map((data) => data.toEntity()).toList());
  }
}
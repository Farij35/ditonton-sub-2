import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series_detail.dart';

abstract class TvRepository {
  Future<Either<Failure, List<TvSeries>>> getTvOnTheAir();
  Future<Either<Failure, List<TvSeries>>> getPopularTvShows();
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvShows();
  Future<Either<Failure, TvSeriesDetail>> getTvDetail(int id);
  Future<Either<Failure, List<TvSeries>>> getTvRecommendations(int id);
  Future<Either<Failure, List<TvSeries>>> searchTvShows(String query);
  Future<Either<Failure, String>> saveTvWatchlist(TvSeriesDetail tv);
  Future<Either<Failure, String>> removeTvWatchlist(TvSeriesDetail tv);
  Future<bool> isAddedToTvWatchlist(int id);
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvShows();
}
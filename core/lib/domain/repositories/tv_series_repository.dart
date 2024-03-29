import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:core/domain/entities/tv/tv_series_detail.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

abstract class TvSeriesRepository {
  Future<Either<Failure, List<TvSeries>>> getTvSeriesOnAir();
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries();
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries();
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id);
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(int id);
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query);
  Future<Either<Failure, String>> saveTvSeriesWatchlist(TvSeriesDetail tv);
  Future<Either<Failure, String>> removeTvSeriesWatchlist(TvSeriesDetail tv);
  Future<bool> isAddedToTvSeriesWatchlist(int id);
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries();
}

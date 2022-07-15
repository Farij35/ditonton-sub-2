import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetTvSeriesRecommendations {
  final TvSeriesRepository _repository;

  GetTvSeriesRecommendations(this._repository);

  Future<Either<Failure, List<TvSeries>>> execute(id) {
    return _repository.getTvSeriesRecommendations(id);
  }
}

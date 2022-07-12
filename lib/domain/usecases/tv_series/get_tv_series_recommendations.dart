import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetTvRecommendations {
  final TvRepository _repository;

  GetTvRecommendations(this._repository);

  Future<Either<Failure, List<TvSeries>>> execute(id) {
    return _repository.getTvRecommendations(id);
  }
}
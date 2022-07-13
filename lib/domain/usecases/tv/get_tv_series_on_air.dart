import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv_series.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetTvSeriesOnAir {
  final TvSeriesRepository _repository;

  GetTvSeriesOnAir(this._repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return _repository.getTvSeriesOnAir();
  }
}

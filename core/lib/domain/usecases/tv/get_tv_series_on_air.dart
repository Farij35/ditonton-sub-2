import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetTvSeriesOnAir {
  final TvSeriesRepository _repository;

  GetTvSeriesOnAir(this._repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return _repository.getTvSeriesOnAir();
  }
}

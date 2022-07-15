import 'package:core/domain/entities/tv/tv_series_detail.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetTvSeriesDetail {
  final TvSeriesRepository _repository;

  GetTvSeriesDetail(this._repository);

  Future<Either<Failure, TvSeriesDetail>> execute(int id) {
    return _repository.getTvSeriesDetail(id);
  }
}

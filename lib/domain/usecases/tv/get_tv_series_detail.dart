import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv_series_detail.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetTvSeriesDetail {
  final TvSeriesRepository _repository;

  GetTvSeriesDetail(this._repository);

  Future<Either<Failure, TvSeriesDetail>> execute(int id) {
    return _repository.getTvSeriesDetail(id);
  }
}

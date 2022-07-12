import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series_detail.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class SaveTvWatchlist {
  final TvRepository repository;

  SaveTvWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TvSeriesDetail tv) {
    return repository.saveTvWatchlist(tv);
  }
}
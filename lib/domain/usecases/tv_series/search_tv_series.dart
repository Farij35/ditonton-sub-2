import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class SearchTvSeries {
  final TvRepository repository;

  SearchTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute(String query) {
    return repository.searchTvShows(query);
  }
}
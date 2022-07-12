import 'package:ditonton/data/models/tv_series/tv_series_model.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvModel = TvSeriesModel(
      backdropPath: 'backdropPath',
      genreIds: [1, 2],
      id: 1,
      name: 'name',
      originalLanguage: 'originalLanguage',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      voteAverage: 1,
      voteCount: 1,
  );

  final tTv = TvSeries(
        backdropPath: 'backdropPath',
        genreIds: [1, 2],
        id: 1,
        name: 'name',
        originalLanguage: 'originalLanguage',
        originalName: 'originalName',
        overview: 'overview',
        popularity: 1,
        posterPath: 'posterPath',
        voteAverage: 1,
        voteCount: 1,
  );

  test('should be a subclass of Tv entity', () async {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });
}

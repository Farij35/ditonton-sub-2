import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_series_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvSeries usecase;
  late MockTvSeriesRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvSeriesRepository();
    usecase = GetPopularTvSeries(mockTvRepository);
  });

  final tTvShows = <TvSeries>[];

  test(
      'should get list of tv series from the repository when execute function is called',
      () async {
    // arrange
    when(mockTvRepository.getPopularTvSeries())
        .thenAnswer((_) async => Right(tTvShows));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvShows));
  });
}

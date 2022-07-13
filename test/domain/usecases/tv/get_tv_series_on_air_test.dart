import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_on_air.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesOnAir usecase;
  late MockTvSeriesRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesOnAir(mockTvRepository);
  });

  final tTvShows = <TvSeries>[];

  test('should get list of tv series from the repository', () async {
    // arrange
    when(mockTvRepository.getTvSeriesOnAir())
        .thenAnswer((_) async => Right(tTvShows));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvShows));
  });
}

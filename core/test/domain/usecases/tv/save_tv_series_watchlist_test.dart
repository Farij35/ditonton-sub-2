import 'package:core/domain/usecases/tv/save_tv_series_watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv/tv_dummy_object.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveTvSeriesWatchlist usecase;
  late MockTvSeriesRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvSeriesRepository();
    usecase = SaveTvSeriesWatchlist(mockTvRepository);
  });

  test('should save tv series to the repository', () async {
    // arrange
    when(mockTvRepository.saveTvSeriesWatchlist(testTvDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvDetail);
    // assert
    verify(mockTvRepository.saveTvSeriesWatchlist(testTvDetail));
    expect(result, Right('Added to Watchlist'));
  });
}

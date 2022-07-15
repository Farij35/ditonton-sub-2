import 'package:core/domain/usecases/tv/remove_tv_series_watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv/tv_dummy_object.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveTvSeriesWatchlist usecase;
  late MockTvSeriesRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvSeriesRepository();
    usecase = RemoveTvSeriesWatchlist(mockTvRepository);
  });

  test('should remove watchlist tv series from repository', () async {
    // arrange
    when(mockTvRepository.removeTvSeriesWatchlist(testTvDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTvDetail);
    // assert
    verify(mockTvRepository.removeTvSeriesWatchlist(testTvDetail));
    expect(result, Right('Removed from watchlist'));
  });
}

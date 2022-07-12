import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv_series/save_tv_series_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv series/tv_dummy_object.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveTvWatchlist usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SaveTvWatchlist(mockTvRepository);
  });

  test('should save tv to the repository', () async {
    // arrange
    when(mockTvRepository.saveTvWatchlist(testTvDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvDetail);
    // assert
    verify(mockTvRepository.saveTvWatchlist(testTvDetail));
    expect(result, Right('Added to Watchlist'));
  });
}

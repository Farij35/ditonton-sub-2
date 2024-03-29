import 'package:core/domain/usecases/tv/get_tv_series_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/tv/tv_dummy_object.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesDetail usecase;
  late MockTvSeriesRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesDetail(mockTvRepository);
  });

  final tId = 1;

  test('should get tv series detail from the repository', () async {
    // arrange
    when(mockTvRepository.getTvSeriesDetail(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(testTvDetail));
  });
}

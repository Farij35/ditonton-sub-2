import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/tv/get_tv_series_detail.dart';
import 'package:core/presentation/bloc/tv/tv_detail_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/tv/tv_dummy_object.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesDetail])
void main() {
  late TvDetailBloc detailTvBloc;
  late MockGetTvSeriesDetail mockGetTvDetail;

  setUp(() {
    mockGetTvDetail = MockGetTvSeriesDetail();
    detailTvBloc = TvDetailBloc(mockGetTvDetail);
  });

  test('initial state should be empty', () {
    expect(detailTvBloc.state, TvDetailEmpty());
  });

  const tId = 1;

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvDetail));
      return detailTvBloc;
    },
    act: (bloc) => bloc.add(const TvDetailHasDataEvent(tId)),
    expect: () => [
      TvDetailLoading(),
      TvDetailHasData(testTvDetail),
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, Error] when get detail movies is unsuccessful',
    build: () {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return detailTvBloc;
    },
    act: (bloc) => bloc.add(const TvDetailHasDataEvent(tId)),
    expect: () => [
      TvDetailLoading(),
      const TvDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tId));
    },
  );
}
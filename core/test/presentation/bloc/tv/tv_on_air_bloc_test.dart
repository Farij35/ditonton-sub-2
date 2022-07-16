import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:core/domain/usecases/tv/get_tv_series_on_air.dart';
import 'package:core/presentation/bloc/tv/tv_on_air_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_on_air_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesOnAir])
void main() {
  late MockGetTvSeriesOnAir mockGetTvOnAir;
  late TvOnAirBloc tvOnAirBloc;

  setUp(() {
    mockGetTvOnAir = MockGetTvSeriesOnAir();
    tvOnAirBloc = TvOnAirBloc(mockGetTvOnAir);
  });

  test('initial state should be empty', () {
    expect(tvOnAirBloc.state, TvOnAirEmpty());
  });

  final tTVSeries = TvSeries(
    backdropPath: '/oaGvjB0DvdhXhOAuADfHb261ZHa.jpg',
    genreIds: const [10759, 9648, 18],
    id: 93405,
    originalName: '오징어 게임',
    overview:
    'Hundreds of cash-strapped players accept a strange invitation to compete in children\'s games—with high stakes. But, a tempting prize awaits the victor.',
    popularity: 5200.044,
    posterPath: '/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
    originalLanguage: 'ko',
    name: 'Squid Game',
    voteAverage: 7.8,
    voteCount: 7842,
  );

  final tTVSeriesList = <TvSeries>[tTVSeries];

  blocTest<TvOnAirBloc, TvOnAirState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvOnAir.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      return tvOnAirBloc;
    },
    act: (bloc) => bloc.add(TvOnAirEventHasData()),
    expect: () =>
    [TvOnAirLoading(), TvOnAirHasData(tTVSeriesList)],
    verify: (bloc) {
      verify(mockGetTvOnAir.execute());
    },
  );

  blocTest<TvOnAirBloc, TvOnAirState>(
    'Should emit [Loading, Error] when get now playing is unsuccessful',
    build: () {
      when(mockGetTvOnAir.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvOnAirBloc;
    },
    act: (bloc) => bloc.add(TvOnAirEventHasData()),
    expect: () => [
      TvOnAirLoading(),
      const TvOnAirError('Server Failure')
    ],
    verify: (bloc) {
      verify(mockGetTvOnAir.execute());
    },
  );
}
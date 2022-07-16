import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:core/domain/usecases/tv/get_popular_tv_series_shows.dart';
import 'package:core/presentation/bloc/tv/tv_popular_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_popular_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late MockGetPopularTvSeries mockGetPopularTv;
  late TvPopularBloc popularTvBloc;

  setUp(() {
    mockGetPopularTv = MockGetPopularTvSeries();
    popularTvBloc = TvPopularBloc(mockGetPopularTv);
  });

  test('initial state should be empty', () {
    expect(popularTvBloc.state, TvPopularEmpty());
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


  final tTvList = <TvSeries>[tTVSeries];

  blocTest<TvPopularBloc, TvPopularState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(TvPopularHasDataEvent()),
    expect: () => [TvPopularLoading(), TvPopularHasData(tTvList)],
    verify: (bloc) {
      verify(mockGetPopularTv.execute());
    },
  );

  blocTest<TvPopularBloc, TvPopularState>(
    'Should emit [Loading, Error] when get popular movies is unsuccessful',
    build: () {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(TvPopularHasDataEvent()),
    expect: () =>
    [TvPopularLoading(), const TvPopularError('Server Failure')],
    verify: (bloc) {
      verify(mockGetPopularTv.execute());
    },
  );
}
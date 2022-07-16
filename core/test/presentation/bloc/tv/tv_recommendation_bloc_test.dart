import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:core/domain/usecases/tv/get_tv_series_recommendations.dart';
import 'package:core/presentation/bloc/tv/tv_recommendation_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_recommendation_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesRecommendations])
void main() {
  late TvRecommendationBloc recommendationTvBloc;
  late MockGetTvSeriesRecommendations mockGetTvRecommendations;

  setUp(() {
    mockGetTvRecommendations = MockGetTvSeriesRecommendations();
    recommendationTvBloc =
        TvRecommendationBloc(mockGetTvRecommendations);
  });

  test('initial state should be empty', () {
    expect(recommendationTvBloc.state, TvRecommendationEmpty());
  });

  const tId = 1;

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
  final tTv = <TvSeries>[tTVSeries];

  blocTest<TvRecommendationBloc, TvRecommendationState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTv));
      return recommendationTvBloc;
    },
    act: (bloc) => bloc.add(const TvRecommendationEventHasData(tId)),
    expect: () => [
      TvRecommendationLoading(),
      TvRecommendationHasData(tTv),
    ],
    verify: (bloc) {
      verify(mockGetTvRecommendations.execute(tId));
    },
  );

  blocTest<TvRecommendationBloc, TvRecommendationState>(
    'Should emit [Loading, Error] when get recommendation is unsuccessful',
    build: () {
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return recommendationTvBloc;
    },
    act: (bloc) => bloc.add(const TvRecommendationEventHasData(tId)),
    expect: () => [
      TvRecommendationLoading(),
      const TvRecommendationError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvRecommendations.execute(tId));
    },
  );
}
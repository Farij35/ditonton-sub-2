import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/presentation/bloc/movie/movie_recommendation_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_recommendation_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MovieRecommendationBloc recommendationMoviesBloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    recommendationMoviesBloc =
        MovieRecommendationBloc(mockGetMovieRecommendations);
  });

  test('initial state should be empty', () {
    expect(recommendationMoviesBloc.state, MovieRecommendationEmpty());
  });

  const tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  blocTest<MovieRecommendationBloc, MovieRecommendationState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      return recommendationMoviesBloc;
    },
    act: (bloc) => bloc.add(const MovieRecommendationEventHasData(tId)),
    expect: () => [
      MovieRecommendationLoading(),
      MovieRecommendationHasData(tMovies),
    ],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );

  blocTest<MovieRecommendationBloc, MovieRecommendationState>(
    'Should emit [Loading, Error] when get recommendation is unsuccessful',
    build: () {
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return recommendationMoviesBloc;
    },
    act: (bloc) => bloc.add(const MovieRecommendationEventHasData(tId)),
    expect: () => [
      MovieRecommendationLoading(),
      const MovieRecommendationError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );
}
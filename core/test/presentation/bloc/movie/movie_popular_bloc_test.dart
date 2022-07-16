import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/presentation/bloc/movie/movie_popular_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_popular_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late MoviePopularBloc popularMoviesBloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = MoviePopularBloc(mockGetPopularMovies);
  });

  test('initial state should be empty', () {
    expect(popularMoviesBloc.state, MoviePopularEmpty());
  });

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

  final tMovieList = <Movie>[tMovie];

  blocTest<MoviePopularBloc, MoviePopularState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(MoviePopularHasDataEvent()),
    expect: () => [MoviePopularLoading(), MoviePopularHasData(tMovieList)],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
    },
  );

  blocTest<MoviePopularBloc, MoviePopularState>(
    'Should emit [Loading, Error] when get popular movies is unsuccessful',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(MoviePopularHasDataEvent()),
    expect: () =>
    [MoviePopularLoading(), const MoviePopularError('Server Failure')],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
    },
  );
}
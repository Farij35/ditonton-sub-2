import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/presentation/bloc/movie/movie_top_rated_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_top_rated_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late MovieTopRatedBloc topRatedMoviesBloc;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesBloc = MovieTopRatedBloc(mockGetTopRatedMovies);
  });

  test('initial state should be empty', () {
    expect(topRatedMoviesBloc.state, MovieTopRatedEmpty());
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
  blocTest<MovieTopRatedBloc, MovieTopRatedState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(MovieTopRatedHasDataEvent()),
    expect: () => [MovieTopRatedLoading(), MovieTopRatedHasData(tMovieList)],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );

  blocTest<MovieTopRatedBloc,MovieTopRatedState>(
    'Should emit [Loading, Error] when get top rated movies is unsuccessful',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(MovieTopRatedHasDataEvent()),
    expect: () =>
    [MovieTopRatedLoading(), const MovieTopRatedError('Server Failure')],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );
}
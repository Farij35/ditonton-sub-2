import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MovieDetailBloc detailMoviesBloc;
  late MockGetMovieDetail mockGetMovieDetail;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    detailMoviesBloc = MovieDetailBloc(mockGetMovieDetail);
  });

  test('initial state should be empty', () {
    expect(detailMoviesBloc.state, MovieDetailEmpty());
  });

  const tId = 1;

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      return detailMoviesBloc;
    },
    act: (bloc) => bloc.add(const DetailMoviesHasDataEvent(tId)),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailHasData(testMovieDetail),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Error] when get detail movies is unsuccessful',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return detailMoviesBloc;
    },
    act: (bloc) => bloc.add(const DetailMoviesHasDataEvent(tId)),
    expect: () => [
      MovieDetailLoading(),
      const MovieDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
    },
  );
}
import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/presentation/bloc/movie/movie_watchlist_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_watchlist_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieWatchlistBloc watchlistMoviesBloc;

  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    watchlistMoviesBloc = MovieWatchlistBloc(mockGetWatchlistMovies,
        mockGetWatchListStatus, mockSaveWatchlist, mockRemoveWatchlist);
  });

  test('initial state should be empty', () {
    expect(watchlistMoviesBloc.state, MovieWatchlistEmpty());
  });

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right([testWatchlistMovie]));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(MovieWatchlistHasDataEvent()),
    expect: () => [
      MovieWatchlistLoading(),
      MovieWatchlistHasData([testWatchlistMovie]),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<MovieWatchlistBloc,MovieWatchlistState>(
    'Should emit [Loading, Error] when get watchlist movies is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(MovieWatchlistHasDataEvent()),
    expect: () => [
      MovieWatchlistLoading(),
      const MovieWatchlistError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );
}
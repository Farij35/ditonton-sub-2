import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/tv/get_watchlist_tv_series.dart';
import 'package:core/domain/usecases/tv/get_watchlist_tv_series_status.dart';
import 'package:core/domain/usecases/tv/remove_tv_series_watchlist.dart';
import 'package:core/domain/usecases/tv/save_tv_series_watchlist.dart';
import 'package:core/presentation/bloc/tv/tv_watchlist_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/tv/tv_dummy_object.dart';
import 'tv_watchlist_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTvSeries,
  GetWatchlistTvSeriesStatus,
  SaveTvSeriesWatchlist,
  RemoveTvSeriesWatchlist,
])
void main() {
  late TvWatchlistBloc tvWatchlistBloc;

  late MockGetWatchlistTvSeries mockGetTvWatchlist;
  late MockGetWatchlistTvSeriesStatus mockGetTvWatchlistStatus;
  late MockSaveTvSeriesWatchlist mockSaveTvWatchlist;
  late MockRemoveTvSeriesWatchlist mockRemoveTvWatchlist;

  setUp(() {
    mockGetTvWatchlist = MockGetWatchlistTvSeries();
    mockGetTvWatchlistStatus = MockGetWatchlistTvSeriesStatus();
    mockSaveTvWatchlist = MockSaveTvSeriesWatchlist();
    mockRemoveTvWatchlist = MockRemoveTvSeriesWatchlist();
    tvWatchlistBloc = TvWatchlistBloc(mockGetTvWatchlist,
        mockGetTvWatchlistStatus, mockSaveTvWatchlist, mockRemoveTvWatchlist);
  });

  test('initial state should be empty', () {
    expect(tvWatchlistBloc.state, TvWatchlistEmpty());
  });

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvWatchlist.execute())
          .thenAnswer((_) async => Right([testWatchlistTv]));
      return tvWatchlistBloc;
    },
    act: (bloc) => bloc.add(TvWatchlistHasDataEvent()),
    expect: () => [
      TvWatchlistLoading(),
      TvWatchlistHasData([testWatchlistTv]),
    ],
    verify: (bloc) {
      verify(mockGetTvWatchlist.execute());
    },
  );

  blocTest<TvWatchlistBloc,TvWatchlistState>(
    'Should emit [Loading, Error] when get watchlist movies is unsuccessful',
    build: () {
      when(mockGetTvWatchlist.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvWatchlistBloc;
    },
    act: (bloc) => bloc.add(TvWatchlistHasDataEvent()),
    expect: () => [
      TvWatchlistLoading(),
      const TvWatchlistError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvWatchlist.execute());
    },
  );
}
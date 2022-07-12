import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'package:flutter/foundation.dart';

class WatchlistTvSeriesNotifier extends ChangeNotifier {
  var _watchlistTvShows = <TvSeries>[];
  List<TvSeries> get watchlistTvShows => _watchlistTvShows;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistTvSeriesNotifier({required this.getWatchlistTvSeries});

  final GetWatchlistTvSeries getWatchlistTvSeries;

  Future<void> fetchWatchlistTvShows() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTvSeries.execute();
    result.fold(
          (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvShowsData) {
        _watchlistState = RequestState.Loaded;
        _watchlistTvShows = tvShowsData;
        notifyListeners();
      },
    );
  }
}
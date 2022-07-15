import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:core/domain/entities/tv/tv_series_detail.dart';
import 'package:core/domain/usecases/tv/get_tv_series_detail.dart';
import 'package:core/domain/usecases/tv/get_tv_series_recommendations.dart';
import 'package:core/domain/usecases/tv/get_watchlist_tv_series_status.dart';
import 'package:core/domain/usecases/tv/remove_tv_series_watchlist.dart';
import 'package:core/domain/usecases/tv/save_tv_series_watchlist.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TvSeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchlistTvSeriesStatus getWatchlistTvSeriesStatus;
  final SaveTvSeriesWatchlist saveTvSeriesWatchlist;
  final RemoveTvSeriesWatchlist removeTvSeriesWatchlist;

  TvSeriesDetailNotifier({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchlistTvSeriesStatus,
    required this.saveTvSeriesWatchlist,
    required this.removeTvSeriesWatchlist,
  });

  late TvSeriesDetail _tvSeries;
  TvSeriesDetail get tv => _tvSeries;

  RequestState _tvSeriesState = RequestState.Empty;
  RequestState get tvState => _tvSeriesState;

  List<TvSeries> _tvSeriesRecommendations = [];
  List<TvSeries> get tvRecommendations => _tvSeriesRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoTvSeriesWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoTvSeriesWatchlist;

  Future<void> fetchTvSeriesDetail(int id) async {
    _tvSeriesState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvSeriesDetail.execute(id);
    final recommendationResult = await getTvSeriesRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _recommendationState = RequestState.Loading;
        _tvSeries = tv;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (tvSeries) {
            _recommendationState = RequestState.Loaded;
            _tvSeriesRecommendations = tvSeries;
          },
        );
        _tvSeriesState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addTvSeriesWatchlist(TvSeriesDetail tv) async {
    final result = await saveTvSeriesWatchlist.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistTvSeriesStatus(tv.id);
  }

  Future<void> removeFromTvSeriesWatchlist(TvSeriesDetail tv) async {
    final result = await removeTvSeriesWatchlist.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistTvSeriesStatus(tv.id);
  }

  Future<void> loadWatchlistTvSeriesStatus(int id) async {
    final result = await getWatchlistTvSeriesStatus.execute(id);
    _isAddedtoTvSeriesWatchlist = result;
    notifyListeners();
  }
}

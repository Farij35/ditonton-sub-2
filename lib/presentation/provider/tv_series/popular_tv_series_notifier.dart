import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:flutter/foundation.dart';

class PopularTvSeriesNotifier extends ChangeNotifier {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvSeriesNotifier(this.getPopularTvSeries);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TvSeries> _tvShows = [];
  List<TvSeries> get tvShows => _tvShows;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTvShows() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();

    result.fold(
          (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
          (tvShowsData) {
        _tvShows = tvShowsData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
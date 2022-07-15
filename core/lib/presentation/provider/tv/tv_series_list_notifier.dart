import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:core/domain/usecases/tv/get_popular_tv_series_shows.dart';
import 'package:core/domain/usecases/tv/get_top_rated_tv_series_shows.dart';
import 'package:core/domain/usecases/tv/get_tv_series_on_air.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';

class TvSeriesListNotifier extends ChangeNotifier {
  var _tvSeriesOnAir = <TvSeries>[];
  List<TvSeries> get tvOnTheAir => _tvSeriesOnAir;

  RequestState _tvSeriesOnAirState = RequestState.Empty;
  RequestState get tvSeriesOnAirState => _tvSeriesOnAirState;

  var _popularTvSeries = <TvSeries>[];
  List<TvSeries> get popularTvSeries => _popularTvSeries;

  RequestState _popularTvSeriesState = RequestState.Empty;
  RequestState get popularTvSeriesState => _popularTvSeriesState;

  var _topRatedTvSeries = <TvSeries>[];
  List<TvSeries> get topRatedTvSeries => _topRatedTvSeries;

  RequestState _topRatedTvSeriesState = RequestState.Empty;
  RequestState get topRatedTvSeriesState => _topRatedTvSeriesState;

  String _message = '';
  String get message => _message;

  TvSeriesListNotifier({
    required this.getTvSeriesOnAir,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  });

  final GetTvSeriesOnAir getTvSeriesOnAir;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  Future<void> fetchTvSeriesOnAir() async {
    _tvSeriesOnAirState = RequestState.Loading;
    notifyListeners();

    final result = await getTvSeriesOnAir.execute();
    result.fold(
      (failure) {
        _tvSeriesOnAirState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _tvSeriesOnAirState = RequestState.Loaded;
        _tvSeriesOnAir = tvSeriesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvSeries() async {
    _popularTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) {
        _popularTvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _popularTvSeriesState = RequestState.Loaded;
        _popularTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvSeries() async {
    _topRatedTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) {
        _topRatedTvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _topRatedTvSeriesState = RequestState.Loaded;
        _topRatedTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }
}

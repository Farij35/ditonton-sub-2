import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_on_air.dart';
import 'package:flutter/material.dart';

class TvListNotifier extends ChangeNotifier {
  var _tvOnTheAir = <TvSeries>[];
  List<TvSeries> get tvOnTheAir => _tvOnTheAir;

  RequestState _tvOnTheAirState = RequestState.Empty;
  RequestState get tvOnTheAirState => _tvOnTheAirState;

  var _popularTvShows = <TvSeries>[];
  List<TvSeries> get popularTvShows => _popularTvShows;

  RequestState _popularTvShowsState = RequestState.Empty;
  RequestState get popularTvShowsState => _popularTvShowsState;

  var _topRatedTvShows = <TvSeries>[];
  List<TvSeries> get topRatedTvShows => _topRatedTvShows;

  RequestState _topRatedTvShowsState = RequestState.Empty;
  RequestState get topRatedTvShowsState => _topRatedTvShowsState;

  String _message = '';
  String get message => _message;

  TvListNotifier({
    required this.getTvOnTheAir,
    required this.getPopularTvSeries,
    required this.getTopRatedTvShows,
  });

  final GetTvOnTheAir getTvOnTheAir;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvShows;

  Future<void> fetchTvOnTheAir() async {
    _tvOnTheAirState = RequestState.Loading;
    notifyListeners();

    final result = await getTvOnTheAir.execute();
    result.fold(
          (failure) {
        _tvOnTheAirState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvShowsData) {
        _tvOnTheAirState = RequestState.Loaded;
        _tvOnTheAir = tvShowsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvShows() async {
    _popularTvShowsState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();
    result.fold(
          (failure) {
        _popularTvShowsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvShowsData) {
        _popularTvShowsState = RequestState.Loaded;
        _popularTvShows = tvShowsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvShows() async {
    _topRatedTvShowsState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvShows.execute();
    result.fold(
          (failure) {
        _topRatedTvShowsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvShowsData) {
        _topRatedTvShowsState = RequestState.Loaded;
        _topRatedTvShows = tvShowsData;
        notifyListeners();
      },
    );
  }
}
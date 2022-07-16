import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:core/domain/entities/tv/tv_series_detail.dart';
import 'package:core/domain/usecases/tv/get_watchlist_tv_series.dart';
import 'package:core/domain/usecases/tv/get_watchlist_tv_series_status.dart';
import 'package:core/domain/usecases/tv/remove_tv_series_watchlist.dart';
import 'package:core/domain/usecases/tv/save_tv_series_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'event/tv_watchlist_event.dart';
part 'state/tv_watchlist_state.dart';

class TvWatchlistBloc extends Bloc<TvWatchlistEvent, TvWatchlistState>{
  final GetWatchlistTvSeries _getWatchlistTvSeries;
  final GetWatchlistTvSeriesStatus _getWatchListTvSeriesStatus;
  final SaveTvSeriesWatchlist _saveWatchlist;
  final RemoveTvSeriesWatchlist _removeWatchlist;

  TvWatchlistBloc(
    this._getWatchlistTvSeries,
    this._getWatchListTvSeriesStatus,
    this._saveWatchlist,
    this._removeWatchlist)
      : super(TvWatchlistEmpty()) {
    on<TvWatchlistHasDataEvent>((event, emit) async {

      emit(TvWatchlistLoading());
      final result = await _getWatchlistTvSeries.execute();

      result.fold(
        (failure) {
          emit(TvWatchlistError(failure.message));
        },
        (data) {
          emit(TvWatchlistHasData(data));
        },
      );
    });
    on<AddTvWatchlistDataEvent>((event, emit) async {
      final tv = event.tv;

      emit(TvWatchlistLoading());
      final result = await _saveWatchlist.execute(tv);

      result.fold(
        (failure) {
          emit(TvWatchlistError(failure.message));
        },
        (data) {
          emit(const AddTvWatchlistData(true));
        },
      );
    });
    on<LoadTvWatchlistStatusDataEvent>((event, emit) async {
      // final id = event.id;
      // emit(MovieWatchlistLoading());
      final result = await _getWatchListTvSeriesStatus.execute(event.id);
      emit(LoadTvWatchlistStatus(result));
    });
    on<RemoveTvWatchlistDataEvent>((event, emit) async {
      final tv = event.tv;

      emit(TvWatchlistLoading());
      final result = await _removeWatchlist.execute(tv);

      result.fold(
        (failure) {
          emit(TvWatchlistError(failure.message));
        },
        (data) {
          emit(const RemoveTvWatchlistData(false));
        },
      );
    });
  }
}
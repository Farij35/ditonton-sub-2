import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:core/domain/usecases/tv/get_popular_tv_series_shows.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'event/tv_popular_event.dart';
part 'state/tv_popular_state.dart';

class TvPopularBloc extends Bloc<TvPopularEvent, TvPopularState>{
  final GetPopularTvSeries _getPopularTvSeries;

  TvPopularBloc(this._getPopularTvSeries) : super(TvPopularEmpty()){
    on<TvPopularHasDataEvent>((event, emit) async {

      emit(TvPopularLoading());
      final result = await _getPopularTvSeries.execute();

      result.fold(
        (failure) {
          emit(TvPopularError(failure.message));
        },
        (data) {
          emit(TvPopularHasData(data));
        },
      );
    });
  }
}
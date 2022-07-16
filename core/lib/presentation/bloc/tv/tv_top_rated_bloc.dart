import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:core/domain/usecases/tv/get_top_rated_tv_series_shows.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'event/tv_top_rated_event.dart';
part 'state/tv_top_rated_state.dart';

class TvTopRatedBloc extends Bloc<TvTopRatedEvent, TvTopRatedState>{
  final GetTopRatedTvSeries _getTopRatedTvSeries;

  TvTopRatedBloc(this._getTopRatedTvSeries) : super(TvTopRatedEmpty()) {
    on<TvTopRatedHasDataEvent>((event, emit) async {

      emit(TvTopRatedLoading());
      final result = await _getTopRatedTvSeries.execute();

      result.fold(
        (failure) {
          emit(TvTopRatedError(failure.message));
        },
        (data) {
          emit(TvTopRatedHasData(data));
        },
      );
    });
  }
}
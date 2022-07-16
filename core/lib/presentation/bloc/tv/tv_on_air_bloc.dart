import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:core/domain/usecases/tv/get_tv_series_on_air.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'event/tv_on_air_event.dart';
part 'state/tv_on_air_state.dart';

class TvOnAirBloc extends Bloc<TvOnAirEvent, TvOnAirState>{
  final GetTvSeriesOnAir _getTvSeriesOnAir;

  TvOnAirBloc(this._getTvSeriesOnAir) : super(TvOnAirEmpty()){
    on<TvOnAirEventHasData>((event, emit) async {

      emit(TvOnAirLoading());
      final result = await _getTvSeriesOnAir.execute();

      result.fold(
            (failure) {
          emit(TvOnAirError(failure.message));
        },
            (data) {
          emit(TvOnAirHasData(data));
        },
      );
    });
  }
}
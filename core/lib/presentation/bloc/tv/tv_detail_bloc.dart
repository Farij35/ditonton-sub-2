import 'package:core/domain/entities/tv/tv_series_detail.dart';
import 'package:core/domain/usecases/tv/get_tv_series_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'event/tv_detail_event.dart';
part 'state/tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvSeriesDetail _getTvSeriesDetail;

  TvDetailBloc(this._getTvSeriesDetail) : super(TvDetailEmpty()) {
    on<TvDetailHasDataEvent>((event, emit) async {
      final id = event.id;

      emit(TvDetailLoading());
      final result = await _getTvSeriesDetail.execute(id);

      result.fold(
        (failure) {
          emit (TvDetailError(failure.message));
        },
        (data) {
          emit(TvDetailHasData(data));
        }
      );
    });
  }
}
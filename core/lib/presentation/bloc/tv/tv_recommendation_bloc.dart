import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:core/domain/usecases/tv/get_tv_series_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'event/tv_recommendation_event.dart';
part 'state/tv_recommendation_state.dart';

class TvRecommendationBloc extends Bloc<TvRecommendationEvent, TvRecommendationState>{
  final GetTvSeriesRecommendations _getTvSeriesRecommendations;

  TvRecommendationBloc(this._getTvSeriesRecommendations) : super(TvRecommendationEmpty()) {
    on<TvRecommendationEventHasData>((event, emit) async {
      final id = event.id;

      emit(TvRecommendationLoading());
      final result = await _getTvSeriesRecommendations.execute(id);

      result.fold(
        (failure) {
          emit(TvRecommendationError(failure.message));
        },
        (data) {
          emit(TvRecommendationHasData(data));
        },
      );
    });
  }
}
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'event/movie_recommendation_event.dart';
part 'state/movie_recommendation_state.dart';

class MovieRecommendationBloc extends Bloc<MovieRecommendationEvent, MovieRecommendationState>{
  final GetMovieRecommendations _getMovieRecommendations;

  MovieRecommendationBloc(this._getMovieRecommendations) : super(MovieRecommendationEmpty()) {
    on<MovieRecommendationEventHasData>((event, emit) async {
      final id = event.id;

      emit(MovieRecommendationLoading());
      final result = await _getMovieRecommendations.execute(id);

      result.fold(
        (failure) {
          emit(MovieRecommendationError(failure.message));
        },
        (data) {
          emit(MovieRecommendationHasData(data));
        },
      );
    });
  }
}
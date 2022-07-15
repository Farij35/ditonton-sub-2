import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'event/movie_detail_event.dart';
part 'state/movie_detail_state.dart';

class MovieDetailBloc extends Bloc<DetailMoviesEvent, MovieDetailState> {
  final GetMovieDetail _getMovieDetail;

  MovieDetailBloc(this._getMovieDetail) : super(MovieDetailEmpty()) {
    on<DetailMoviesHasDataEvent>((event, emit) async {
      final id = event.id;

      emit(MovieDetailLoading());
      final result = await _getMovieDetail.execute(id);

      result.fold(
        (failure) {
          emit (MovieDetailError(failure.message));
        },
        (data) {
          emit(MovieDetailHasData(data));
        }
      );
    });
  }
}
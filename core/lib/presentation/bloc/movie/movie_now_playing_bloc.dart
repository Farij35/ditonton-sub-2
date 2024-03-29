import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'event/movie_now_playing_event.dart';
part 'state/movie_now_playing_state.dart';

class MovieNowPlayingBloc extends Bloc<MovieNowPlayingEvent, MovieNowPlayingState>{
  final GetNowPlayingMovies _getNowPlayingMovies;

  MovieNowPlayingBloc(this._getNowPlayingMovies) : super(MovieNowPlayingEmpty()){
    on<MovieNowPlayingHasData>((event, emit) async {

      emit(MovieNowPlayingLoading());
      final result = await _getNowPlayingMovies.execute();

      result.fold(
            (failure) {
          emit(MovieNowPlayingError(failure.message));
        },
            (data) {
          emit(NowPlayingMovieHasData(data));
        },
      );
    });
  }
}
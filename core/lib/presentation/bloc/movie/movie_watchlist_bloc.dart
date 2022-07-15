import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'event/movie_watchlist_event.dart';
part 'state/movie_watchlist_state.dart';

class MovieWatchlistBloc extends Bloc<MovieWatchlistEvent, MovieWatchlistState>{
  final GetWatchlistMovies _getWatchlistMovies;
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  MovieWatchlistBloc(
    this._getWatchlistMovies,
    this._getWatchListStatus,
    this._saveWatchlist,
    this._removeWatchlist)
      : super(MovieWatchlistEmpty()) {
    on<MovieWatchlistHasDataEvent>((event, emit) async {

      emit(MovieWatchlistLoading());
      final result = await _getWatchlistMovies.execute();

      result.fold(
        (failure) {
          emit(MovieWatchlistError(failure.message));
        },
        (data) {
          emit(MovieWatchlistHasData(data));
        },
      );
    });
    on<AddMoviesWatchlistDataEvent>((event, emit) async {
      final movie = event.movie;

      emit(MovieWatchlistLoading());
      final result = await _saveWatchlist.execute(movie);

      result.fold(
        (failure) {
          emit(MovieWatchlistError(failure.message));
        },
        (data) {
          emit(const AddMovieWatchlistData(true));
        },
      );
    });
    on<LoadMoviesWatchlistStatusDataEvent>((event, emit) async {
      // final id = event.id;
      // emit(MovieWatchlistLoading());
      final result = await _getWatchListStatus.execute(event.id);
      emit(LoadMovieWatchlistStatus(result));
    });
    on<RemoveMoviesWatchlistDataEvent>((event, emit) async {
      final movie = event.movie;

      emit(MovieWatchlistLoading());
      final result = await _removeWatchlist.execute(movie);

      result.fold(
        (failure) {
          emit(MovieWatchlistError(failure.message));
        },
        (data) {
          emit(const RemoveMovieWatchlistData(false));
        },
      );
    });
  }
}
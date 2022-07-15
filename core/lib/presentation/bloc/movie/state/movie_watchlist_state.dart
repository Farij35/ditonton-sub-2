part of '../movie_watchlist_bloc.dart';

abstract class MovieWatchlistState extends Equatable {
  const MovieWatchlistState();

  @override
  List<Object> get props => [];
}

class MovieWatchlistEmpty extends MovieWatchlistState {}

class MovieWatchlistLoading extends MovieWatchlistState {}

class MovieWatchlistError extends MovieWatchlistState {
  final String message;

  const MovieWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieWatchlistSuccess extends MovieWatchlistState {
  final String message;

  const MovieWatchlistSuccess(this.message);

  @override
  List<Object> get props => [message];
}
// ignore: must_be_immutable
class MovieWatchlistStatus extends MovieWatchlistState {
  bool status = false;

  MovieWatchlistStatus(this.status);

  @override
  List<Object> get props => [status];
}

class MovieWatchlistHasData extends MovieWatchlistState {
  final List<Movie> result;

  const MovieWatchlistHasData(this.result);

  @override
  List<Object> get props => [result];
}

class AddMovieWatchlistData extends MovieWatchlistState {
  final bool result;

  const AddMovieWatchlistData(this.result);

  @override
  List<Object> get props => [result];
}

class RemoveMovieWatchlistData extends MovieWatchlistState {
  final bool result;

  const RemoveMovieWatchlistData(this.result);

  @override
  List<Object> get props => [result];
}

// ignore: must_be_immutable
class LoadMovieWatchlistStatus extends MovieWatchlistState {
  bool status = false;

  LoadMovieWatchlistStatus(this.status);

  @override
  List<Object> get props => [status];
}
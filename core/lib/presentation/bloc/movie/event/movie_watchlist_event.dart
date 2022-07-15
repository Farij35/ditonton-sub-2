part of '../movie_watchlist_bloc.dart';

abstract class MovieWatchlistEvent extends Equatable {
  const MovieWatchlistEvent();

  @override
  List<Object> get props => [];
}

class MovieWatchlistHasDataEvent extends MovieWatchlistEvent {}

class AddMoviesWatchlistDataEvent extends MovieWatchlistEvent {
  final MovieDetail movie;

  const AddMoviesWatchlistDataEvent(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveMoviesWatchlistDataEvent extends MovieWatchlistEvent {
  final MovieDetail movie;

  const RemoveMoviesWatchlistDataEvent(this.movie);

  @override
  List<Object> get props => [movie];
}

class LoadMoviesWatchlistStatusDataEvent extends MovieWatchlistEvent {
  final int id;

  const LoadMoviesWatchlistStatusDataEvent(this.id);

  @override
  List<Object> get props => [id];
}
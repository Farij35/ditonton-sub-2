part of '../tv_watchlist_bloc.dart';

abstract class TvWatchlistEvent extends Equatable {
  const TvWatchlistEvent();

  @override
  List<Object> get props => [];
}

class TvWatchlistHasDataEvent extends TvWatchlistEvent {}

class AddTvWatchlistDataEvent extends TvWatchlistEvent {
  final TvSeriesDetail tv;

  const AddTvWatchlistDataEvent(this.tv);

  @override
  List<Object> get props => [tv];
}

class RemoveTvWatchlistDataEvent extends TvWatchlistEvent {
  final TvSeriesDetail tv;

  const RemoveTvWatchlistDataEvent(this.tv);

  @override
  List<Object> get props => [tv];
}

class LoadTvWatchlistStatusDataEvent extends TvWatchlistEvent {
  final int id;

  const LoadTvWatchlistStatusDataEvent(this.id);

  @override
  List<Object> get props => [id];
}
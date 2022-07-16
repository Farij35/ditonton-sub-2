part of '../tv_watchlist_bloc.dart';

abstract class TvWatchlistState extends Equatable {
  const TvWatchlistState();

  @override
  List<Object> get props => [];
}

class TvWatchlistEmpty extends TvWatchlistState {}

class TvWatchlistLoading extends TvWatchlistState {}

class TvWatchlistError extends TvWatchlistState {
  final String message;

  const TvWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class TvWatchlistSuccess extends TvWatchlistState {
  final String message;

  const TvWatchlistSuccess(this.message);

  @override
  List<Object> get props => [message];
}
// ignore: must_be_immutable
class TvWatchlistStatus extends TvWatchlistState {
  bool status = false;

  TvWatchlistStatus(this.status);

  @override
  List<Object> get props => [status];
}

class TvWatchlistHasData extends TvWatchlistState {
  final List<TvSeries> result;

  const TvWatchlistHasData(this.result);

  @override
  List<Object> get props => [result];
}

class AddTvWatchlistData extends TvWatchlistState {
  final bool result;

  const AddTvWatchlistData(this.result);

  @override
  List<Object> get props => [result];
}

class RemoveTvWatchlistData extends TvWatchlistState {
  final bool result;

  const RemoveTvWatchlistData(this.result);

  @override
  List<Object> get props => [result];
}

// ignore: must_be_immutable
class LoadTvWatchlistStatus extends TvWatchlistState {
  bool status = false;

  LoadTvWatchlistStatus(this.status);

  @override
  List<Object> get props => [status];
}
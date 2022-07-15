part of '../search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchHasDataForMovie extends SearchState {
  final List<Movie> result;

  const SearchHasDataForMovie(this.result);

  @override
  List<Object> get props => [result];
}

class SearchHasDataForTvSeries extends SearchState {
  final List<TvSeries> resultTv;

  const SearchHasDataForTvSeries(this.resultTv);

  @override
  List<Object> get props => [resultTv];
}
part of '../movie_recommendation_bloc.dart';

abstract class MovieRecommendationEvent extends Equatable {
  const MovieRecommendationEvent();

  @override
  List<Object> get props => [];
}

class MovieRecommendationEventHasData extends MovieRecommendationEvent {
  final int id;

  const MovieRecommendationEventHasData(this.id);

  @override
  List<Object> get props => [id];
}
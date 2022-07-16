part of '../tv_recommendation_bloc.dart';

abstract class TvRecommendationEvent extends Equatable {
  const TvRecommendationEvent();

  @override
  List<Object> get props => [];
}

class TvRecommendationEventHasData extends TvRecommendationEvent {
  final int id;

  const TvRecommendationEventHasData(this.id);

  @override
  List<Object> get props => [id];
}
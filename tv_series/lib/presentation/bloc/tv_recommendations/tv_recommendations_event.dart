part of 'tv_recommendations_bloc.dart';

abstract class TvRecommendationsEvent extends Equatable {
  const TvRecommendationsEvent();

  @override
  List<Object?> get props => [];
}

class FetchRecommendationsTv extends TvRecommendationsEvent{
  final int id;

  const FetchRecommendationsTv(this.id);

  @override
  List<Object?> get props => [id];
}

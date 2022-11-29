part of 'tv_watchlist_bloc.dart';

abstract class TvWatchlistEvent extends Equatable {
  const TvWatchlistEvent();

  @override
  List<Object?> get props => [];
}

class AddTvToWatchList extends TvWatchlistEvent{
  final TvDetail tvDetail;

  const AddTvToWatchList(this.tvDetail);

  @override
  List<Object?> get props => [tvDetail];
}

class RemoveTvFromWatchList extends TvWatchlistEvent{
  final TvDetail tvDetail;

  const RemoveTvFromWatchList(this.tvDetail);

  @override
  List<Object?> get props => [tvDetail];
}

class TvIsAddedToWatchList extends TvWatchlistEvent{}

class TvIsRemovedFromWatchList extends TvWatchlistEvent{}

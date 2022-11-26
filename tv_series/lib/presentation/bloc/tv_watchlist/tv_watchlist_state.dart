part of 'tv_watchlist_bloc.dart';

abstract class TvWatchlistState extends Equatable {
  final String message;

  const TvWatchlistState(this.message);

  @override
  List<Object?> get props => [message];
}

class TvWatchlistInitial extends TvWatchlistState{
  TvWatchlistInitial(super.message);
}

class WatchlistAddTvMessage extends TvWatchlistState {
  WatchlistAddTvMessage(super.message);
}

class WatchlistRemoveTvMessage extends TvWatchlistState {
  WatchlistRemoveTvMessage(super.message);
}

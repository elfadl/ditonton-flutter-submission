part of 'movie_watchlist_bloc.dart';

abstract class MovieWatchlistState extends Equatable {
  final String message;

  const MovieWatchlistState(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieWatchlistInitial extends MovieWatchlistState{
  const MovieWatchlistInitial(super.message);
}

class WatchlistAddMovieMessage extends MovieWatchlistState {
  const WatchlistAddMovieMessage(super.message);
}

class WatchlistRemoveMovieMessage extends MovieWatchlistState {
  const WatchlistRemoveMovieMessage(super.message);
}
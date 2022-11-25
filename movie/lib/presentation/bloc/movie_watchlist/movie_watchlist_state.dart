part of 'movie_watchlist_bloc.dart';

abstract class MovieWatchlistState extends Equatable {
  final String message;

  const MovieWatchlistState(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieWatchlistInitial extends MovieWatchlistState{
  MovieWatchlistInitial(super.message);
}

class WatchlistAddMovieMessage extends MovieWatchlistState {
  WatchlistAddMovieMessage(super.message);
}

class WatchlistRemoveMovieMessage extends MovieWatchlistState {
  WatchlistRemoveMovieMessage(super.message);
}
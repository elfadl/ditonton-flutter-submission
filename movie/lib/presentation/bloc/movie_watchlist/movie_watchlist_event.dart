part of 'movie_watchlist_bloc.dart';

abstract class MovieWatchlistEvent extends Equatable {
  const MovieWatchlistEvent();
  @override
  List<Object?> get props => [];
}

class AddMovieToWatchList extends MovieWatchlistEvent{
  final MovieDetail movieDetail;

  const AddMovieToWatchList(this.movieDetail);

  @override
  List<Object?> get props => [movieDetail];
}

class RemoveMovieFromWatchList extends MovieWatchlistEvent{
  final MovieDetail movieDetail;

  const RemoveMovieFromWatchList(this.movieDetail);

  @override
  List<Object?> get props => [movieDetail];
}

class MovieIsAddedToWatchList extends MovieWatchlistEvent{}

class MovieIsRemovedFromWatchList extends MovieWatchlistEvent{}

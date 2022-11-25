import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecase/remove_watchlist.dart';
import '../../../domain/usecase/save_watchlist.dart';

part 'movie_watchlist_event.dart';
part 'movie_watchlist_state.dart';

class MovieWatchlistBloc
    extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  MovieWatchlistBloc(
    this._saveWatchlist,
    this._removeWatchlist,
  ) : super(MovieWatchlistInitial("")) {
    on<AddMovieToWatchList>((event, emit) async {
      final movie = event.movieDetail;

      final result = await _saveWatchlist.execute(movie);

      result.fold(
            (failure) => emit(WatchlistAddMovieMessage(failure.message)),
            (success) => emit(WatchlistAddMovieMessage(watchlistAddSuccessMessage)),
      );
    });

    on<RemoveMovieFromWatchList>((event, emit) async {
      final movie = event.movieDetail;

      final result = await _removeWatchlist.execute(movie);

      result.fold(
            (failure) => emit(WatchlistRemoveMovieMessage(failure.message)),
            (success) =>
            emit(WatchlistRemoveMovieMessage(watchlistRemoveSuccessMessage)),
      );
    });

    on<MovieIsAddedToWatchList>((event, emit) async {
      emit(WatchlistAddMovieMessage(''));
    });
    on<MovieIsRemovedFromWatchList>((event, emit) async {
      emit(WatchlistRemoveMovieMessage(''));
    });
  }
}

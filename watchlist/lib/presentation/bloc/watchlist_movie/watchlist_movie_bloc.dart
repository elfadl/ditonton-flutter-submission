import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/get_watchlist_movies.dart';

part 'watchlist_movie_event.dart';

part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies _getWatchlistMovies;

  WatchlistMovieBloc(this._getWatchlistMovies) : super(WatchlistMovieEmpty()) {
    on<FetchWatchlistMovie>((event, emit) async {
      emit(WatchlistMovieLoading());

      final result = await _getWatchlistMovies.execute();

      result.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (movies) => movies.isEmpty
            ? emit(WatchlistMovieEmpty())
            : emit(WatchlistMovieHasData(movies)),
      );
    });
  }
}

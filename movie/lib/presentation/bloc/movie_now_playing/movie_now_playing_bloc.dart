import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecase/get_now_playing_movies.dart';

part 'movie_now_playing_event.dart';
part 'movie_now_playing_state.dart';

class MovieNowPlayingBloc extends Bloc<MovieNowPlayingEvent, MovieNowPlayingState> {
  final GetNowPlayingMovies _getNowPlayingMovie;

  MovieNowPlayingBloc(
    this._getNowPlayingMovie
  ) : super(MovieNowPlayingEmpty()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(MovieNowPlayingLoading());

      final result = await _getNowPlayingMovie.execute();
      result.fold(
            (failure) => emit(MovieNowPlayingError(failure.message)),
            (moviesData) => emit(MovieNowPlayingHasData(moviesData)),
      );
    });
  }
}

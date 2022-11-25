import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecase/get_movie_detail.dart';
import '../../../domain/usecase/get_watchlist_status.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {

  final GetMovieDetail _getMovieDetail;
  final GetWatchListStatus _getWatchlistStatus;

  MovieDetailBloc(
    this._getMovieDetail,
    this._getWatchlistStatus,
  ) : super(MovieDetailEmpty()) {
    on<FetchDetailMovies>((event, emit) async {
      final id = event.id;

      emit(MovieDetailLoading());
      final result = await _getMovieDetail.execute(id);
      final isAddedToWatchlist = await _getWatchlistStatus.execute(id);

      result.fold(
        (failure) => emit(MovieDetailError(failure.message)),
        (movie) => emit(MovieDetailHasData(movie, isAddedToWatchlist)),
      );
    });
  }
}

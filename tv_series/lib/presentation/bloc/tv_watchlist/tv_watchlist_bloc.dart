import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/remove_watchlist_tv.dart';
import '../../../domain/usecases/save_watchlist_tv.dart';

part 'tv_watchlist_event.dart';
part 'tv_watchlist_state.dart';

class TvWatchlistBloc extends Bloc<TvWatchlistEvent, TvWatchlistState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final SaveWatchlistTv _saveWatchlistTv;
  final RemoveWatchlistTv _removeWatchlistTv;

  TvWatchlistBloc(
    this._saveWatchlistTv,
    this._removeWatchlistTv,
  ) : super(const TvWatchlistInitial("")) {
    on<AddTvToWatchList>((event, emit) async {
      final tv = event.tvDetail;

      final result = await _saveWatchlistTv.execute(tv);

      result.fold(
            (failure) => emit(WatchlistAddTvMessage(failure.message)),
            (success) => emit(const WatchlistAddTvMessage(watchlistAddSuccessMessage)),
      );
    });

    on<RemoveTvFromWatchList>((event, emit) async {
      final tv = event.tvDetail;

      final result = await _removeWatchlistTv.execute(tv);

      result.fold(
            (failure) => emit(WatchlistRemoveTvMessage(failure.message)),
            (success) =>
            emit(const WatchlistRemoveTvMessage(watchlistRemoveSuccessMessage)),
      );
    });

    on<TvIsAddedToWatchList>((event, emit) async {
      emit(const WatchlistAddTvMessage(''));
    });
    on<TvIsRemovedFromWatchList>((event, emit) async {
      emit(const WatchlistRemoveTvMessage(''));
    });
  }
}

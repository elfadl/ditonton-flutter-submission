import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/get_watchlist_tv.dart';

part 'watchlist_tv_event.dart';

part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTv _getWatchlistTv;

  WatchlistTvBloc(this._getWatchlistTv) : super(WatchlistTvEmpty()) {
    on<FetchWatchlistTv>((event, emit) async {
      emit(WatchlistTvLoading());

      final result = await _getWatchlistTv.execute();

      result.fold(
        (failure) => emit(WatchlistTvError(failure.message)),
        (tv) => tv.isEmpty
            ? emit(WatchlistTvEmpty())
            : emit(WatchlistTvHasData(tv)),
      );
    });
  }
}

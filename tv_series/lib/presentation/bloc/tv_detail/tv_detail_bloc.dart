import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/get_tv_detail.dart';
import '../../../domain/usecases/get_watchlist_tv_status.dart';

part 'tv_detail_event.dart';

part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail _getTvDetail;
  final GetWatchlistTvStatus _getWatchlistTvStatus;

  TvDetailBloc(
    this._getTvDetail,
    this._getWatchlistTvStatus,
  ) : super(TvDetailEmpty()) {
    on<FetchDetailTv>((event, emit) async {
      final id = event.id;

      emit(TvDetailLoading());
      final result = await _getTvDetail.execute(id);
      final isAddedToWatchlist = await _getWatchlistTvStatus.execute(id);

      result.fold(
        (failure) => emit(TvDetailError(failure.message)),
        (tvDetail) => emit(TvDetailHasData(tvDetail, isAddedToWatchlist)),
      );
    });
  }
}

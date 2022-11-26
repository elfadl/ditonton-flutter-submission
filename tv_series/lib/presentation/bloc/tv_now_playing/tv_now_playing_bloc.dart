import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/get_now_playing_tv.dart';

part 'tv_now_playing_event.dart';
part 'tv_now_playing_state.dart';

class TvNowPlayingBloc extends Bloc<TvNowPlayingEvent, TvNowPlayingState> {
  final GetNowPlayingTv _getNowPlayingTv;

  TvNowPlayingBloc(
    this._getNowPlayingTv,
  ) : super(TvNowPlayingEmpty()) {
    on<FetchNowPlayingTv>((event, emit) async {
      emit(TvNowPlayingLoading());

      final result = await _getNowPlayingTv.execute();
      result.fold(
        (failure) => emit(TvNowPlayingError(failure.message)),
        (tvData) => emit(TvNowPlayingHasData(tvData)),
      );
    });
  }
}

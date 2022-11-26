import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/get_top_rated_tv.dart';

part 'tv_top_rated_event.dart';
part 'tv_top_rated_state.dart';

class TvTopRatedBloc extends Bloc<TvTopRatedEvent, TvTopRatedState> {
  final GetTopRatedTv _getTopRatedTv;

  TvTopRatedBloc(this._getTopRatedTv) : super(TvTopRatedEmpty()) {
    on<FetchTopRatedTv>((event, emit) async {
      emit(TvTopRatedLoading());

      final result = await _getTopRatedTv.execute();
      result.fold(
        (failure) => emit(TvTopRatedError(failure.message)),
        (tvData) => emit(TvTopRatedHasData(tvData)),
      );
    });
  }
}

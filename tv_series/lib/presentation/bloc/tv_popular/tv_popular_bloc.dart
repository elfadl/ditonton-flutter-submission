import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/get_popular_tv.dart';

part 'tv_popular_event.dart';
part 'tv_popular_state.dart';

class TvPopularBloc extends Bloc<TvPopularEvent, TvPopularState> {
  final GetPopularTv _getPopularTv;

  TvPopularBloc(this._getPopularTv) : super(TvPopularEmpty()) {
    on<FetchPopularTv>((event, emit) async {
      emit(TvPopularLoading());

      final result = await _getPopularTv.execute();
      result.fold(
        (failure) => emit(TvPopularError(failure.message)),
        (tvData) => emit(TvPopularHasData(tvData)),
      );
    });
  }
}

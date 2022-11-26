part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchDetailTv extends TvDetailEvent{
  final int id;

  FetchDetailTv(this.id);

  @override
  List<Object?> get props => [id];
}

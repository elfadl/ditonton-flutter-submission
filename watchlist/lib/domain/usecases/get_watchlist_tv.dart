import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetWatchlistTv{
  final TvRepository repository;

  GetWatchlistTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute(){
    return repository.getWatchlistTvs();
  }
}
import 'package:dartz/dartz.dart';
import 'package:core/domain/usecases/remove_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main(){
  late RemoveWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = RemoveWatchlistTv(mockTvRepository);
  });

  test('should remove watchlist tv from repository', () async {
    when(mockTvRepository.removeWatchlist(testTvDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));

    final result = await usecase.execute(testTvDetail);

    verify(mockTvRepository.removeWatchlist(testTvDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
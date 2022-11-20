import 'package:dartz/dartz.dart';
import 'package:core/domain/usecases/get_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main(){
  late GetWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchlistTv(mockTvRepository);
  });

  test('should get list of tv from the repository', () async {
    when(mockTvRepository.getWatchlistTvs())
        .thenAnswer((_) async => Right(testTvList));

    final result = await usecase.execute();

    expect(result, Right(testTvList));
  });
}
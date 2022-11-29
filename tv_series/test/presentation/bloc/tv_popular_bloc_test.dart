import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_popular_tv.dart';
import 'package:tv_series/presentation/bloc/tv_popular/tv_popular_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'tv_popular_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTv])
void main() {
  late TvPopularBloc tvPopularBloc;
  late MockGetPopularTv mockGetPopularTv;

  setUp(() {
    mockGetPopularTv = MockGetPopularTv();
    tvPopularBloc = TvPopularBloc(mockGetPopularTv);
  });

  test('initial state should be empty', () {
    expect(tvPopularBloc.state, TvPopularEmpty());
  });

  final tTvModel = Tv(
    backdropPath: "/5kkw5RT1OjTAMh3POhjo5LdaACZ.jpg",
    firstAirDate: "2021-10-12",
    genreIds: const [80, 10765],
    id: 90462,
    name: "Chucky",
    originCountry: const ["US"],
    originalLanguage: "en",
    originalName: "Chucky",
    overview:
        "After a vintage Chucky doll turns up at a suburban yard sale, an idyllic American town is thrown into chaos as a series of horrifying murders begin to expose the town’s hypocrisies and secrets. Meanwhile, the arrival of enemies — and allies — from Chucky’s past threatens to expose the truth behind the killings, as well as the demon doll’s untold origins.",
    popularity: 2532.47,
    posterPath: "/kY0BogCM8SkNJ0MNiHB3VTM86Tz.jpg",
    voteAverage: 7.9,
    voteCount: 3463,
  );
  final tTvList = <Tv>[tTvModel];

  blocTest<TvPopularBloc, TvPopularState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));
      return tvPopularBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTv()),
    expect: () =>
        <TvPopularState>[TvPopularLoading(), TvPopularHasData(tTvList)],
    verify: (bloc) {
      verify(mockGetPopularTv.execute());
    },
  );

  blocTest<TvPopularBloc, TvPopularState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return tvPopularBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTv()),
    expect: () =>
        <TvPopularState>[TvPopularLoading(), const TvPopularError('Server Failure')],
    verify: (bloc) {
      verify(mockGetPopularTv.execute());
    },
  );

  group('test props', () {
    test('test props in FetchPopularTv', () {
      final event = FetchPopularTv();

      expect(event.props, []);
    });
  });
}

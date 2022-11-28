import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/domain/usecases/get_watchlist_tv.dart';
import 'package:watchlist/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';

import 'watchlist_tv_bloc_test.mocks.dart';


@GenerateMocks([GetWatchlistTv])
void main() {
  late WatchlistTvBloc watchlistTvBloc;
  late MockGetWatchlistTv mockGetWatchlistTv;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    watchlistTvBloc = WatchlistTvBloc(mockGetWatchlistTv);
  });

  test('initial state should be empty', () {
    expect(watchlistTvBloc.state, WatchlistTvEmpty());
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

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTv()),
    expect: () =>
        <WatchlistTvState>[WatchlistTvLoading(), WatchlistTvHasData(tTvList)],
    verify: (bloc) {
      verify(mockGetWatchlistTv.execute());
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, Empty] when data is gotten successfully but empty',
    build: () {
      when(mockGetWatchlistTv.execute())
          .thenAnswer((_) async => const Right(<Tv>[]));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTv()),
    expect: () =>
        <WatchlistTvState>[WatchlistTvLoading(), WatchlistTvEmpty()],
    verify: (bloc) {
      verify(mockGetWatchlistTv.execute());
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetWatchlistTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTv()),
    expect: () => <WatchlistTvState>[
      WatchlistTvLoading(),
      WatchlistTvError('Server Failure')
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTv.execute());
    },
  );

  group('test props', () {
    test('test props in FetchWatchlistTv', () {
      final event = FetchWatchlistTv();

      expect(event.props, []);
    });
  });
}

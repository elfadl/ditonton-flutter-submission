import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv_series/domain/usecases/save_watchlist_tv.dart';
import 'package:tv_series/presentation/bloc/tv_watchlist/tv_watchlist_bloc.dart';

import 'tv_watchlist_bloc_test.mocks.dart';


@GenerateMocks(
    [SaveWatchlistTv, RemoveWatchlistTv])
void main() {
  late TvWatchlistBloc tvWatchlistBloc;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    tvWatchlistBloc = TvWatchlistBloc(
      mockSaveWatchlistTv,
      mockRemoveWatchlistTv,
    );
  });

  test('initial state should be empty', () {
    expect(tvWatchlistBloc.state, TvWatchlistInitial(''));
  });

  final tTvDetail = TvDetail(
    adult: false,
    backdropPath: 'backdropPath',
    episodeRunTime: const [42],
    firstAirDate: "2021-10-12",
    genres: [Genre(id: 1, name: 'Action')],
    homepage: "https://www.syfy.com/chucky",
    id: 90462,
    inProduction: true,
    languages: const ["en"],
    lastAirDate: "2022-11-09",
    name: "Chucky",
    numberOfEpisodes: 16,
    numberOfSeasons: 2,
    originCountry: const ["US"],
    originalLanguage: "en",
    originalName: "Chucky",
    overview:
    "After a vintage Chucky doll turns up at a suburban yard sale, an idyllic American town is thrown into chaos as a series of horrifying murders begin to expose the town’s hypocrisies and secrets. Meanwhile, the arrival of enemies — and allies — from Chucky’s past threatens to expose the truth behind the killings, as well as the demon doll’s untold origins.",
    popularity: 2532.47,
    posterPath: "/kY0BogCM8SkNJ0MNiHB3VTM86Tz.jpg",
    seasons: [
      Season(
          airDate: "2021-10-12",
          episodeCount: 8,
          id: 126146,
          name: "Season 1",
          overview: "",
          posterPath: "/iF8ai2QLNiHV4anwY1TuSGZXqfN.jpg",
          seasonNumber: 1)
    ],
    status: "Returning Series",
    tagline: "A classic coming of rage story.",
    type: "Scripted",
    voteAverage: 7.861,
    voteCount: 3463,
  );

  const watchlistAddSuccessMessage = 'Added to Watchlist';
  const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'Should emit successful message when add tv to watchlist successfully',
    build: () {
      when(mockSaveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => const Right(watchlistAddSuccessMessage));
      return tvWatchlistBloc;
    },
    act: (bloc) => bloc.add(AddTvToWatchList(tTvDetail)),
    expect: () => <TvWatchlistState>[
      WatchlistAddTvMessage(watchlistAddSuccessMessage)
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistTv.execute(tTvDetail));
    },
  );

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'Should emit error message when add tv to watchlist unsuccessful',
    build: () {
      when(mockSaveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      return tvWatchlistBloc;
    },
    act: (bloc) => bloc.add(AddTvToWatchList(tTvDetail)),
    expect: () => <TvWatchlistState>[
      WatchlistAddTvMessage('Failed')
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistTv.execute(tTvDetail));
    },
  );

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'Should emit successful message when remove tv from watchlist successfully',
    build: () {
      when(mockRemoveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => const Right(watchlistRemoveSuccessMessage));
      return tvWatchlistBloc;
    },
    act: (bloc) => bloc.add(RemoveTvFromWatchList(tTvDetail)),
    expect: () => <TvWatchlistState>[
      WatchlistRemoveTvMessage(watchlistRemoveSuccessMessage)
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistTv.execute(tTvDetail));
    },
  );

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'Should emit error message when remove tv from watchlist unsuccessful',
    build: () {
      when(mockRemoveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      return tvWatchlistBloc;
    },
    act: (bloc) => bloc.add(RemoveTvFromWatchList(tTvDetail)),
    expect: () => <TvWatchlistState>[
      WatchlistRemoveTvMessage('Failed')
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistTv.execute(tTvDetail));
    },
  );
}
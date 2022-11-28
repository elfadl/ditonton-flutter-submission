import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_tv_detail.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';

import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetWatchlistTvStatus,
])
void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetWatchlistTvStatus mockGetWatchlistTvStatus;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetWatchlistTvStatus = MockGetWatchlistTvStatus();
    tvDetailBloc = TvDetailBloc(
      mockGetTvDetail,
      mockGetWatchlistTvStatus,
    );
  });

  test('initial state should be empty', () {
    expect(tvDetailBloc.state, TvDetailEmpty());
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

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, HasData] with isAddedWatchlist false when data is gotten successfully',
    build: () {
      when(mockGetTvDetail.execute(tTvDetail.id))
          .thenAnswer((_) async => Right(tTvDetail));
      when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => false);
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(FetchDetailTv(tTvDetail.id)),
    expect: () => <TvDetailState>[
      TvDetailLoading(),
      TvDetailHasData(tTvDetail, false)
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tTvDetail.id));
      verify(mockGetWatchlistTvStatus.execute(tTvDetail.id));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, HasData] with isAddedWatchlist true when data is gotten successfully',
    build: () {
      when(mockGetTvDetail.execute(tTvDetail.id))
          .thenAnswer((_) async => Right(tTvDetail));
      when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => true);
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(FetchDetailTv(tTvDetail.id)),
    expect: () => <TvDetailState>[
      TvDetailLoading(),
      TvDetailHasData(tTvDetail, true)
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tTvDetail.id));
      verify(mockGetWatchlistTvStatus.execute(tTvDetail.id));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, Error] when get tv detail is unsuccessful',
    build: () {
      when(mockGetTvDetail.execute(tTvDetail.id))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => false);
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(FetchDetailTv(tTvDetail.id)),
    expect: () => <TvDetailState>[
      TvDetailLoading(),
      TvDetailError('Server Failure')
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tTvDetail.id));
      verify(mockGetWatchlistTvStatus.execute(tTvDetail.id));
    },
  );

  group('test props', () {
    test('test props in FetchNowPlayingTv', () {
      final event = FetchDetailTv(tTvDetail.id);

      expect(event.props, [tTvDetail.id]);
    });
  });
}
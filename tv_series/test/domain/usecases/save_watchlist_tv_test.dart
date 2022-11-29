import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/save_watchlist_tv.dart';

import '../../helpers/test_helper.mocks.dart';

void main(){
  late SaveWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SaveWatchlistTv(mockTvRepository);
  });

  const testTvDetail = TvDetail(
    adult: false,
    backdropPath: 'backdropPath',
    episodeRunTime: [42],
    firstAirDate: "2021-10-12",
    genres: [Genre(id: 1, name: 'Action')],
    homepage: "https://www.syfy.com/chucky",
    id: 90462,
    inProduction: true,
    languages: ["en"],
    lastAirDate: "2022-11-09",
    name: "Chucky",
    numberOfEpisodes: 16,
    numberOfSeasons: 2,
    originCountry: ["US"],
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

  test('should save tv to the repository', () async {
    when(mockTvRepository.saveWatchlist(testTvDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));

    final result = await usecase.execute(testTvDetail);

    verify(mockTvRepository.saveWatchlist(testTvDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}
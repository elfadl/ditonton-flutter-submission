import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTvTable = TvTable(
  id: 90462,
  name: 'Chucky',
  posterPath: '/kY0BogCM8SkNJ0MNiHB3VTM86Tz.jpg',
  overview:
      'After a vintage Chucky doll turns up at a suburban yard sale, an idyllic American town is thrown into chaos as a series of horrifying murders begin to expose the town’s hypocrisies and secrets. Meanwhile, the arrival of enemies — and allies — from Chucky’s past threatens to expose the truth behind the killings, as well as the demon doll’s untold origins.',
);

final testTvMap = {
  'id': 90462,
  'name': 'Chucky',
  'posterPath': '/kY0BogCM8SkNJ0MNiHB3VTM86Tz.jpg',
  'overview':
      'After a vintage Chucky doll turns up at a suburban yard sale, an idyllic American town is thrown into chaos as a series of horrifying murders begin to expose the town’s hypocrisies and secrets. Meanwhile, the arrival of enemies — and allies — from Chucky’s past threatens to expose the truth behind the killings, as well as the demon doll’s untold origins.',
};

final testTv = Tv(
  backdropPath: "/5kkw5RT1OjTAMh3POhjo5LdaACZ.jpg",
  firstAirDate: "2021-10-12",
  genreIds: [80, 10765],
  id: 90462,
  name: "Chucky",
  originCountry: ["US"],
  originalLanguage: "en",
  originalName: "Chucky",
  overview:
      "After a vintage Chucky doll turns up at a suburban yard sale, an idyllic American town is thrown into chaos as a series of horrifying murders begin to expose the town’s hypocrisies and secrets. Meanwhile, the arrival of enemies — and allies — from Chucky’s past threatens to expose the truth behind the killings, as well as the demon doll’s untold origins.",
  popularity: 2532.47,
  posterPath: "/kY0BogCM8SkNJ0MNiHB3VTM86Tz.jpg",
  voteAverage: 7.9,
  voteCount: 3463,
);

final testTvList = [testTv];

final testTvDetail = TvDetail(
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

final testWatchlistTv = Tv.watchlist(
  id: 90462,
  name: 'Chucky',
  posterPath: '/kY0BogCM8SkNJ0MNiHB3VTM86Tz.jpg',
  overview:
      'After a vintage Chucky doll turns up at a suburban yard sale, an idyllic American town is thrown into chaos as a series of horrifying murders begin to expose the town’s hypocrisies and secrets. Meanwhile, the arrival of enemies — and allies — from Chucky’s past threatens to expose the truth behind the killings, as well as the demon doll’s untold origins.',
);

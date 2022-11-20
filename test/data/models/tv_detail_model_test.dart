import 'dart:convert';

import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvDetailModel = TvDetailResponse(
      adult: false,
      backdropPath: '/pysGisnLhmjQB2CGQCAQDxBADsH.jpg',
      episodeRunTime: [42],
      firstAirDate: "2021-10-12",
      genres: [GenreModel(id: 1, name: 'Action')],
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
        SeasonModel(
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
      voteCount: 3463
  );

  final tTvDetail = TvDetail(
      adult: false,
      backdropPath: '/pysGisnLhmjQB2CGQCAQDxBADsH.jpg',
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
      voteCount: 3463
  );

  test('should be a subclass of TvDetail entity', () async {
    final result = tTvDetailModel.toEntity();
    expect(result, tTvDetail);
  });

  test('should be return genre json', () async {
    final result = tTvDetailModel.toJson();
    final json = jsonDecode(readJson('dummy_data/tv_detail.json'));
    expect(result, json);
  });
}

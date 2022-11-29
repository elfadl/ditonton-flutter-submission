import 'dart:convert';

import 'package:core/data/models/season_model.dart';
import 'package:core/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  const tSeasonModel = SeasonModel(
    airDate: "2021-10-12",
    episodeCount: 8,
    id: 126146,
    name: "Season 1",
    overview: "",
    posterPath: "/iF8ai2QLNiHV4anwY1TuSGZXqfN.jpg",
    seasonNumber: 1,
  );

  const tSeason = Season(
    airDate: "2021-10-12",
    episodeCount: 8,
    id: 126146,
    name: "Season 1",
    overview: "",
    posterPath: "/iF8ai2QLNiHV4anwY1TuSGZXqfN.jpg",
    seasonNumber: 1,
  );

  test('should be a subclass of Season entity', () async {
    final result = tSeasonModel.toEntity();
    expect(result, tSeason);
  });

  test('should be return genre json', () async {
    final result = tSeasonModel.toJson();
    final json = jsonDecode(readJson('dummy_data/season.json'));
    expect(result, json);
  });
}

import 'dart:convert';

import 'package:core/data/models/movie_detail_model.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {

  const tMovieDetail = MovieDetailResponse(
      adult: false,
      backdropPath: "/path.jpg",
      budget: 100,
      genres: [GenreModel(id: 1, name: "Action")],
      homepage: "https://google.com",
      id: 1,
      imdbId: "imdb1",
      originalLanguage: "en",
      originalTitle: "Original Title",
      overview: "Overview",
      popularity: 1.0,
      posterPath: "/path.jpg",
      releaseDate: "2020-05-05",
      revenue: 12000,
      runtime: 120,
      status: "Status",
      tagline: "Tagline",
      title: "Title",
      video: false,
      voteAverage: 1.0,
      voteCount: 1
  );

  test('should be return movie detail json', () async {
    final result = tMovieDetail.toJson();
    final json = jsonDecode(readJson('dummy_data/movie_detail.json'));
    expect(result, json);
  });
}

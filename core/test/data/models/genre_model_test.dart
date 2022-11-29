import 'dart:convert';

import 'package:core/data/models/genre_model.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  const tGenreModel = GenreModel(
    id: 1,
    name: 'Action',
  );

  const tGenre = Genre(
    id: 1,
    name: 'Action',
  );

  test('should be a subclass of Genre entity', () async {
    final result = tGenreModel.toEntity();
    expect(result, tGenre);
  });

  test('should be return genre json', () async {
    final result = tGenreModel.toJson();
    final json = jsonDecode(readJson('dummy_data/genre.json'));
    expect(result, json);
  });
}

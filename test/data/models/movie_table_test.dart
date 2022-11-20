import 'dart:convert';

import 'package:ditonton/data/models/movie_table.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tMovieTable = MovieTable(
    id: 1,
    overview: 'overview',
    posterPath: '/path.jpg',
    title: 'title',
  );

  test('should be return genre json', () async {
    final result = tMovieTable.toJson();
    final json = jsonDecode(readJson('dummy_data/movie_table.json'));
    expect(result, json);
  });
}

import 'dart:convert';

import 'package:ditonton/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvTable = TvTable(
    id: 1,
    overview: 'overview',
    posterPath: '/path.jpg',
    name: 'name',
  );

  test('should be return TV Table json', () async {
    final result = tTvTable.toJson();
    final json = jsonDecode(readJson('dummy_data/tv_table.json'));
    expect(result, json);
  });
}

import 'package:core/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../dummy_data/dummy_objects.dart';

void sqfliteTestInit() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

Future main() async {
  late Database db;
  late DatabaseHelper databaseHelper;
  const String tblWatchlist = 'watchlist';
  const String tblWatchlistTv = 'watchlistTv';

  setUp(() async {
    sqfliteFfiInit();

    databaseHelper = DatabaseHelper();
    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await db.execute('''
      CREATE TABLE  $tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE  $tblWatchlistTv (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  });

  final tMovieTableId = testMovieTable.id;
  final tTvTableId = testTvTable.id;

  group('Movie DB test', () {
    test('should return movie id when do insert', () async {
      final result = await databaseHelper.insertWatchlist(testMovieTable, databaseTest: db);

      expect(result, tMovieTableId);
      db.close();
    });

    test('should return count when do delete', () async {
      await databaseHelper.insertWatchlist(testMovieTable, databaseTest: db);
      final result = await databaseHelper.removeWatchlist(testMovieTable, databaseTest: db);

      expect(result, tMovieTableId);
      db.close();
    });

    test('should return movie table when data is found', () async {
      await databaseHelper.insertWatchlist(testMovieTable, databaseTest: db);
      final result = await databaseHelper.getMovieById(tMovieTableId, databaseTest: db);

      expect(result, testMovieTable.toJson());
      db.close();
    });

    test('should return null when data is not found', () async {
      await databaseHelper.insertWatchlist(testMovieTable, databaseTest: db);
      final result = await databaseHelper.getMovieById(2, databaseTest: db);

      expect(result, null);
      db.close();
    });

    test('should return list of movie map when getting watchlist', () async {
      await databaseHelper.insertWatchlist(testMovieTable, databaseTest: db);
      final result = await databaseHelper.getWatchlistMovies(databaseTest: db);

      expect(result, [testMovieMap]);
      db.close();
    });
  });

  group('TV DB test', () {
    test('should return tv id when do insert', () async {
      final result = await databaseHelper.insertWatchlistTv(testTvTable, databaseTest: db);

      expect(result, tTvTableId);
      db.close();
    });

    test('should return count when do delete', () async {
      await databaseHelper.insertWatchlistTv(testTvTable, databaseTest: db);
      final result = await databaseHelper.removeWatchlistTv(testTvTable, databaseTest: db);

      expect(result, 1);
      db.close();
    });

    test('should return tv table when data is found', () async {
      await databaseHelper.insertWatchlistTv(testTvTable, databaseTest: db);
      final result = await databaseHelper.getTvById(tTvTableId, databaseTest: db);

      expect(result, testTvTable.toJson());
      db.close();
    });

    test('should return null when data is not found', () async {
      await databaseHelper.insertWatchlistTv(testTvTable, databaseTest: db);
      final result = await databaseHelper.getTvById(2, databaseTest: db);

      expect(result, null);
      db.close();
    });

    test('should return list of tv map when getting watchlist', () async {
      await databaseHelper.insertWatchlistTv(testTvTable, databaseTest: db);
      final result = await databaseHelper.getWatchlistTv(databaseTest: db);

      expect(result, [testTvMap]);
    });
  });
}
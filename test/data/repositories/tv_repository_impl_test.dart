import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvModel = TvModel(
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

  final tTv = Tv(
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

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];

  group('Now Playing Tv', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getNowPlayingTv())
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.getNowPlayingTvs();

      verify(mockRemoteDataSource.getNowPlayingTv());

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getNowPlayingTv()).thenThrow(ServerException());

      final result = await repository.getNowPlayingTvs();

      verify(mockRemoteDataSource.getNowPlayingTv());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTv())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getNowPlayingTvs();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTv());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Popular Tv', () {
    test('should return tv list when call to data source is success', () async {
      when(mockRemoteDataSource.getTvPopular())
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.getPopularTvs();

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTvPopular()).thenThrow(ServerException());

      final result = await repository.getPopularTvs();

      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      when(mockRemoteDataSource.getTvPopular())
          .thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.getPopularTvs();

      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Tv', () {
    test('should return tv list when call to data source is successful',
        () async {
      when(mockRemoteDataSource.getTvTopRated())
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.getTopRatedTvs();

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTvTopRated()).thenThrow(ServerException());

      final result = await repository.getTopRatedTvs();

      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      when(mockRemoteDataSource.getTvTopRated())
          .thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.getTopRatedTvs();

      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Tv Detail', () {
    final tId = 1;
    final tTvResponse = TvDetailResponse(
        adult: false,
        backdropPath: 'backdropPath',
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
        voteCount: 3463);

    test(
        'should return Tv data when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getTvDetail(tId))
          .thenAnswer((_) async => tTvResponse);

      final result = await repository.getTvDetail(tId);

      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result, equals(Right(testTvDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTvDetail(tId)).thenThrow(ServerException());

      final result = await repository.getTvDetail(tId);

      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Tv Recommendations', () {
    final tTvList = <TvModel>[];
    final tId = 1;

    test('should return data (tv list) when the call is successful', () async {
      when(mockRemoteDataSource.getTvRecommendations(tId))
          .thenAnswer((_) async => tTvList);

      final result = await repository.getTvRecommendations(tId);

      verify(mockRemoteDataSource.getTvRecommendations(tId));

      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTvRecommendations(tId))
          .thenThrow(ServerException());

      final result = await repository.getTvRecommendations(tId);

      verify(mockRemoteDataSource.getTvRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      when(mockRemoteDataSource.getTvRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.getTvRecommendations(tId);

      verify(mockRemoteDataSource.getTvRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('get watchlist tv', () {
    test('should return list of tv', () async {
      when(mockLocalDataSource.getWatchlistTv())
          .thenAnswer((_) async => [testTvTable]);

      final result = await repository.getWatchlistTvs();

      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      final tId = 1;
      when(mockLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);

      final result = await repository.isAddedToWatchlist(tId);

      expect(result, false);
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      when(mockLocalDataSource.removeWatchlist(testTvTable))
          .thenAnswer((_) async => 'Removed from watchlist');

      final result = await repository.removeWatchlist(testTvDetail);

      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      when(mockLocalDataSource.removeWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));

      final result = await repository.removeWatchlist(testTvDetail);

      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      when(mockLocalDataSource.insertWatchlist(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');

      final result = await repository.saveWatchlist(testTvDetail);

      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      when(mockLocalDataSource.insertWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));

      final result = await repository.saveWatchlist(testTvDetail);

      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('Seach Tvs', () {
    final tQuery = 'hulk';

    test('should return tv list when call to data source is successful',
        () async {
      when(mockRemoteDataSource.searchTv(tQuery))
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.searchTvs(tQuery);

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.searchTv(tQuery)).thenThrow(ServerException());

      final result = await repository.searchTvs(tQuery);

      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      when(mockRemoteDataSource.searchTv(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.searchTvs(tQuery);

      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });
}

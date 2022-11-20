import 'dart:convert';
import 'dart:io';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=234ffe4d9601620464cdcdcd674bd21c';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing Tv', () {
    final tTvList = TvResponse.fromJson(
            json.decode(readJson('dummy_data/tv_on_the_air.json')))
        .tvList;

    test('should return list of Tv Model when the response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                  readJson('dummy_data/tv_on_the_air.json'), 200,
                  headers: {
                    HttpHeaders.contentTypeHeader:
                        'application/json; charset=utf-8',
                  }));

      final result = await dataSource.getNowPlayingTv();

      expect(result, equals(tTvList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 400));

      final call = dataSource.getNowPlayingTv();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv detail', () {
    final tId = 90462;
    final tTvDetail = TvDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_detail.json')));

    test('should return tv detail when the response code is 200', () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                  readJson('dummy_data/tv_detail.json'), 200,
                  headers: {
                    HttpHeaders.contentTypeHeader:
                        'application/json; charset=utf-8',
                  }));

      final result = await dataSource.getTvDetail(tId);

      expect(result, equals(tTvDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTvDetail(tId);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv recommendations', () {
    final tTvList = TvResponse.fromJson(
            json.decode(readJson('dummy_data/tv_recommendations.json')))
        .tvList;
    final tId = 99966;

    test('should return list of Tv Model when the response code is 200',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                  readJson('dummy_data/tv_recommendations.json'), 200,
                  headers: {
                    HttpHeaders.contentTypeHeader:
                        'application/json; charset=utf-8',
                  }));

      final result = await dataSource.getTvRecommendations(tId);

      expect(result, equals(tTvList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTvRecommendations(tId);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get popular Tv', () {
    final tTvList =
        TvResponse.fromJson(json.decode(readJson('dummy_data/tv_popular.json')))
            .tvList;

    test('should return list of tvs when response is success (200)', () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                  readJson('dummy_data/tv_popular.json'), 200,
                  headers: {
                    HttpHeaders.contentTypeHeader:
                        'application/json; charset=utf-8',
                  }));

      final result = await dataSource.getTvPopular();

      expect(result, equals(tTvList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTvPopular();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get top rated Tv', () {
    final tTvList = TvResponse.fromJson(
            json.decode(readJson('dummy_data/tv_top_rated.json')))
        .tvList;

    test('should return list of tvs when response is success (200)', () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                  readJson('dummy_data/tv_top_rated.json'), 200,
                  headers: {
                    HttpHeaders.contentTypeHeader:
                        'application/json; charset=utf-8',
                  }));

      final result = await dataSource.getTvTopRated();

      expect(result, equals(tTvList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTvTopRated();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search Tv', () {
    final tSearchResult = TvResponse.fromJson(
            json.decode(readJson('dummy_data/search_hulk_tv.json')))
        .tvList;
    final tQuery = 'hulk';

    test('should return list of tvs when response is success (200)', () async {
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?query=$tQuery&$API_KEY')))
          .thenAnswer((_) async => http.Response(
                  readJson('dummy_data/search_hulk_tv.json'), 200,
                  headers: {
                    HttpHeaders.contentTypeHeader:
                        'application/json; charset=utf-8',
                  }));

      final result = await dataSource.searchTv(tQuery);

      expect(result, equals(tSearchResult));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?query=$tQuery&$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.searchTv(tQuery);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

}

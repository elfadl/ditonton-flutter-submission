
// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../utils/exception.dart';
import '../models/tv_detail_model.dart';
import '../models/tv_model.dart';
import '../models/tv_response.dart';

abstract class TvRemoteDataSource{
  Future<List<TvModel>> getNowPlayingTv();
  Future<TvDetailResponse> getTvDetail(int id);
  Future<List<TvModel>> getTvRecommendations(int id);
  Future<List<TvModel>> getTvPopular();
  Future<List<TvModel>> getTvTopRated();
  Future<List<TvModel>> searchTv(String query);
}

class TvRemoteDataSourceImpl implements TvRemoteDataSource{
  static const API_KEY = 'api_key=234ffe4d9601620464cdcdcd674bd21c';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvModel>> getNowPlayingTv() async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));

    if(response.statusCode == 200){
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    }else{
      throw ServerException();
    }
  }

  @override
  Future<TvDetailResponse> getTvDetail(int id) async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if(response.statusCode == 200){
      return TvDetailResponse.fromJson(json.decode(response.body));
    }else{
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvRecommendations(int id) async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));

    if(response.statusCode == 200){
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    }else{
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvPopular() async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));

    if(response.statusCode == 200){
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    }else{
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvTopRated() async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));

    if(response.statusCode == 200){
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    }else{
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> searchTv(String query) async {
    final response = await client.get(Uri.parse('$BASE_URL/search/tv?query=$query&$API_KEY'));

    if(response.statusCode == 200){
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    }else{
      throw ServerException();
    }
  }

}
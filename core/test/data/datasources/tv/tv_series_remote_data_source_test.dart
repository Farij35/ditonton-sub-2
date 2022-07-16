import 'dart:convert';
import 'dart:io';
import 'package:core/data/datasources/tv_series/tv_series_remote_data_source.dart';
import 'package:core/data/models/tv/tv_series_detail_model.dart';
import 'package:core/data/models/tv/tv_series_response.dart';
import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../../json_reader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Tv Series On Air', () {
    final tTvList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv/tv_series_on_air.json')))
        .tvSeriesList;

    test('should return list of Tv Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv/tv_series_on_air.json'), 200));
      // act
      final result = await dataSource.getTvSeriesOnAirApi();
      // assert
      expect(result, equals(tTvList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvSeriesOnAirApi();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular Tv Shows', () {
    final tTvList =
        TvSeriesResponse.fromJson(json.decode(readJson('dummy_data/tv/tv_series_popular.json')))
            .tvSeriesList;

    test('should return list of tv when response is success 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv/tv_series_popular.json'), 200));
      // act
      final result = await dataSource.getPopularTvSeriesApi();
      // assert
      expect(result, equals(tTvList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularTvSeriesApi();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated Tv Series', () {
    final tTvList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv/tv_series_top_rated.json')))
        .tvSeriesList;

    test('should return list of tv when response code is 200 ', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv/tv_series_top_rated.json'), 200));
      // act
      final result = await dataSource.getTopRatedTvSeriesApi();
      // assert
      expect(result, equals(tTvList));
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedTvSeriesApi();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv series detail', () {
    final tId = 1;
    final tTvDetail = TvSeriesDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv/tv_series_detail.json')));

    test('should return tv detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv/tv_series_detail.json'), 200, headers: {HttpHeaders.contentTypeHeader: "application/json; charset=utf-8"}));
      // act
      final result = await dataSource.getTvSeriesDetailApi(tId);
      // assert
      expect(result, equals(tTvDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvSeriesDetailApi(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv series recommendations', () {
    final tTvList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv/tv_series_recommendations.json')))
        .tvSeriesList;
    final tId = 1;

    test('should return list of Tv Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv/tv_series_recommendations.json'), 200));
      // act
      final result = await dataSource.getTvSeriesRecommendationsApi(tId);
      // assert
      expect(result, equals(tTvList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvSeriesRecommendationsApi(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tv series', () {
    final tSearchResult = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv/search_the_boys_tv.json')))
        .tvSeriesList;
    final tQuery = 'The Boys';

    test('should return list of tv when response code is 200', () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv/search_the_boys_tv.json'), 200));
      // act
      final result = await dataSource.searchTvSeriesApi(tQuery);
      // assert
      expect(result, equals(tSearchResult));
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchTvSeriesApi(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}

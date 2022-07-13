import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv_series.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_series.dart';
import 'package:ditonton/presentation/provider/tv/tv_series_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'tv_series_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late TvSeriesSearchNotifier provider;
  late MockSearchTvSeries mockSearchTvSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTvSeries = MockSearchTvSeries();
    provider = TvSeriesSearchNotifier(searchTvSeries: mockSearchTvSeries)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final testTvModel = TvSeries(
    backdropPath: '/n6vVs6z8obNbExdD3QHTr4Utu1Z.jpg',
    genreIds: [1, 2],
    id: 1,
    overview: 'overview',
    popularity: 1.0,
    posterPath: '/stTEycfG9928HYGEISBFaG1ngjM.jpg',
    voteAverage: 1,
    voteCount: 1,
    name: 'The Boys',
    originalLanguage: 'en',
    originalName: 'The Boys',
  );
  final testTvList = <TvSeries>[testTvModel];
  final testQuery = 'The Boys';

  group('search tv shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchTvSeries.execute(testQuery))
          .thenAnswer((_) async => Right(testTvList));
      // act
      provider.fetchTvSeriesSearch(testQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchTvSeries.execute(testQuery))
          .thenAnswer((_) async => Right(testTvList));
      // act
      await provider.fetchTvSeriesSearch(testQuery);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, testTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTvSeries.execute(testQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvSeriesSearch(testQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}

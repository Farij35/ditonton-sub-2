import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/tv/search_tv_series.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'search_bloc_tv_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late SearchBlocTvSeries searchBlocTvSeries;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    searchBlocTvSeries = SearchBlocTvSeries(mockSearchTvSeries);
  });

  test('initial state should be empty', () {
    expect(searchBlocTvSeries.state, SearchEmpty());
  });

  final testTvModel = TvSeries(
    backdropPath: '/n6vVs6z8obNbExdD3QHTr4Utu1Z.jpg',
    genreIds: const [1, 2],
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
  final tTvSeries = <TvSeries>[testTvModel];
  // ignore: prefer_const_declarations
  final tQuery = 'The Boys';

  blocTest<SearchBlocTvSeries, SearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTvSeries));
      return searchBlocTvSeries;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchHasDataForTvSeries(tTvSeries),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );

  blocTest<SearchBlocTvSeries, SearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchBlocTvSeries;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      const SearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
}
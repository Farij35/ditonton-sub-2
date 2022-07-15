import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/search.dart';
part 'event/search_event.dart';
part 'state/search_state.dart';

class SearchBlocMovie extends Bloc<SearchEvent, SearchState> {
  final SearchMovies _searchMovies;

  SearchBlocMovie(this._searchMovies) : super(SearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchLoading());
      final result = await _searchMovies.execute(query);

      result.fold(
        (failure) {
          emit(SearchError(failure.message));
        },
        (data) {
          emit(SearchHasDataForMovie(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

class SearchBlocTvSeries extends Bloc<SearchEvent, SearchState> {
  final SearchTvSeries _searchTvSeries;

  SearchBlocTvSeries(this._searchTvSeries) : super(SearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchLoading());
      final result = await _searchTvSeries.execute(query);

      result.fold(
        (failure) {
          emit(SearchError(failure.message));
        },
        (data) {
          emit(SearchHasDataForTvSeries(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}

//   @override
//   Stream<SearchState> mapEventToState(
//       SearchEvent event,
//       ) async* {
//     if (event is OnQueryChanged) {
//       final query = event.query;
//
//       yield SearchLoading();
//       final result = await _searchMovies.execute(query);
//
//       yield* result.fold(
//             (failure) async* {
//           yield SearchError(failure.message);
//         },
//             (data) async* {
//           yield SearchHasDataForMovie(data);
//         },
//       );
//     }
//   }
//
//   @override
//   Stream<Transition<SearchEvent, SearchState>> transformEvents(
//       Stream<SearchEvent> events,
//       // ignore: deprecated_member_use
//       TransitionFunction<SearchEvent, SearchState> transitionFn,
//       ) {
//     // ignore: deprecated_member_use
//     return super.transformEvents(
//       events.debounceTime(const Duration(milliseconds: 500)),
//       transitionFn,
//     );
//   }
// }
//
// class SearchBlocTvSeries extends Bloc<SearchEvent, SearchState> {
//   // ignore: unused_field
//   final SearchTvSeries _searchTVSeries;
//
//   SearchBlocTvSeries(this._searchTVSeries) : super(SearchEmpty());
//
//   @override
//   Stream<SearchState> mapEventToState(
//       SearchEvent event,
//       ) async* {
//     if (event is OnQueryChanged) {
//       final query = event.query;
//
//       yield SearchLoading();
//       final result = await _searchTVSeries.execute(query);
//
//       yield* result.fold(
//             (failure) async* {
//           yield SearchError(failure.message);
//         },
//             (data) async* {
//           yield SearchHasDataForTvSeries(data);
//         },
//       );
//     }
//   }
//
//   @override
//   Stream<Transition<SearchEvent, SearchState>> transformEvents(
//       Stream<SearchEvent> events,
//       // ignore: deprecated_member_use
//       TransitionFunction<SearchEvent, SearchState> transitionFn,
//       ) {
//     // ignore: deprecated_member_use
//     return super.transformEvents(
//       events.debounceTime(const Duration(milliseconds: 500)),
//       transitionFn,
//     );
//   }
// }
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetWatchlistTvStatus {
  final TvRepository repository;

  GetWatchlistTvStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToTvWatchlist(id);
  }
}
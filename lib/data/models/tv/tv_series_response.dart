// ignore_for_file: non_constant_identifier_names

import 'package:ditonton/data/models/tv/tv_series_model.dart';
import 'package:equatable/equatable.dart';

class TvSeriesResponse extends Equatable {
  final List<TvSeriesModel> TvSeriesList;

  TvSeriesResponse({required this.TvSeriesList});

  factory TvSeriesResponse.fromJson(Map<String, dynamic> json) => TvSeriesResponse(
        TvSeriesList: List<TvSeriesModel>.from((json['results'] as List)
            .map((x) => TvSeriesModel.fromJson(x))
            .where((element) => element.posterPath != null)),
      );

  Map<String, dynamic> toJson() => {
        'results': List<dynamic>.from(TvSeriesList.map((x) => x.toJson())),
      };

  @override
  List<Object> get props => [TvSeriesList];
}

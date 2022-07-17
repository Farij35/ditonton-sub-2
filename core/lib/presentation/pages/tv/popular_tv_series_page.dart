import 'package:core/presentation/bloc/tv/tv_popular_bloc.dart';
import 'package:core/presentation/widgets/tv/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  @override
  _PopularTvSeriesPageState createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      context.read<TvPopularBloc>().add(TvPopularHasDataEvent())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvPopularBloc, TvPopularState>(
            builder: (context, state) {
              if (state is TvPopularLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TvPopularHasData) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final tv = state.result[index];
                    return TvSeriesCard(tv);
                  },
                );
              } else if (state is TvPopularError) {
                return Expanded(
                  child: Center(
                    child: Text(state.message),
                  ),
                );
              } else {
                return Expanded(
                  child: Container(),
                );
              }
            }
        ),
      ),
    );
  }
}

import 'package:core/presentation/bloc/movie/movie_watchlist_bloc.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<MovieWatchlistBloc>().add(MovieWatchlistHasDataEvent()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<MovieWatchlistBloc>().add(MovieWatchlistHasDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieWatchlistBloc, MovieWatchlistState>(
          builder: (context, state) {
            if (state is MovieWatchlistLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MovieWatchlistHasData) {
              final result = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return MovieCard(movie);
                },
                itemCount: result.length,
              );
            } else if (state is MovieWatchlistError) {
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
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

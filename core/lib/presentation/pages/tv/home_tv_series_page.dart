import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:core/presentation/bloc/tv/tv_on_air_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_popular_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_top_rated_bloc.dart';
import 'package:core/presentation/pages/home_movie_page.dart';
import 'package:core/presentation/pages/tv/watchlist_tv_series_page.dart';
import 'package:core/presentation/pages/watchlist_movies_page.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/constants.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTvSeriesPage extends StatefulWidget {
  const HomeTvSeriesPage({super.key});

  @override
  _HomeTvSeriesPageState createState() => _HomeTvSeriesPageState();
}

class _HomeTvSeriesPageState extends State<HomeTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvOnAirBloc>().add(TvOnAirEventHasData());
    context.read<TvPopularBloc>().add(TvPopularHasDataEvent());
    context.read<TvTopRatedBloc>().add(TvTopRatedHasDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeMoviePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv_rounded),
              title: const Text('TV Series'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist Movie'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: const Icon(Icons.system_update_tv_rounded),
              title: const Text('Watchlist TV Series'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTvSeriesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ABOUT_ROUTE);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SEARCH_ROUTE_TV);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'On Air',
                    style: kHeading6,
                  ),
                  BlocBuilder<TvOnAirBloc, TvOnAirState>(
                      builder: (context, state) {
                        if (state is TvOnAirLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is TvOnAirHasData) {
                          return TvList(state.result);
                        } else if (state is TvOnAirError) {
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
                      }),
                  _buildSubHeading(
                    title: 'Popular',
                    onTap: () =>
                        Navigator.pushNamed(context, POPULAR_TV_ROUTE),
                  ),
                  BlocBuilder<TvPopularBloc, TvPopularState>(
                      builder: (context, state) {
                        if (state is TvPopularLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is TvPopularHasData) {
                          return TvList(state.result);
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
                      }),
                  _buildSubHeading(
                    title: 'Top Rated',
                    onTap: () => Navigator.pushNamed(
                        context, TV_TOP_RATED_ROUTE),
                  ),
                  BlocBuilder<TvTopRatedBloc, TvTopRatedState>(
                      builder: (context, state) {
                        if (state is TvTopRatedLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is TvTopRatedHasData) {
                          return TvList(state.result);
                        } else if (state is TvTopRatedError) {
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvList extends StatelessWidget {
  final List<TvSeries> tvShows;

  const TvList(this.tvShows, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvShows[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TV_DETAIL_ROUTE,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvShows.length,
      ),
    );
  }
}

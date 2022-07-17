import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv/tv_series.dart';
import 'package:core/domain/entities/tv/tv_series_detail.dart';
import 'package:core/presentation/bloc/tv/tv_detail_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_recommendation_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_watchlist_bloc.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-detail';

  final int id;
  TvSeriesDetailPage({required this.id});

  @override
  _TvSeriesDetailPageState createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailBloc>().add(TvDetailHasDataEvent(widget.id));
      context.read<TvRecommendationBloc>().add(TvRecommendationEventHasData(widget.id));
      context.read<TvWatchlistBloc>().add(LoadTvWatchlistStatusDataEvent(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    bool addToWatchlistTv = context.select<TvWatchlistBloc, bool>(
            (value) => (value.state is LoadTvWatchlistStatus)
            ? (value.state as LoadTvWatchlistStatus).status
            : (value.state is LoadTvWatchlistStatus)
            ? false
            : true);
    return WillPopScope(
      onWillPop: () async {
        context.read<TvWatchlistBloc>().add(TvWatchlistHasDataEvent());
        return true;
      },
      child: Scaffold(
          body: SizedBox(
            child: BlocBuilder<TvDetailBloc, TvDetailState>(
              builder: (context, state) {
                if (state is TvDetailLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvDetailHasData) {
                  final tv = state.result;
                  TvRecommendationState tvRecommendationState = context.watch<TvRecommendationBloc>().state;
                  return SafeArea(
                    child: DetailContent(
                      tv,
                      tvRecommendationState is TvRecommendationHasData
                          ? tvRecommendationState.result
                          : List.empty(),
                      addToWatchlistTv,
                    ),
                  );
                } else if (state is TvDetailError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else {
                  return const Center(child: Text(""));
                }
              },
            ),
          )
      ),
    );
  }
}

class DetailContent extends StatefulWidget {
  final TvSeriesDetail tv;
  final List<TvSeries> recommendations;
  bool isAddedWatchlist;

  DetailContent(this.tv, this.recommendations, this.isAddedWatchlist);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  final tvWatchListAddSuccessMessage = 'Added to Watchlist';
  final tvWatchListRemoveSuccessMessage = 'Removed from Watchlist';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${widget.tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tv.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (!widget.isAddedWatchlist) {
                                  context.read<TvWatchlistBloc>().add(
                                      AddTvWatchlistDataEvent(widget.tv)
                                  );
                                } else {
                                  context.read<TvWatchlistBloc>().add(
                                      RemoveTvWatchlistDataEvent(widget.tv)
                                  );
                                }
                                final message =
                                context.select<TvWatchlistBloc, String>((value) => (value.state is TvWatchlistStatus)
                                    ? (value.state as TvWatchlistStatus).status == false
                                    ? tvWatchListAddSuccessMessage
                                    : tvWatchListRemoveSuccessMessage
                                    : !widget.isAddedWatchlist
                                    ? tvWatchListAddSuccessMessage
                                    : tvWatchListRemoveSuccessMessage);

                                if (message == tvWatchListAddSuccessMessage || message == tvWatchListRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      }
                                  );
                                }
                                setState(() {
                                  widget.isAddedWatchlist =
                                  !widget.isAddedWatchlist;
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(widget.tv.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.tv.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              widget.tv.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvRecommendationBloc, TvRecommendationState>(
                              builder: (context, state) {
                                if (state is TvRecommendationLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is TvRecommendationError) {
                                  return Text(state.message);
                                } else if (state is TvRecommendationHasData) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv = widget.recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvSeriesDetailPage.ROUTE_NAME,
                                                arguments: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                                placeholder: (context, url) =>
                                                const Center(
                                                  child:
                                                  CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: widget.recommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}

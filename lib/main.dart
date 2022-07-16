import 'package:core/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:core/presentation/bloc/movie/movie_now_playing_bloc.dart';
import 'package:core/presentation/bloc/movie/movie_popular_bloc.dart';
import 'package:core/presentation/bloc/movie/movie_recommendation_bloc.dart';
import 'package:core/presentation/bloc/movie/movie_top_rated_bloc.dart';
import 'package:core/presentation/bloc/movie/movie_watchlist_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_detail_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_on_air_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_popular_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_recommendation_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_top_rated_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_watchlist_bloc.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/utils.dart';
import 'package:about/about_page.dart';
import 'package:core/presentation/pages/movie_detail_page.dart';
import 'package:core/presentation/pages/home_movie_page.dart';
import 'package:core/presentation/pages/popular_movies_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/presentation/pages/search_page_movies.dart';
import 'package:core/presentation/pages/top_rated_movies_page.dart';
import 'package:core/presentation/pages/tv/home_tv_series_page.dart';
import 'package:core/presentation/pages/tv/popular_tv_series_page.dart';
import 'package:search/presentation/pages/tv/search_page_tv_series.dart';
import 'package:core/presentation/pages/tv/top_rated_tv_series_page.dart';
import 'package:core/presentation/pages/tv/tv_detail_page.dart';
import 'package:core/presentation/pages/tv/watchlist_tv_series_page.dart';
import 'package:core/presentation/pages/watchlist_movies_page.dart';
import 'package:core/utils/ssl_pinning.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HttpSSLPinning.init();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<SearchBlocMovie>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchBlocTvSeries>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieRecommendationBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieWatchlistBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieNowPlayingBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MoviePopularBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieTopRatedBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvRecommendationBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvWatchlistBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvOnAirBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvPopularBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvTopRatedBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case '/home-tv':
              return MaterialPageRoute(builder: (_) => HomeTvSeriesPage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPageMovies.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPageMovies());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case PopularTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvSeriesPage());
            case TopRatedTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvSeriesPage());
            case WatchlistTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvSeriesPage());
            case SearchPageTvSeries.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPageTvSeries());
            case TvSeriesDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}

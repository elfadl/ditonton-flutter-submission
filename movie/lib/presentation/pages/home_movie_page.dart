// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_now_playing/movie_now_playing_bloc.dart';
import 'package:movie/presentation/bloc/movie_popular/movie_popular_bloc.dart';
import 'package:movie/presentation/bloc/movie_top_rated/movie_top_rated_bloc.dart';

import 'movie_detail_page.dart';
import 'popular_movies_page.dart';
import 'top_rated_movies_page.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({super.key});

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieNowPlayingBloc>().add(FetchNowPlayingMovies());
      context.read<MoviePopularBloc>().add(FetchPopularMovies());
      context.read<MovieTopRatedBloc>().add(FetchTopRatedMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Now Playing',
              style: kHeading6,
            ),
            BlocBuilder<MovieNowPlayingBloc, MovieNowPlayingState>(
                builder: (context, state) {
              if (state is MovieNowPlayingLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is MovieNowPlayingHasData) {
                final result = state.result;
                return MovieList(result, 'now_playing_movie');
              } else if (state is MovieNowPlayingError) {
                return Text(state.message);
              } else {
                return const Text('Failed');
              }
            }),
            _buildSubHeading(
              title: 'Popular',
              onTap: () =>
                  Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
            ),
            BlocBuilder<MoviePopularBloc, MoviePopularState>(
                builder: (context, state) {
              if (state is MoviePopularLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is MoviePopularHasData) {
                return MovieList(state.result, 'popular_movie');
              } else if (state is MoviePopularError) {
                return Text(state.message);
              } else {
                return const Text('Failed');
              }
            }),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () =>
                  Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
            ),
            BlocBuilder<MovieTopRatedBloc, MovieTopRatedState>(
                builder: (context, state) {
              if (state is MovieTopRatedLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is MovieTopRatedHasData) {
                return MovieList(state.result, 'top_rated_movie');
              } else if (state is MovieTopRatedError) {
                return Text(state.message);
              } else {
                return const Text('Failed');
              }
            }),
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
              children: const [
                Text('See More'),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  final String type;

  const MovieList(this.movies, this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        key: ValueKey(type),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            key: ValueKey('$type$index'),
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}

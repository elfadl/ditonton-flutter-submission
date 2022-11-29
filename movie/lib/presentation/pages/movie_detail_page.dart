// ignore_for_file: constant_identifier_names, library_private_types_in_public_api, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_recommendations/movie_recommendations_bloc.dart';

import '../bloc/movie_watchlist/movie_watchlist_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-movie';

  final int id;

  const MovieDetailPage({super.key, required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailBloc>().add(FetchDetailMovies(widget.id));
      context
          .read<MovieRecommendationsBloc>()
          .add(FetchRecommendationsMovies(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(
                key: Key('movie_loading'),
              ),
            );
          } else if (state is MovieDetailHasData) {
            final movie = state.result;
            final isAddedToWatchlist = state.isAddedToWatchlist;
            return SafeArea(
              child: DetailContent(
                movie: movie,
                isAddedWatchlist: isAddedToWatchlist,
              ),
            );
          } else if (state is MovieDetailError) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      state.message,
                      key: const Key('movie_error'),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Text('Failed');
          }
        },
      ),
    );
  }
}

class DetailContent extends StatefulWidget {
  final MovieDetail movie;
  late bool isAddedWatchlist;

  DetailContent(
      {required this.movie, required this.isAddedWatchlist, super.key});

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.isAddedWatchlist) {
        context.read<MovieWatchlistBloc>().add(MovieIsAddedToWatchList());
      } else {
        context.read<MovieWatchlistBloc>().add(MovieIsRemovedFromWatchList());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          key: const ValueKey('poster'),
          imageUrl: 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
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
                              widget.movie.title,
                              style: kHeading5,
                              key: const Key('movie_title'),
                            ),
                            BlocListener<MovieWatchlistBloc,
                                MovieWatchlistState>(
                              listener: (context, state) {
                                String message = "";

                                message = state.message;

                                if (message ==
                                        MovieWatchlistBloc
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        MovieWatchlistBloc
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                } else if (message.isNotEmpty) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
                              },
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (widget.isAddedWatchlist) {
                                    context.read<MovieWatchlistBloc>().add(
                                        RemoveMovieFromWatchList(widget.movie));
                                  } else {
                                    context
                                        .read<MovieWatchlistBloc>()
                                        .add(AddMovieToWatchList(widget.movie));
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
                            ),
                            Text(
                              _showGenres(widget.movie.genres),
                            ),
                            Text(
                              _showDuration(widget.movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.movie.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              widget.movie.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<MovieRecommendationsBloc,
                                MovieRecommendationsState>(
                              builder: (context, state) {
                                if (state is MovieRecommendationsLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      key: Key('recommendation_loading'),
                                    ),
                                  );
                                } else if (state is MovieRecommendationsError) {
                                  return Text(state.message,
                                      key: const Key('recommendation_error'));
                                } else if (state
                                    is MovieRecommendationsHasData) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = state.result[index];
                                        return Padding(
                                          key: const Key(
                                              'recommendation_loaded'),
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            key: ValueKey('recommendations_$index'),
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                MovieDetailPage.ROUTE_NAME,
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
                                      itemCount: state.result.length,
                                    ),
                                  );
                                } else {
                                  return Container(key: const ValueKey('recommendation_empty'),);
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
              key: const ValueKey('arrow_back'),
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

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

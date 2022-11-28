import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_recommendations/tv_recommendations_bloc.dart';

import '../bloc/tv_watchlist/tv_watchlist_bloc.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv';

  final int id;

  const TvDetailPage({super.key, required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailBloc>().add(FetchDetailTv(widget.id));
      context
          .read<TvRecommendationsBloc>()
          .add(FetchRecommendationsTv(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvDetailState>(
        builder: (context, state) {
          if (state is TvDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(
                key: Key('tv_loading'),
              ),
            );
          } else if (state is TvDetailHasData) {
            final tv = state.result;
            final isAddedToWatchlist = state.isAddedToWatchlist;
            return SafeArea(
              child: DetailContent(
                tv: tv,
                isAddedWatchlist: isAddedToWatchlist,
              ),
            );
          } else if (state is TvDetailError) {
            return Text(
              state.message,
              key: const Key('tv_error'),
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
  final TvDetail tv;
  late bool isAddedWatchlist;

  DetailContent({required this.tv, required this.isAddedWatchlist, super.key});

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.isAddedWatchlist) {
        context.read<TvWatchlistBloc>().add(TvIsAddedToWatchList());
      } else {
        context.read<TvWatchlistBloc>().add(TvIsRemovedFromWatchList());
      }
    });
  }

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
                              key: const Key('tv_name'),
                            ),
                            BlocListener<TvWatchlistBloc, TvWatchlistState>(
                              listener: (context, state) {
                                String message = "";

                                message = state.message;

                                if (message ==
                                        TvWatchlistBloc
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        TvWatchlistBloc
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
                                    context
                                        .read<TvWatchlistBloc>()
                                        .add(RemoveTvFromWatchList(widget.tv));
                                  } else {
                                    context
                                        .read<TvWatchlistBloc>()
                                        .add(AddTvToWatchList(widget.tv));
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
                              _showGenres(widget.tv.genres),
                            ),
                            Text(
                              _showSeasonEpisode(widget.tv.numberOfSeasons,
                                  widget.tv.numberOfEpisodes),
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
                              'Seasons',
                              style: kHeading6,
                            ),
                            SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final season = widget.tv.seasons[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      child: Stack(
                                        children: [
                                          season.posterPath != null ?
                                          CachedNetworkImage(
                                            imageUrl:
                                                'https://image.tmdb.org/t/p/w500${season.posterPath}',
                                            placeholder: (context, url) =>
                                                const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ) : const SizedBox(width: 105,child: Center(child: Text('No Poster'))),
                                          Positioned.fill(
                                            child: Container(
                                              color:
                                                  kRichBlack.withOpacity(0.35),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 1.0,
                                            left: 8.0,
                                            child: Column(
                                              children: [
                                                Text('${season.name}'),
                                                Text(
                                                    '${season.episodeCount} ${season.episodeCount == 1 ? 'episode' : 'episodes'}')
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: widget.tv.seasons.length,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvRecommendationsBloc,
                                TvRecommendationsState>(
                              builder: (context, state) {
                                if (state is TvRecommendationsLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      key: Key('recommendation_loading'),
                                    ),
                                  );
                                } else if (state is TvRecommendationsError) {
                                  return Text(
                                    state.message,
                                    key: const Key('recommendation_error'),
                                  );
                                } else if (state is TvRecommendationsHasData) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv = state.result[index];
                                        return Padding(
                                          key: const Key(
                                              'recommendation_loaded'),
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            key: ValueKey('recommendations_$index'),
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvDetailPage.ROUTE_NAME,
                                                arguments: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                      itemCount: state.result.length,
                                    ),
                                  );
                                } else {
                                  return Container(key: const ValueKey("recommendation_empty"),);
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
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showSeasonEpisode(int season, int episode) {
    var seasonEpisode = '';
    if (season == 1) {
      seasonEpisode += '$season season ';
    } else {
      seasonEpisode += '$season seasons ';
    }

    if (episode == 1) {
      seasonEpisode += '$episode episode';
    } else {
      seasonEpisode += '$episode episodes';
    }

    return seasonEpisode;
  }
}

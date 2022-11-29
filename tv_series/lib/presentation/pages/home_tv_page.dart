// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_now_playing/tv_now_playing_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_popular/tv_popular_bloc.dart';

import '../bloc/tv_top_rated/tv_top_rated_bloc.dart';
import 'now_playing_tv_page.dart';
import 'popular_tv_page.dart';
import 'top_rated_tv_page.dart';
import 'tv_detail_page.dart';

class HomeTvPage extends StatefulWidget {
  const HomeTvPage({super.key});

  @override
  _HomeTvPageState createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvNowPlayingBloc>().add(FetchNowPlayingTv());
      context.read<TvPopularBloc>().add(FetchPopularTv());
      context.read<TvTopRatedBloc>().add(FetchTopRatedTv());
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
            _buildSubHeading(
              title: 'Now Playing',
              onTap: () =>
                  Navigator.pushNamed(context, NowPlayingTvPage.ROUTE_NAME),
            ),
            BlocBuilder<TvNowPlayingBloc, TvNowPlayingState>(
              builder: (context, state) {
                if (state is TvNowPlayingLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvNowPlayingHasData) {
                  return TvList(state.result, 'now_playing_tv');
                } else if (state is TvNowPlayingError) {
                  return Text(state.message);
                } else {
                  return const Text('Failed');
                }
              },
            ),
            _buildSubHeading(
              title: 'Popular',
              onTap: () =>
                  Navigator.pushNamed(context, PopularTvPage.ROUTE_NAME),
            ),
            BlocBuilder<TvPopularBloc, TvPopularState>(
              builder: (context, state) {
                if (state is TvPopularLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvPopularHasData) {
                  return TvList(state.result, 'popular_tv');
                } else if (state is TvPopularError) {
                  return Text(state.message);
                } else {
                  return const Text('Failed');
                }
              },
            ),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () =>
                  Navigator.pushNamed(context, TopRatedTvPage.ROUTE_NAME),
            ),
            BlocBuilder<TvTopRatedBloc, TvTopRatedState>(
              builder: (context, state) {
                if (state is TvTopRatedLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvTopRatedHasData) {
                  return TvList(state.result, 'top_rated_tv');
                } else if (state is TvTopRatedError) {
                  return Text(state.message);
                } else {
                  return const Text('Failed');
                }
              },
            ),
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

class TvList extends StatelessWidget {
  final List<Tv> tvs;
  final String type;

  const TvList(this.tvs, this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        key: ValueKey(type),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            key: ValueKey('$type$index'),
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
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
        itemCount: tvs.length,
      ),
    );
  }
}

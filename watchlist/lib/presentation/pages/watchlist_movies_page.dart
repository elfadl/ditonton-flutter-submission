// ignore_for_file: library_private_types_in_public_api

import 'package:core/core.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  const WatchlistMoviesPage({super.key});

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<WatchlistMovieBloc>().add(FetchWatchlistMovie()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistMovieBloc>().add(FetchWatchlistMovie());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
        builder: (context, state) {
          if (state is WatchlistMovieLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchlistMovieHasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = state.result[index];
                return MovieCard(movie);
              },
              itemCount: state.result.length,
            );
          } else if(state is WatchlistMovieError){
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text('Data is empty'),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

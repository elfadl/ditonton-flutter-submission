// ignore_for_file: constant_identifier_names, library_private_types_in_public_api

import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_top_rated/movie_top_rated_bloc.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  const TopRatedMoviesPage({super.key});

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<MovieTopRatedBloc>().add(FetchTopRatedMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieTopRatedBloc, MovieTopRatedState>(
          builder: (context, state) {
            if (state is MovieTopRatedLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MovieTopRatedHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return MovieCard(movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is MovieTopRatedError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }else{
              return const Center(
                child: Text('Failed'),
              );
            }
          },
        ),
      ),
    );
  }
}

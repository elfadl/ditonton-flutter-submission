// ignore_for_file: constant_identifier_names, library_private_types_in_public_api

import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_now_playing/tv_now_playing_bloc.dart';

class NowPlayingTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/now-playing-tv';

  const NowPlayingTvPage({super.key});

  @override
  _NowPlayingTvPageState createState() => _NowPlayingTvPageState();
}

class _NowPlayingTvPageState extends State<NowPlayingTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<TvNowPlayingBloc>().add(FetchNowPlayingTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing TV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvNowPlayingBloc, TvNowPlayingState>(
          builder: (context, state) {
            if (state is TvNowPlayingLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvNowPlayingHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is TvNowPlayingError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
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

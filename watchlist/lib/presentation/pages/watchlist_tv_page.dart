// ignore_for_file: library_private_types_in_public_api

import 'package:core/core.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';

class WatchlistTvPage extends StatefulWidget {
  const WatchlistTvPage({super.key});

  @override
  _WatchlistTvPageState createState() => _WatchlistTvPageState();
}

class _WatchlistTvPageState extends State<WatchlistTvPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<WatchlistTvBloc>().add(FetchWatchlistTv()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistTvBloc>().add(FetchWatchlistTv());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
        builder: (context, state) {
          if (state is WatchlistTvLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchlistTvHasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = state.result[index];
                return TvCard(tv);
              },
              itemCount: state.result.length,
            );
          } else if(state is WatchlistTvError) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          }else {
            return const Center(
              child: Text('Data is Empty'),
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

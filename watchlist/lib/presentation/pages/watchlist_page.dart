import 'package:flutter/material.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TabBar(tabs: [
        Tab(
          icon: Icon(Icons.movie_filter),
          text: 'Movie',
        ),
        Tab(
          icon: Icon(Icons.live_tv),
          text: 'TV Series',
        ),
      ]),
    );
  }
}

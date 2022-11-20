import 'package:about/about.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/search_tv_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static const ROUTE_NAME = '/main-page';

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: _listWidget(bottomNavIndex),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedItemColor: Colors.white,
          currentIndex: bottomNavIndex,
          items: _bottomNavBarItems,
          onTap: (selected) {
            setState(() {
              bottomNavIndex = selected;
            });
          },
        ),
        appBar: AppBar(
          title: Text(_bottomNavBarItems[bottomNavIndex].label ?? 'Page Not Found'),
          actions: bottomNavIndex == 0 || bottomNavIndex == 1
              ? [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context,
                          bottomNavIndex == 0
                              ? SearchPage.ROUTE_NAME
                              : SearchTvPage.ROUTE_NAME);
                    },
                    icon: Icon(Icons.search),
                  )
                ]
              : [],
          bottom: bottomNavIndex == 2
              ? TabBar(tabs: [
                  Tab(
                    icon: Icon(Icons.movie_filter),
                    text: 'Movie',
                  ),
                  Tab(
                    icon: Icon(Icons.live_tv),
                    text: 'TV Series',
                  ),
                ])
              : null,
        ),
      ),
    );
  }

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movie'),
    BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'TV Series'),
    BottomNavigationBarItem(
        icon: Icon(Icons.watch_later), label: 'Watchlist'),
    BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
  ];

  Widget _listWidget(int index) {
    switch (index) {
      case 0:
        return HomeMoviePage();
      case 1:
        return HomeTvPage();
      case 2:
        return TabBarView(children: [
          WatchlistMoviesPage(),
          WatchlistTvPage(),
        ]);
      case 3:
        return AboutPage();
      default:
        return Placeholder();
    }
  }
}

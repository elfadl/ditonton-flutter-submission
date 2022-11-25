import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Movie test', () {
    testWidgets('make sure can show movie', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();

      final countNowPlaying = widgetTester
          .widgetList<ListView>(find.byKey(ValueKey('now_playing_movie')))
          .length;
      final countPopularMovie = widgetTester
          .widgetList<ListView>(find.byKey(ValueKey('popular_movie')))
          .length;
      final countTopRated = widgetTester
          .widgetList<ListView>(find.byKey(ValueKey('top_rated_movie')))
          .length;
      expect(countNowPlaying, greaterThanOrEqualTo(1));
      expect(countPopularMovie, greaterThanOrEqualTo(1));
      expect(countTopRated, greaterThanOrEqualTo(1));
    });

    testWidgets('make sure can open movie detail', (widgetTester) async {
      await widgetTester.pumpWidget(app.MyApp());
      await widgetTester.pumpAndSettle();

      final Finder nowPlayingMovie = find.byKey(ValueKey('now_playing_movie0'));
      await widgetTester.tap(nowPlayingMovie);
      await widgetTester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);

      await backButton(widgetTester);

      final Finder popularMovie = find.byKey(ValueKey('popular_movie0'));
      await widgetTester.tap(popularMovie);
      await widgetTester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);

      await backButton(widgetTester);

      final Finder topRatedMovie = find.byKey(ValueKey('top_rated_movie0'));
      await widgetTester.tap(topRatedMovie);
      await widgetTester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);

      await backButton(widgetTester);
    });

    testWidgets('make sure can show movie recommendation', (widgetTester) async {
      await widgetTester.pumpWidget(app.MyApp());
      await widgetTester.pumpAndSettle();

      final Finder nowPlayingMovie = find.byKey(ValueKey('now_playing_movie0'));
      await widgetTester.tap(nowPlayingMovie);
      await widgetTester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);
      final countNowPlaying = widgetTester
          .widgetList(find.byKey(Key('recommendation_loaded'))).length;
      expect(countNowPlaying, greaterThanOrEqualTo(1));

      await backButton(widgetTester);

      final Finder popularMovie = find.byKey(ValueKey('popular_movie0'));
      await widgetTester.tap(popularMovie);
      await widgetTester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);
      final countPopular = widgetTester
          .widgetList(find.byKey(Key('recommendation_loaded'))).length;
      expect(countPopular, greaterThanOrEqualTo(1));

      await backButton(widgetTester);

      final Finder topRatedMovie = find.byKey(ValueKey('top_rated_movie0'));
      await widgetTester.tap(topRatedMovie);
      await widgetTester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);
      final countTopRated = widgetTester
          .widgetList(find.byKey(Key('recommendation_loaded'))).length;
      expect(countTopRated, greaterThanOrEqualTo(1));

      await backButton(widgetTester);
    });

    testWidgets('make sure can add movie to watchlist', (widgetTester) async {
      await widgetTester.pumpWidget(app.MyApp());
      await widgetTester.pumpAndSettle();

      final Finder nowPlayingMovie = find.byKey(ValueKey('now_playing_movie0'));
      await widgetTester.tap(nowPlayingMovie);
      await widgetTester.pumpAndSettle();
      final movieTitle = find.byKey(Key('movie_title'));
      final movieTitleText = movieTitle.evaluate().single.widget as Text;
      final watchlist = find.text('Watchlist');
      await widgetTester.tap(watchlist);
      await widgetTester.pumpAndSettle();

      await backButton(widgetTester);

      final watchlistTab = find.text('Watchlist');
      await widgetTester.tap(watchlistTab);
      await widgetTester.pumpAndSettle();

      expect(find.text(movieTitleText.data!), findsOneWidget);

      final watchlistMovie = find.text(movieTitleText.data!);
      await widgetTester.tap(watchlistMovie);
      await widgetTester.pumpAndSettle();
      final watchlistButton = find.text('Watchlist');
      await widgetTester.tap(watchlistButton);

      await backButton(widgetTester);
    });

    testWidgets('make sure can remove movie from watchlist', (widgetTester) async {
      await widgetTester.pumpWidget(app.MyApp());
      await widgetTester.pumpAndSettle();

      final Finder nowPlayingMovie = find.byKey(ValueKey('now_playing_movie0'));
      await widgetTester.tap(nowPlayingMovie);
      await widgetTester.pumpAndSettle();
      final movieTitle = find.byKey(Key('movie_title'));
      final movieTitleText = movieTitle.evaluate().single.widget as Text;
      final watchlist = find.text('Watchlist');
      await widgetTester.tap(watchlist);
      await widgetTester.pumpAndSettle();

      await backButton(widgetTester);

      final watchlistTab = find.text('Watchlist');
      await widgetTester.tap(watchlistTab);
      await widgetTester.pumpAndSettle();

      final watchlistMovie = find.text(movieTitleText.data!);
      await widgetTester.tap(watchlistMovie);
      await widgetTester.pumpAndSettle();
      final watchlistButton = find.text('Watchlist');
      await widgetTester.tap(watchlistButton);

      await backButton(widgetTester);

      expect(find.text(movieTitleText.data!), findsNothing);
      final movieTab = find.byIcon(Icons.movie);
      await widgetTester.tap(movieTab);
      await widgetTester.pumpAndSettle();
    });

    testWidgets('make sure can show search result', (widgetTester) async {
      await widgetTester.pumpWidget(app.MyApp());
      await widgetTester.pumpAndSettle();

      final search = find.byIcon(Icons.search);
      await widgetTester.tap(search);
      await widgetTester.pumpAndSettle();

      final searchInput = find.byKey(ValueKey('search_field'));
      await widgetTester.enterText(searchInput, 'spiderman');
      await widgetTester.pump(Duration(seconds: 1));
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpAndSettle();
      final movieCard = find.byType(MovieCard);

      expect(movieCard, findsAtLeastNWidgets(1));
    });
  });
}

Future<void> backButton(WidgetTester widgetTester) async {
  await widgetTester.pumpAndSettle();
  final backButton = find.byIcon(Icons.arrow_back);
  await widgetTester.tap(backButton);
  await widgetTester.pumpAndSettle();
}

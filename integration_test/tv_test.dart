import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:ditonton/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Tv test', () {
    testWidgets('make sure can show tv', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byIcon(Icons.tv));
      await widgetTester.pumpAndSettle();

      final countNowPlaying = widgetTester
          .widgetList<ListView>(find.byKey(ValueKey('now_playing_tv')))
          .length;
      final countPopularTv = widgetTester
          .widgetList<ListView>(find.byKey(ValueKey('popular_tv')))
          .length;
      final countTopRated = widgetTester
          .widgetList<ListView>(find.byKey(ValueKey('top_rated_tv')))
          .length;
      expect(countNowPlaying, greaterThanOrEqualTo(1));
      expect(countPopularTv, greaterThanOrEqualTo(1));
      expect(countTopRated, greaterThanOrEqualTo(1));
    });

    testWidgets('make sure can open tv detail', (widgetTester) async {
      await widgetTester.pumpWidget(app.MyApp());
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byIcon(Icons.tv));
      await widgetTester.pumpAndSettle();

      final Finder nowPlayingTv = find.byKey(ValueKey('now_playing_tv0'));
      await widgetTester.tap(nowPlayingTv);
      await widgetTester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);

      await backButton(widgetTester);

      final Finder popularTv = find.byKey(ValueKey('popular_tv0'));
      await widgetTester.tap(popularTv);
      await widgetTester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);

      await backButton(widgetTester);

      final Finder topRatedTv = find.byKey(ValueKey('top_rated_tv0'));
      await widgetTester.tap(topRatedTv);
      await widgetTester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);

      await backButton(widgetTester);
    });

    testWidgets('make sure can show tv recommendation', (widgetTester) async {
      await widgetTester.pumpWidget(app.MyApp());
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byIcon(Icons.tv));
      await widgetTester.pumpAndSettle();

      final Finder nowPlayingTv = find.byKey(ValueKey('now_playing_tv0'));
      await widgetTester.tap(nowPlayingTv);
      await widgetTester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);
      final countNowPlaying = widgetTester
          .widgetList(find.byKey(Key('recommendation_loaded'))).length;
      expect(countNowPlaying, greaterThanOrEqualTo(1));

      await backButton(widgetTester);

      final Finder popularTv = find.byKey(ValueKey('popular_tv0'));
      await widgetTester.tap(popularTv);
      await widgetTester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);
      final countPopular = widgetTester
          .widgetList(find.byKey(Key('recommendation_loaded'))).length;
      expect(countPopular, greaterThanOrEqualTo(1));

      await backButton(widgetTester);

      final Finder topRatedTv = find.byKey(ValueKey('top_rated_tv0'));
      await widgetTester.tap(topRatedTv);
      await widgetTester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);
      final countTopRated = widgetTester
          .widgetList(find.byKey(Key('recommendation_loaded'))).length;
      expect(countTopRated, greaterThanOrEqualTo(1));

      await backButton(widgetTester);
    });

    testWidgets('make sure can add tv to watchlist', (widgetTester) async {
      await widgetTester.pumpWidget(app.MyApp());
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byIcon(Icons.tv));
      await widgetTester.pumpAndSettle();

      final Finder nowPlayingTv = find.byKey(ValueKey('now_playing_tv0'));
      await widgetTester.tap(nowPlayingTv);
      await widgetTester.pumpAndSettle();
      final tvTitle = find.byKey(Key('tv_name'));
      final tvTitleText = tvTitle.evaluate().single.widget as Text;
      final watchlist = find.text('Watchlist');
      await widgetTester.tap(watchlist);
      await widgetTester.pumpAndSettle();

      await backButton(widgetTester);

      final watchlistTab = find.text('Watchlist');
      await widgetTester.tap(watchlistTab);
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byIcon(Icons.live_tv));
      await widgetTester.pumpAndSettle();

      expect(find.text(tvTitleText.data!), findsOneWidget);

      final watchlistTv = find.text(tvTitleText.data!);
      await widgetTester.tap(watchlistTv);
      await widgetTester.pumpAndSettle();
      final watchlistButton = find.text('Watchlist');
      await widgetTester.tap(watchlistButton);

      await backButton(widgetTester);
    });

    testWidgets('make sure can remove tv from watchlist', (widgetTester) async {
      await widgetTester.pumpWidget(app.MyApp());
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byIcon(Icons.tv));
      await widgetTester.pumpAndSettle();

      final Finder nowPlayingTv = find.byKey(ValueKey('now_playing_tv0'));
      await widgetTester.tap(nowPlayingTv);
      await widgetTester.pumpAndSettle();
      final tvTitle = find.byKey(Key('tv_name'));
      final tvTitleText = tvTitle.evaluate().single.widget as Text;
      final watchlist = find.text('Watchlist');
      await widgetTester.tap(watchlist);
      await widgetTester.pumpAndSettle();

      await backButton(widgetTester);

      final watchlistTab = find.text('Watchlist');
      await widgetTester.tap(watchlistTab);
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byIcon(Icons.live_tv));
      await widgetTester.pumpAndSettle();

      final watchlistTv = find.text(tvTitleText.data!);
      await widgetTester.tap(watchlistTv);
      await widgetTester.pumpAndSettle();
      final watchlistButton = find.text('Watchlist');
      await widgetTester.tap(watchlistButton);

      await backButton(widgetTester);

      expect(find.text(tvTitleText.data!), findsNothing);
      final tvTab = find.byIcon(Icons.tv);
      await widgetTester.tap(tvTab);
      await widgetTester.pumpAndSettle();
    });

    testWidgets('make sure can show search result', (widgetTester) async {
      await widgetTester.pumpWidget(app.MyApp());
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byIcon(Icons.tv));
      await widgetTester.pumpAndSettle();

      final search = find.byIcon(Icons.search);
      await widgetTester.tap(search);
      await widgetTester.pumpAndSettle();

      final searchInput = find.byKey(ValueKey('search_field'));
      await widgetTester.enterText(searchInput, 'hulk');
      await widgetTester.pump(Duration(seconds: 3));
      await widgetTester.pumpAndSettle();
      await widgetTester.testTextInput.receiveAction(TextInputAction.search);
      await widgetTester.pumpAndSettle();
      final tvCard = find.byType(TvCard);

      expect(tvCard, findsAtLeastNWidgets(1));
    });
  });
}

Future<void> backButton(WidgetTester widgetTester) async {
  await widgetTester.pumpAndSettle();
  final backButton = find.byIcon(Icons.arrow_back);
  await widgetTester.tap(backButton);
  await widgetTester.pumpAndSettle();
}

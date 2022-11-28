import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_recommendations/tv_recommendations_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:tv_series/presentation/pages/tv_detail_page.dart';

class FakeTvDetailEvent extends Fake implements TvDetailEvent {}

class FakeTvDetailState extends Fake implements TvDetailState {}

class FakeTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

class FakeTvRecommendationsEvent extends Fake
    implements TvRecommendationsEvent {}

class FakeTvRecommendationsState extends Fake
    implements TvRecommendationsState {}

class FakeTvRecommendationsBloc
    extends MockBloc<TvRecommendationsEvent, TvRecommendationsState>
    implements TvRecommendationsBloc {}

class FakeTvWatchlistEvent extends Fake implements TvWatchlistEvent {}

class FakeTvWatchlistState extends Fake implements TvWatchlistState {}

class FakeTvWatchlistBloc extends MockBloc<TvWatchlistEvent, TvWatchlistState>
    implements TvWatchlistBloc {}

class FakeRoute extends Fake implements Route<dynamic> {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late FakeTvDetailBloc fakeTvDetailBloc;
  late FakeTvRecommendationsBloc fakeTvRecommendationsBloc;
  late FakeTvWatchlistBloc fakeTvWatchlistBloc;

  setUp(() {
    registerFallbackValue(FakeTvDetailEvent());
    registerFallbackValue(FakeTvDetailState());
    fakeTvDetailBloc = FakeTvDetailBloc();

    registerFallbackValue(FakeTvRecommendationsEvent());
    registerFallbackValue(FakeTvRecommendationsState());
    fakeTvRecommendationsBloc = FakeTvRecommendationsBloc();

    registerFallbackValue(FakeTvWatchlistEvent());
    registerFallbackValue(FakeTvWatchlistState());
    fakeTvWatchlistBloc = FakeTvWatchlistBloc();

    registerFallbackValue(FakeRoute());
  });

  Widget _makeTestableWidget(Widget body,
      {NavigatorObserver? navigatorObserver}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvDetailBloc>(
          create: (_) => fakeTvDetailBloc,
        ),
        BlocProvider<TvRecommendationsBloc>(
          create: (_) => fakeTvRecommendationsBloc,
        ),
        BlocProvider<TvWatchlistBloc>(
          create: (_) => fakeTvWatchlistBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
        navigatorObservers:
            navigatorObserver != null ? [navigatorObserver] : [],
      ),
    );
  }

  final tTvDetail = TvDetail(
      adult: false,
      backdropPath: '/pysGisnLhmjQB2CGQCAQDxBADsH.jpg',
      episodeRunTime: const [42],
      firstAirDate: "2021-10-12",
      genres: [Genre(id: 1, name: 'Action')],
      homepage: "https://www.syfy.com/chucky",
      id: 90462,
      inProduction: true,
      languages: const ["en"],
      lastAirDate: "2022-11-09",
      name: "Chucky",
      numberOfEpisodes: 16,
      numberOfSeasons: 2,
      originCountry: const ["US"],
      originalLanguage: "en",
      originalName: "Chucky",
      overview:
          "After a vintage Chucky doll turns up at a suburban yard sale, an idyllic American town is thrown into chaos as a series of horrifying murders begin to expose the town’s hypocrisies and secrets. Meanwhile, the arrival of enemies — and allies — from Chucky’s past threatens to expose the truth behind the killings, as well as the demon doll’s untold origins.",
      popularity: 2532.47,
      posterPath: "/kY0BogCM8SkNJ0MNiHB3VTM86Tz.jpg",
      seasons: [
        Season(
            airDate: "2021-10-12",
            episodeCount: 8,
            id: 126146,
            name: "Season 1",
            overview: "",
            posterPath: "/iF8ai2QLNiHV4anwY1TuSGZXqfN.jpg",
            seasonNumber: 1)
      ],
      status: "Returning Series",
      tagline: "A classic coming of rage story.",
      type: "Scripted",
      voteAverage: 7.861,
      voteCount: 3463);

  final tTvDetail2 = TvDetail(
      adult: false,
      backdropPath: '/pysGisnLhmjQB2CGQCAQDxBADsH.jpg',
      episodeRunTime: const [42],
      firstAirDate: "2021-10-12",
      genres: [Genre(id: 1, name: 'Action')],
      homepage: "https://www.syfy.com/chucky",
      id: 90462,
      inProduction: true,
      languages: const ["en"],
      lastAirDate: "2022-11-09",
      name: "Chucky",
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
      originCountry: const ["US"],
      originalLanguage: "en",
      originalName: "Chucky",
      overview:
          "After a vintage Chucky doll turns up at a suburban yard sale, an idyllic American town is thrown into chaos as a series of horrifying murders begin to expose the town’s hypocrisies and secrets. Meanwhile, the arrival of enemies — and allies — from Chucky’s past threatens to expose the truth behind the killings, as well as the demon doll’s untold origins.",
      popularity: 2532.47,
      posterPath: "/kY0BogCM8SkNJ0MNiHB3VTM86Tz.jpg",
      seasons: [
        Season(
            airDate: "2021-10-12",
            episodeCount: 8,
            id: 126146,
            name: "Season 1",
            overview: "",
            posterPath: "/iF8ai2QLNiHV4anwY1TuSGZXqfN.jpg",
            seasonNumber: 1)
      ],
      status: "Returning Series",
      tagline: "A classic coming of rage story.",
      type: "Scripted",
      voteAverage: 7.861,
      voteCount: 3463);

  final tTv = Tv(
    backdropPath: "/5kkw5RT1OjTAMh3POhjo5LdaACZ.jpg",
    firstAirDate: "2021-10-12",
    genreIds: const [80, 10765],
    id: 90462,
    name: "Chucky",
    originCountry: const ["US"],
    originalLanguage: "en",
    originalName: "Chucky",
    overview:
        "After a vintage Chucky doll turns up at a suburban yard sale, an idyllic American town is thrown into chaos as a series of horrifying murders begin to expose the town’s hypocrisies and secrets. Meanwhile, the arrival of enemies — and allies — from Chucky’s past threatens to expose the truth behind the killings, as well as the demon doll’s untold origins.",
    popularity: 2532.47,
    posterPath: "/kY0BogCM8SkNJ0MNiHB3VTM86Tz.jpg",
    voteAverage: 7.9,
    voteCount: 3463,
  );

  final tTvList = [tTv];

  tearDown(() {
    fakeTvDetailBloc.close();
    fakeTvRecommendationsBloc.close();
    fakeTvWatchlistBloc.close();
  });

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(tTvDetail2, false));
    when(() => fakeTvRecommendationsBloc.state)
        .thenReturn(TvRecommendationsHasData(tTvList));
    when(() => fakeTvWatchlistBloc.state).thenReturn(TvWatchlistInitial(''));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));
    await tester.pump();

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv is added to wathclist',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(tTvDetail, true));
    when(() => fakeTvRecommendationsBloc.state)
        .thenReturn(TvRecommendationsHasData(tTvList));
    when(() => fakeTvWatchlistBloc.state).thenReturn(TvWatchlistInitial(''));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    await tester.pump();

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(tTvDetail, false));
    when(() => fakeTvRecommendationsBloc.state)
        .thenReturn(TvRecommendationsHasData(tTvList));
    when(() => fakeTvWatchlistBloc.state).thenReturn(TvWatchlistInitial(''));

    whenListen(
      fakeTvWatchlistBloc,
      Stream.fromIterable([
        TvWatchlistInitial(''),
        WatchlistAddTvMessage(TvWatchlistBloc.watchlistAddSuccessMessage),
      ]),
    );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(
        find.text(TvWatchlistBloc.watchlistAddSuccessMessage), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(tTvDetail, false));
    when(() => fakeTvRecommendationsBloc.state)
        .thenReturn(TvRecommendationsHasData(tTvList));
    when(() => fakeTvWatchlistBloc.state).thenReturn(TvWatchlistInitial(''));

    whenListen(
      fakeTvWatchlistBloc,
      Stream.fromIterable([
        TvWatchlistInitial(''),
        WatchlistAddTvMessage('Failed'),
      ]),
    );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton, warnIfMissed: false);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when removed from watchlist successfully',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(tTvDetail, true));
    when(() => fakeTvRecommendationsBloc.state)
        .thenReturn(TvRecommendationsHasData(tTvList));
    when(() => fakeTvWatchlistBloc.state).thenReturn(WatchlistAddTvMessage(''));

    whenListen(
      fakeTvWatchlistBloc,
      Stream.fromIterable([
        WatchlistAddTvMessage(''),
        WatchlistRemoveTvMessage(TvWatchlistBloc.watchlistRemoveSuccessMessage),
      ]),
    );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(TvWatchlistBloc.watchlistRemoveSuccessMessage),
        findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when removed from watchlist failed',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(tTvDetail, true));
    when(() => fakeTvRecommendationsBloc.state)
        .thenReturn(TvRecommendationsHasData(tTvList));
    when(() => fakeTvWatchlistBloc.state).thenReturn(WatchlistAddTvMessage(''));

    whenListen(
      fakeTvWatchlistBloc,
      Stream.fromIterable([
        WatchlistAddTvMessage(''),
        WatchlistRemoveTvMessage('Failed'),
      ]),
    );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(watchlistButton, warnIfMissed: false);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets(
      'Page should display center progress bar when tv detail is loading',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state).thenReturn(TvDetailLoading());

    final progressBarFinder = find.byKey(const Key('tv_loading'));

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));
    await tester.pump();

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailError('Error message'));

    final textFinder = find.byKey(const Key('tv_error'));

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));
    await tester.pump();

    expect(textFinder, findsWidgets);
  });

  testWidgets('Page should display progress bar when recommendation is loading',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(tTvDetail, false));
    when(() => fakeTvRecommendationsBloc.state)
        .thenReturn(TvRecommendationsLoading());
    when(() => fakeTvWatchlistBloc.state).thenReturn(WatchlistAddTvMessage(''));

    final progressBarFinder = find.byKey(const Key('recommendation_loading'));

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));
    await tester.pump();

    expect(progressBarFinder, findsWidgets);
  });

  testWidgets('Page should display Error Message when recommendation is Error',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(tTvDetail, false));
    when(() => fakeTvRecommendationsBloc.state)
        .thenReturn(TvRecommendationsError('Failed'));
    when(() => fakeTvWatchlistBloc.state).thenReturn(WatchlistAddTvMessage(''));

    final errorFinder = find.byKey(const Key('recommendation_error'));

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));
    await tester.pump();

    expect(errorFinder, findsOneWidget);
  });

  testWidgets(
      'Page should display Recommendation Data when recommendation is Loaded',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(tTvDetail, false));
    when(() => fakeTvRecommendationsBloc.state)
        .thenReturn(TvRecommendationsHasData(tTvList));
    when(() => fakeTvWatchlistBloc.state).thenReturn(WatchlistAddTvMessage(''));

    final listViewFinder = find.byKey(const Key('recommendation_loaded'));

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));
    await tester.pump();

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets(
      'Page should display Empty Container when recommendation is Empty',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(tTvDetail, false));
    when(() => fakeTvRecommendationsBloc.state)
        .thenReturn(TvRecommendationsEmpty());
    when(() => fakeTvWatchlistBloc.state).thenReturn(WatchlistAddTvMessage(''));

    final errorFinder = find.byKey(const Key('recommendation_empty'));

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));
    await tester.pump();

    expect(errorFinder, findsOneWidget);
  });

  testWidgets('Should did pop when back button is tapped',
      (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(tTvDetail, false));
    when(() => fakeTvRecommendationsBloc.state)
        .thenReturn(TvRecommendationsEmpty());
    when(() => fakeTvWatchlistBloc.state).thenReturn(TvWatchlistInitial(''));

    final arrowBackFinder = find.byIcon(Icons.arrow_back);

    await tester.pumpWidget(_makeTestableWidget(
      const TvDetailPage(id: 1),
      navigatorObserver: mockObserver,
    ));

    expect(arrowBackFinder, findsOneWidget);
    await tester.tap(arrowBackFinder);
    await tester.pumpAndSettle();

    verify(() => mockObserver.didPop(any(), any()));
  });

  testWidgets('Should did push when one of recommendations tapped',
      (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(tTvDetail, false));
    when(() => fakeTvRecommendationsBloc.state)
        .thenReturn(TvRecommendationsHasData(tTvList));
    when(() => fakeTvWatchlistBloc.state).thenReturn(TvWatchlistInitial(''));

    final recommendationsFinder =
        find.byKey(const ValueKey('recommendations_0'));

    await tester.pumpWidget(_makeTestableWidget(
      const TvDetailPage(id: 1),
      navigatorObserver: mockObserver,
    ));

    expect(recommendationsFinder, findsOneWidget);
    await tester.tap(recommendationsFinder, warnIfMissed: false);
    await tester.pump();

    verify(() => mockObserver.didPush(any(), any()));
  });
}

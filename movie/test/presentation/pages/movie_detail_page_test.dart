import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:movie/presentation/bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';

class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}

class FakeMovieDetailState extends Fake implements MovieDetailState {}

class FakeMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class FakeMovieRecommendationsEvent extends Fake
    implements MovieRecommendationsEvent {}

class FakeMovieRecommendationsState extends Fake
    implements MovieRecommendationsState {}

class FakeMovieRecommendationsBloc
    extends MockBloc<MovieRecommendationsEvent, MovieRecommendationsState>
    implements MovieRecommendationsBloc {}

class FakeMovieWatchlistEvent extends Fake implements MovieWatchlistEvent {}

class FakeMovieWatchlistState extends Fake implements MovieWatchlistState {}

class FakeMovieWatchlistBloc
    extends MockBloc<MovieWatchlistEvent, MovieWatchlistState>
    implements MovieWatchlistBloc {}

class FakeRoute extends Fake implements Route<dynamic> {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late FakeMovieDetailBloc fakeMovieDetailBloc;
  late FakeMovieRecommendationsBloc fakeMovieRecommendationsBloc;
  late FakeMovieWatchlistBloc fakeMovieWatchlistBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
    fakeMovieDetailBloc = FakeMovieDetailBloc();

    registerFallbackValue(FakeMovieRecommendationsEvent());
    registerFallbackValue(FakeMovieRecommendationsState());
    fakeMovieRecommendationsBloc = FakeMovieRecommendationsBloc();

    registerFallbackValue(FakeMovieWatchlistEvent());
    registerFallbackValue(FakeMovieWatchlistState());
    fakeMovieWatchlistBloc = FakeMovieWatchlistBloc();

    registerFallbackValue(FakeRoute());
  });

  Widget _makeTestableWidget(Widget body,
      {NavigatorObserver? navigatorObserver}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>(
          create: (_) => fakeMovieDetailBloc,
        ),
        BlocProvider<MovieRecommendationsBloc>(
          create: (_) => fakeMovieRecommendationsBloc,
        ),
        BlocProvider<MovieWatchlistBloc>(
          create: (_) => fakeMovieWatchlistBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
        navigatorObservers:
            navigatorObserver != null ? [navigatorObserver] : [],
      ),
    );
  }

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieDetail2 = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 50,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = [tMovie];

  tearDown(() {
    fakeMovieDetailBloc.close();
    fakeMovieRecommendationsBloc.close();
    fakeMovieWatchlistBloc.close();
  });

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(tMovieDetail2, false));
    when(() => fakeMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsHasData(tMovieList));
    when(() => fakeMovieWatchlistBloc.state)
        .thenReturn(MovieWatchlistInitial(''));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(tMovieDetail, true));
    when(() => fakeMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsHasData(tMovieList));
    when(() => fakeMovieWatchlistBloc.state)
        .thenReturn(MovieWatchlistInitial(''));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(tMovieDetail, false));
    when(() => fakeMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsHasData(tMovieList));

    whenListen(
      fakeMovieWatchlistBloc,
      Stream.fromIterable([
        MovieWatchlistInitial(''),
        WatchlistAddMovieMessage(MovieWatchlistBloc.watchlistAddSuccessMessage),
      ]),
    );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(MovieWatchlistBloc.watchlistAddSuccessMessage),
        findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(tMovieDetail, false));
    when(() => fakeMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsHasData(tMovieList));

    whenListen(
      fakeMovieWatchlistBloc,
      Stream.fromIterable([
        MovieWatchlistInitial(''),
        WatchlistAddMovieMessage('Failed'),
      ]),
    );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton, warnIfMissed: false);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when removed from watchlist successfully',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(tMovieDetail, true));
    when(() => fakeMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsHasData(tMovieList));
    when(() => fakeMovieWatchlistBloc.state)
        .thenReturn(WatchlistAddMovieMessage(''));

    whenListen(
      fakeMovieWatchlistBloc,
      Stream.fromIterable([
        WatchlistAddMovieMessage(''),
        WatchlistRemoveMovieMessage(
            MovieWatchlistBloc.watchlistRemoveSuccessMessage),
      ]),
    );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(MovieWatchlistBloc.watchlistRemoveSuccessMessage),
        findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when removed from watchlist failed',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(tMovieDetail, true));
    when(() => fakeMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsHasData(tMovieList));
    when(() => fakeMovieWatchlistBloc.state)
        .thenReturn(WatchlistAddMovieMessage(''));

    whenListen(
      fakeMovieWatchlistBloc,
      Stream.fromIterable([
        WatchlistAddMovieMessage(''),
        WatchlistRemoveMovieMessage('Failed'),
      ]),
    );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(watchlistButton, warnIfMissed: false);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets(
      'Page should display center progress bar when movie detail is loading',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state).thenReturn(MovieDetailLoading());

    final progressBarFinder = find.byKey(const Key('movie_loading'));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state)
        .thenReturn(MovieDetailError('Error message'));

    final textFinder = find.byKey(const Key('movie_error'));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(textFinder, findsWidgets);
  });

  testWidgets('Page should display progress bar when recommendation is loading',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(tMovieDetail, false));
    when(() => fakeMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsLoading());

    final progressBarFinder = find.byKey(const Key('recommendation_loading'));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display Error Message when recommendation is Error',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(tMovieDetail, false));
    when(() => fakeMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsError('Failed'));

    final errorFinder = find.byKey(const Key('recommendation_error'));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(errorFinder, findsOneWidget);
  });

  testWidgets(
      'Page should display Recommendation Data when recommendation is Loaded',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(tMovieDetail, false));
    when(() => fakeMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsHasData(tMovieList));

    final listViewFinder = find.byKey(const Key('recommendation_loaded'));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets(
      'Page should display Empty Container when recommendation is Empty',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(tMovieDetail, false));
    when(() => fakeMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsEmpty());
    when(() => fakeMovieWatchlistBloc.state)
        .thenReturn(MovieWatchlistInitial(''));

    final emptyFinder = find.byKey(const Key('recommendation_empty'));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(emptyFinder, findsOneWidget);
  });

  testWidgets('Should did pop when back button is tapped',
      (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    when(() => fakeMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(tMovieDetail, false));
    when(() => fakeMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsEmpty());
    when(() => fakeMovieWatchlistBloc.state)
        .thenReturn(MovieWatchlistInitial(''));

    final arrowBackFinder = find.byKey(const ValueKey('arrow_back'));

    await tester.pumpWidget(_makeTestableWidget(
      const MovieDetailPage(id: 1),
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
    when(() => fakeMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(tMovieDetail, false));
    when(() => fakeMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsHasData(tMovieList));
    when(() => fakeMovieWatchlistBloc.state)
        .thenReturn(MovieWatchlistInitial(''));

    final recommendationsFinder =
        find.byKey(const ValueKey('recommendations_0'));

    await tester.pumpWidget(_makeTestableWidget(
      const MovieDetailPage(id: 1),
      navigatorObserver: mockObserver,
    ));

    expect(recommendationsFinder, findsOneWidget);
    await tester.tap(recommendationsFinder, warnIfMissed: false);
    await tester.pump();

    verify(() => mockObserver.didPush(any(), any()));
  });
}

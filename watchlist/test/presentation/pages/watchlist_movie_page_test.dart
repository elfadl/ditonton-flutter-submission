import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchlist/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:watchlist/presentation/pages/watchlist_movies_page.dart';

class FakeWatchlistMovieEvent extends Fake implements WatchlistMovieEvent {}

class FakeWatchlistMovieState extends Fake implements WatchlistMovieState {}

class FakeWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

void main() {
  late FakeWatchlistMovieBloc fakeWatchlistMovieBloc;

  setUp(() {
    registerFallbackValue(FakeWatchlistMovieEvent());
    registerFallbackValue(FakeWatchlistMovieState());
    fakeWatchlistMovieBloc = FakeWatchlistMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMovieBloc>(
      create: (_) => fakeWatchlistMovieBloc,
      child: MaterialApp(
        home: Material(
          child: body,
        ),
      ),
    );
  }

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

  tearDown(() => fakeWatchlistMovieBloc.close());

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => fakeWatchlistMovieBloc.state)
        .thenReturn(WatchlistMovieLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => fakeWatchlistMovieBloc.state)
        .thenReturn(WatchlistMovieHasData(tMovieList));

    final listViewFinder = find.byType(ListView);
    final movieFinder = find.byType(MovieCard);

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(listViewFinder, findsOneWidget);
    expect(movieFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => fakeWatchlistMovieBloc.state)
        .thenReturn(const WatchlistMovieError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}

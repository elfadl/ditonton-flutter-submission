import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/movie_top_rated/movie_top_rated_bloc.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';

class FakeMovieTopRatedEvent extends Fake implements MovieTopRatedEvent {}

class FakeMovieTopRatedState extends Fake implements MovieTopRatedState {}

class FakeMovieTopRatedBloc
    extends MockBloc<MovieTopRatedEvent, MovieTopRatedState>
    implements MovieTopRatedBloc {}

void main() {
  late FakeMovieTopRatedBloc fakeMovieTopRatedBloc;

  setUp(() {
    registerFallbackValue(FakeMovieTopRatedEvent());
    registerFallbackValue(FakeMovieTopRatedState());
    fakeMovieTopRatedBloc = FakeMovieTopRatedBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieTopRatedBloc>(
      create: (_) => fakeMovieTopRatedBloc,
      child: MaterialApp(
        home: body,
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

  tearDown(() => fakeMovieTopRatedBloc.close());

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => fakeMovieTopRatedBloc.state).thenReturn(MovieTopRatedLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => fakeMovieTopRatedBloc.state)
        .thenReturn(MovieTopRatedHasData(tMovieList));

    final listViewFinder = find.byType(ListView);
    final movieCardFinder = find.byType(MovieCard);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
    expect(movieCardFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => fakeMovieTopRatedBloc.state)
        .thenReturn(const MovieTopRatedError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}

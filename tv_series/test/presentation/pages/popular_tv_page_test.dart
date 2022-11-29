
import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/presentation/bloc/tv_popular/tv_popular_bloc.dart';
import 'package:tv_series/presentation/pages/popular_tv_page.dart';

class FakeTvPopularEvent extends Fake implements TvPopularEvent {}

class FakeTvPopularState extends Fake implements TvPopularState {}

class FakeTvPopularBloc
    extends MockBloc<TvPopularEvent, TvPopularState>
    implements TvPopularBloc {}

void main() {
  late FakeTvPopularBloc fakeTvPopularBloc;

  setUp(() {
    registerFallbackValue(FakeTvPopularEvent());
    registerFallbackValue(FakeTvPopularState());
    fakeTvPopularBloc = FakeTvPopularBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvPopularBloc>(
      create: (_) => fakeTvPopularBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

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

  tearDown(() => fakeTvPopularBloc.close());

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => fakeTvPopularBloc.state).thenReturn(TvPopularLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const PopularTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => fakeTvPopularBloc.state).thenReturn(TvPopularHasData(tTvList));

    final listViewFinder = find.byType(ListView);
    final tvCardFinder = find.byType(TvCard);

    await tester.pumpWidget(makeTestableWidget(const PopularTvPage()));

    expect(listViewFinder, findsOneWidget);
    expect(tvCardFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => fakeTvPopularBloc.state).thenReturn(const TvPopularError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const PopularTvPage()));

    expect(textFinder, findsOneWidget);
  });
}

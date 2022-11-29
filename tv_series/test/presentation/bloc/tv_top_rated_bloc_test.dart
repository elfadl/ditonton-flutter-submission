
import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv.dart';
import 'package:tv_series/presentation/bloc/tv_top_rated/tv_top_rated_bloc.dart';

import 'tv_top_rated_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTv])
void main(){
  late TvTopRatedBloc tvTopRatedBloc;
  late MockGetTopRatedTv mockGetTopRatedTv;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    tvTopRatedBloc = TvTopRatedBloc(mockGetTopRatedTv);
  });

  test('initial state should be empty', () {
    expect(tvTopRatedBloc.state, TvTopRatedEmpty());
  });

  final tTvModel = Tv(
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
  final tTvList = <Tv>[tTvModel];

  blocTest<TvTopRatedBloc, TvTopRatedState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      return tvTopRatedBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTv()),
    expect: () => <TvTopRatedState>[TvTopRatedLoading(), TvTopRatedHasData(tTvList)],
    verify: (bloc) {
      verify(mockGetTopRatedTv.execute());
    },
  );

  blocTest<TvTopRatedBloc, TvTopRatedState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return tvTopRatedBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTv()),
    expect: () => <TvTopRatedState>[TvTopRatedLoading(), const TvTopRatedError('Server Failure')],
    verify: (bloc) {
      verify(mockGetTopRatedTv.execute());
    },
  );

  group('test props', () {
    test('test props in FetchTopRatedTv', () {
      final event = FetchTopRatedTv();

      expect(event.props, []);
    });
  });
}
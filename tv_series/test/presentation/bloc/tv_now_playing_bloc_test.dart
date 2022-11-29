
import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_now_playing_tv.dart';
import 'package:tv_series/presentation/bloc/tv_now_playing/tv_now_playing_bloc.dart';

import 'tv_now_playing_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTv])
void main(){
  late TvNowPlayingBloc tvNowPlayingBloc;
  late MockGetNowPlayingTv mockGetNowPlayingTv;

  setUp(() {
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    tvNowPlayingBloc = TvNowPlayingBloc(mockGetNowPlayingTv);
  });

  test('initial state should be empty', () {
    expect(tvNowPlayingBloc.state, TvNowPlayingEmpty());
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

  blocTest<TvNowPlayingBloc, TvNowPlayingState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      return tvNowPlayingBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTv()),
    expect: () => <TvNowPlayingState>[TvNowPlayingLoading(), TvNowPlayingHasData(tTvList)],
    verify: (bloc) {
      verify(mockGetNowPlayingTv.execute());
    },
  );

  blocTest<TvNowPlayingBloc, TvNowPlayingState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return tvNowPlayingBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTv()),
    expect: () => <TvNowPlayingState>[TvNowPlayingLoading(), const TvNowPlayingError('Server Failure')],
    verify: (bloc) {
      verify(mockGetNowPlayingTv.execute());
    },
  );

  group('test props', () {
    test('test props in FetchNowPlayingTv', () {
      final event = FetchNowPlayingTv();

      expect(event.props, []);
    });
  });
}
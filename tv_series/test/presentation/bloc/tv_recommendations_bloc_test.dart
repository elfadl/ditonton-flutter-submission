
import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_tv_recommendations.dart';
import 'package:tv_series/presentation/bloc/tv_recommendations/tv_recommendations_bloc.dart';

import 'tv_recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetTvRecommendations])
void main(){
  late TvRecommendationsBloc tvRecommendationsBloc;
  late MockGetTvRecommendations mockGetTvRecommendations;

  setUp(() {
    mockGetTvRecommendations = MockGetTvRecommendations();
    tvRecommendationsBloc = TvRecommendationsBloc(mockGetTvRecommendations);
  });

  test('initial state should be empty', () {
    expect(tvRecommendationsBloc.state, TvRecommendationsEmpty());
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

  blocTest<TvRecommendationsBloc, TvRecommendationsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvRecommendations.execute(tTvModel.id))
          .thenAnswer((_) async => Right(tTvList));
      return tvRecommendationsBloc;
    },
    act: (bloc) => bloc.add(FetchRecommendationsTv(tTvModel.id)),
    expect: () => <TvRecommendationsState>[TvRecommendationsLoading(), TvRecommendationsHasData(tTvList)],
    verify: (bloc) {
      verify(mockGetTvRecommendations.execute(tTvModel.id));
    },
  );

  blocTest<TvRecommendationsBloc, TvRecommendationsState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetTvRecommendations.execute(tTvModel.id))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvRecommendationsBloc;
    },
    act: (bloc) => bloc.add(FetchRecommendationsTv(tTvModel.id)),
    expect: () => <TvRecommendationsState>[TvRecommendationsLoading(), TvRecommendationsError('Server Failure')],
    verify: (bloc) {
      verify(mockGetTvRecommendations.execute(tTvModel.id));
    },
  );
}
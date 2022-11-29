import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecase/search_tv.dart';
import 'package:search/presentation/bloc/search_tv_bloc.dart';

import 'search_tv_bloc_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late SearchTvBloc searchTvBloc;
  late MockSearchTv mockSearchTv;

  setUp(() {
    mockSearchTv = MockSearchTv();
    searchTvBloc = SearchTvBloc(mockSearchTv);
  });

  test('initial state should be empty', () {
    expect(searchTvBloc.state, SearchTvEmpty());
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
  const tQuery = "hulk";

  blocTest<SearchTvBloc, SearchTvState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: (){
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(const OnQueryTvChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => <SearchTvState>[SearchTvLoading(), SearchTvHasData(tTvList)],
    verify: (bloc){
      verify(mockSearchTv.execute(tQuery));
    }
  );

  blocTest<SearchTvBloc, SearchTvState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(const OnQueryTvChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => <SearchTvState>[SearchTvLoading(), const SearchTvError('Server Failure')],
    verify: (bloc) {
      verify(mockSearchTv.execute(tQuery));
    },
  );

  group('test props', () {
    test('test props in OnQueryTvChanged', () {
      const event = OnQueryTvChanged(tQuery);

      expect(event.props, [tQuery]);
    });
  });
}

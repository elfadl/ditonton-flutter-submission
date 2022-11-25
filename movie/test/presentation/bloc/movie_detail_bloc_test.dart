import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecase/get_movie_detail.dart';
import 'package:movie/domain/usecase/get_watchlist_status.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetWatchListStatus,
])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetWatchListStatus mockGetWatchListStatus;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetWatchListStatus = MockGetWatchListStatus();
    movieDetailBloc = MovieDetailBloc(
      mockGetMovieDetail,
      mockGetWatchListStatus,
    );
  });

  test('initial state should be empty', () {
    expect(movieDetailBloc.state, MovieDetailEmpty());
  });

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

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, HasData] with isAddedWatchlist false when data is gotten successfully',
    build: () {
      when(mockGetMovieDetail.execute(tMovieDetail.id))
          .thenAnswer((_) async => Right(tMovieDetail));
      when(mockGetWatchListStatus.execute(tMovieDetail.id))
          .thenAnswer((_) async => false);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchDetailMovies(tMovieDetail.id)),
    expect: () => <MovieDetailState>[
      MovieDetailLoading(),
      MovieDetailHasData(tMovieDetail, false)
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tMovieDetail.id));
      verify(mockGetWatchListStatus.execute(tMovieDetail.id));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, HasData] with isAddedWatchlist true when data is gotten successfully',
    build: () {
      when(mockGetMovieDetail.execute(tMovieDetail.id))
          .thenAnswer((_) async => Right(tMovieDetail));
      when(mockGetWatchListStatus.execute(tMovieDetail.id))
          .thenAnswer((_) async => true);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchDetailMovies(tMovieDetail.id)),
    expect: () => <MovieDetailState>[
      MovieDetailLoading(),
      MovieDetailHasData(tMovieDetail, true)
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tMovieDetail.id));
      verify(mockGetWatchListStatus.execute(tMovieDetail.id));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Error] when get movie detail is unsuccessful',
    build: () {
      when(mockGetMovieDetail.execute(tMovieDetail.id))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetWatchListStatus.execute(tMovieDetail.id))
          .thenAnswer((_) async => false);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchDetailMovies(tMovieDetail.id)),
    expect: () => <MovieDetailState>[
      MovieDetailLoading(),
      MovieDetailError('Server Failure')
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tMovieDetail.id));
      verify(mockGetWatchListStatus.execute(tMovieDetail.id));
    },
  );
}


import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecase/get_movie_recommendations.dart';
import 'package:movie/presentation/bloc/movie_recommendations/movie_recommendations_bloc.dart';

import 'movie_recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main(){
  late MovieRecommendationsBloc movieRecommendationsBloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationsBloc = MovieRecommendationsBloc(mockGetMovieRecommendations);
  });

  test('initial state should be empty', () {
    expect(movieRecommendationsBloc.state, MovieRecommendationsEmpty());
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
    'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieRecommendations.execute(tMovieModel.id))
          .thenAnswer((_) async => Right(tMovieList));
      return movieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(FetchRecommendationsMovies(tMovieModel.id)),
    expect: () => <MovieRecommendationsState>[MovieRecommendationsLoading(), MovieRecommendationsHasData(tMovieList)],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(tMovieModel.id));
    },
  );

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetMovieRecommendations.execute(tMovieModel.id))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(FetchRecommendationsMovies(tMovieModel.id)),
    expect: () => <MovieRecommendationsState>[MovieRecommendationsLoading(), MovieRecommendationsError('Server Failure')],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(tMovieModel.id));
    },
  );

  group('test props', () {
    test('test props in FetchRecommendationsMovies', () {
      final event = FetchRecommendationsMovies(tMovieModel.id);

      expect(event.props, [tMovieModel.id]);
    });
  });
}
import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecase/remove_watchlist.dart';
import 'package:movie/domain/usecase/save_watchlist.dart';
import 'package:movie/presentation/bloc/movie_watchlist/movie_watchlist_bloc.dart';

import 'movie_watchlist_bloc_test.mocks.dart';


@GenerateMocks(
    [SaveWatchlist, RemoveWatchlist])
void main() {
  late MovieWatchlistBloc movieWatchlistBloc;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    movieWatchlistBloc = MovieWatchlistBloc(
      mockSaveWatchlist,
      mockRemoveWatchlist,
    );
  });

  test('initial state should be empty', () {
    expect(movieWatchlistBloc.state, const MovieWatchlistInitial(''));
  });

  const tMovieDetail = MovieDetail(
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

  const watchlistAddSuccessMessage = 'Added to Watchlist';
  const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit successful message when add movie to watchlist successfully',
    build: () {
      when(mockSaveWatchlist.execute(tMovieDetail))
          .thenAnswer((_) async => const Right(watchlistAddSuccessMessage));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(const AddMovieToWatchList(tMovieDetail)),
    expect: () => <MovieWatchlistState>[
      const WatchlistAddMovieMessage(watchlistAddSuccessMessage)
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(tMovieDetail));
    },
  );

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit error message when add movie to watchlist unsuccessful',
    build: () {
      when(mockSaveWatchlist.execute(tMovieDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(const AddMovieToWatchList(tMovieDetail)),
    expect: () => <MovieWatchlistState>[
      const WatchlistAddMovieMessage('Failed')
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(tMovieDetail));
    },
  );

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit successful message when remove movie from watchlist successfully',
    build: () {
      when(mockRemoveWatchlist.execute(tMovieDetail))
          .thenAnswer((_) async => const Right(watchlistRemoveSuccessMessage));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(const RemoveMovieFromWatchList(tMovieDetail)),
    expect: () => <MovieWatchlistState>[
      const WatchlistRemoveMovieMessage(watchlistRemoveSuccessMessage)
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(tMovieDetail));
    },
  );

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit error message when remove movie from watchlist unsuccessful',
    build: () {
      when(mockRemoveWatchlist.execute(tMovieDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(const RemoveMovieFromWatchList(tMovieDetail)),
    expect: () => <MovieWatchlistState>[
      const WatchlistRemoveMovieMessage('Failed')
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(tMovieDetail));
    },
  );

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit WatchlistAddMovieMessage when MovieIsAddedToWatchList triggered',
    build: () => movieWatchlistBloc,
    act: (bloc) => bloc.add(MovieIsAddedToWatchList()),
    expect: () => <MovieWatchlistState>[
      const WatchlistAddMovieMessage('')
    ],
  );

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit WatchlistRemoveMovieMessage when MovieIsRemovedFromWatchList triggered',
    build: () =>movieWatchlistBloc,
    act: (bloc) => bloc.add(MovieIsRemovedFromWatchList()),
    expect: () => <MovieWatchlistState>[
      const WatchlistRemoveMovieMessage('')
    ],
  );

  group('test props', () {
    test('test props in AddMovieToWatchList', () {
      const event = AddMovieToWatchList(tMovieDetail);

      expect(event.props, [tMovieDetail]);
    });

    test('test props in RemoveMovieFromWatchList', () {
      const event = RemoveMovieFromWatchList(tMovieDetail);

      expect(event.props, [tMovieDetail]);
    });

    test('test props in MovieIsAddedToWatchList', () {
      final event = MovieIsAddedToWatchList();

      expect(event.props, []);
    });

    test('test props in MovieIsRemovedFromWatchList', () {
      final event = MovieIsRemovedFromWatchList();

      expect(event.props, []);
    });
  });
}

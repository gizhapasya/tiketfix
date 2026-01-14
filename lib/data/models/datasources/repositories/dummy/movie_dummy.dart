import 'package:tiketfix/domain/entities/repositories/usecases/movie.dart';

final List<Movie> movieList = [
  Movie(
    title: 'Avengers: Endgame',
    genre: 'Action, Sci-Fi',
    duration: '181 menit',
    rating: '8.4',
    schedules: ['10:00', '13:00', '16:30', '19:30'],
  ),
  Movie(
    title: 'Dilan 1990',
    genre: 'Romance',
    duration: '110 menit',
    rating: '7.1',
    schedules: ['11:00', '14:00', '17:00', '20:00'],
  ),
  Movie(
    title: 'Pengabdi Setan',
    genre: 'Horror',
    duration: '107 menit',
    rating: '6.9',
    schedules: ['12:00', '15:00', '18:00', '21:00'],  
  ),
  Movie(
    title: 'KKN di Desa Penari',
    genre: 'Horror',
    duration: '130 menit',
    rating: '6.5',
    schedules: ['10:30', '13:30', '16:30', '19:30'],  
  ),
];

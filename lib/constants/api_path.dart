class ApiPath {

 static const String baseUrl = 'https://api.themoviedb.org/3/';
 static const String imageBaseUrl = 'https://image.tmdb.org/t/p/original/';

 static const String moviePath = 'movie';
 static const String genrePath = 'genre';

 static const popularMovies = '$moviePath/popular';

 static const topRatedMovies = '$moviePath/top_rated';

 static const upcomingMovies = '$moviePath/upcoming';

 static const genreList = '$genrePath/movie/list';
}


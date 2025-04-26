import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solguruz_practical_task/constants/assets_constants.dart';
import 'package:solguruz_practical_task/features/movies/cubit/movies_cubit.dart';
import 'package:solguruz_practical_task/features/movies/widgets/movie_card.dart';
import 'package:solguruz_practical_task/features/widgets/base_screen.dart';
import 'package:solguruz_practical_task/features/widgets/custom_image_view.dart';
import 'package:solguruz_practical_task/features/widgets/custom_text_form_field.dart';
import 'package:solguruz_practical_task/features/widgets/error_message_widget.dart';
import 'package:solguruz_practical_task/features/widgets/pagination_list_widget.dart';
import 'package:solguruz_practical_task/theme/colors.dart';
import 'package:solguruz_practical_task/theme/styles.dart';
import 'package:solguruz_practical_task/utils/size_utils.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MoviesCubit>().initPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'CineVerse',
      child: BlocBuilder<MoviesCubit, MoviesState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 4,
                    child: CustomTextFormField(
                      controller: _searchController,
                      hintText: 'Search for movies',
                      onChanged: (value) {
                        setState(() {
                          _searchController.text = value;
                        });
                      },
                      suffix: IconButton(
                        icon: _searchController.text.isNotEmpty
                            ? Icon(
                                Icons.clear,
                                size: 24.h,
                              )
                            : Icon(Icons.search, size: 24.h),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      onPressed: () {
                        // Add your action here
                      },
                      child: CustomImageView(
                        imagePath: filterIcon,
                        height: 24.h,
                        width: 24.w,
                        fit: BoxFit.cover,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              // toggle button between list and grid view
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Popular Movies', style: Styles.titleMedium),
                  IconButton(
                    icon: Icon(
                        state.gridView ? Icons.list_rounded : Icons.grid_view),
                    onPressed: () {
                      context.read<MoviesCubit>().toggleGridView();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 16.h,
              ),

              Flexible(
                fit: FlexFit.tight,
                child: state.status == MoviesStatus.loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : state.status == MoviesStatus.failure
                        ? ErrorMessageWidget(
                            message: state.errorMessage,
                            isEmpty: state.popularMovies.isEmpty,
                          )
                        : PaginationListWidget(
                            isGridView: state.gridView,
                            itemCount: state.popularMovies.length,
                            itemBuilder: (context, index) {
                              return MovieCard(
                                movie: state.popularMovies[index],
                                isGridView: true,
                              );
                            },
                            loadNextPage: () {
                              context
                                  .read<MoviesCubit>()
                                  .loadNextPopularMoviesPage();
                            },
                            showLoadingIndicator:
                                state.status == MoviesStatus.loadingNextPage &&
                                    state.currentPage < state.totalPages,
                          ),
              )
            ],
          );
        },
      ),
    );
  }
}

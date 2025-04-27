import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solguruz_practical_task/constants/assets_constants.dart';
import 'package:solguruz_practical_task/features/filter_movies/cubit/filter_movies_cubit.dart';
import 'package:solguruz_practical_task/features/movies/widgets/genre_filter_bottomsheet.dart';
import 'package:solguruz_practical_task/features/widgets/custom_image_view.dart';
import 'package:solguruz_practical_task/features/widgets/custom_text_form_field.dart';
import 'package:solguruz_practical_task/models/genre_model.dart';
import 'package:solguruz_practical_task/theme/colors.dart';
import 'package:solguruz_practical_task/utils/size_utils.dart';

class FilterSection extends StatefulWidget {
  final List<Genre> genres;
  const FilterSection({super.key, required this.genres});

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final filterMoviesCubit = context.read<FilterMoviesCubit>();

    return BlocBuilder<FilterMoviesCubit, FilterMoviesState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 4,
              child: CustomTextFormField(
                  controller: _searchController,
                  hintText: 'Search movies...',
                  onChanged: (value) {
                    setState(() {
                      _searchController.text = value;
                    });
                    filterMoviesCubit.searchMovies(value.trim());
                  },
                  prefix: CustomImageView(
                    imagePath: searchIcon,
                    fit: BoxFit.cover,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  prefixConstraints: BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                    maxWidth: 42.w,
                    maxHeight: 42.h,
                  ),
                  suffix: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 24.h,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                      filterMoviesCubit.searchMovies('');
                    },
                  )
                      : null),
            ),
            Flexible(
              flex: 1,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return GenreFilterBottomSheet(
                            genres: widget.genres,
                            selectedGenres: state.selectedGenres,
                            onFiltersApplied: (List<Genre> genres) {
                              filterMoviesCubit.filterMoviesByGenres(genres);
                            },
                            onFiltersCleared: () {
                              filterMoviesCubit.filterMoviesByGenres([]);
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 50.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.all(10.w),
                      child: CustomImageView(
                        imagePath: filterIcon,
                        fit: BoxFit.cover,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  if (state.selectedGenres.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        height: 10.h,
                        width: 10.w,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solguruz_practical_task/constants/assets_constants.dart';
import 'package:solguruz_practical_task/features/movies/cubit/movies_cubit.dart';
import 'package:solguruz_practical_task/features/movies/widgets/movies_screen_tabs.dart';
import 'package:solguruz_practical_task/features/widgets/base_screen.dart';
import 'package:solguruz_practical_task/features/widgets/custom_image_view.dart';
import 'package:solguruz_practical_task/features/widgets/custom_text_form_field.dart';
import 'package:solguruz_practical_task/models/genre_model.dart';
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
    context.read<MoviesCubit>().initMovies(movieType: MovieType.popular);
    context.read<MoviesCubit>().initMovies(movieType: MovieType.topRated);
    context.read<MoviesCubit>().initMovies(movieType: MovieType.upcoming);
    context.read<MoviesCubit>().initGenres();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: BlocBuilder<MoviesCubit, MoviesState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 16.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _listingViewButton(
                    context,
                    isGridView: true,
                    chosen: state.gridView,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  _listingViewButton(
                    context,
                    isGridView: false,
                    chosen: !state.gridView,
                  ),
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              _filterSection(
                context,
                onQueryChanged: (value) {
                  context.read<MoviesCubit>().searchMovies(query: value.trim());
                },
                genres: state.genres,
              ),
              SizedBox(
                height: 16.h,
              ),
              const Flexible(
                fit: FlexFit.tight,
                child: MoviesScreenTabs(),
              )
            ],
          );
        },
      ),
    );
  }

  _filterSection(
    BuildContext context, {
    required Function(String) onQueryChanged,
        required List<Genre> genres,
  }) {
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
                onQueryChanged(value);
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
                        onQueryChanged('');
                      },
                    )
                  : null),
        ),
        Flexible(
          flex: 1,
          child: MenuAnchor(
            style: MenuStyle(
              backgroundColor: const WidgetStatePropertyAll<Color>(
                containerColor
              ),
              maximumSize: WidgetStatePropertyAll<Size>(
                Size(200.w, 300.h),
              ),
              shape: const WidgetStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
              padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                EdgeInsets.all(10),
              ),
            ),
            builder: (context, MenuController controller, Widget? child) {
              return FloatingActionButton(
                backgroundColor: Colors.white.withOpacity(0.2),
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                child: CustomImageView(
                  imagePath: filterIcon,
                  height: 24.h,
                  width: 24.w,
                  fit: BoxFit.cover,
                  color: Colors.white.withOpacity(0.8),
                ),
              );
            },
            menuChildren: [
              for (var genre in genres)
                MenuItemButton(
                  onPressed: () {
                    // context.read<MoviesCubit>().filterMoviesByGenre(genre.id);
                  },
                  child: Text(
                    genre.name,
                    style: Styles.bodyMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  _listingViewButton(
    BuildContext context, {
    required bool isGridView,
    required bool chosen,
  }) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: chosen ? primaryColor : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        height: 30.h,
        width: 30.w,
        child: Icon(
          isGridView ? Icons.grid_view_rounded : Icons.list_rounded,
          color: Colors.white,
          size: 18.h,
        ),
      ),
      onTap: () {
        context.read<MoviesCubit>().toggleGridView(isGridView);
      },
    );
  }
}

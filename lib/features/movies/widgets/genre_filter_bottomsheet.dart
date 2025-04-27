import 'package:flutter/material.dart';
import 'package:solguruz_practical_task/features/widgets/custom_button.dart';
import 'package:solguruz_practical_task/models/genre_model.dart';
import 'package:solguruz_practical_task/theme/colors.dart';
import 'package:solguruz_practical_task/theme/styles.dart';
import 'package:solguruz_practical_task/utils/size_utils.dart';

class GenreFilterBottomSheet extends StatefulWidget {
  final List<Genre> genres;
  final List<Genre> selectedGenres;
  final Function(List<Genre> genres) onFiltersApplied;
  final Function() onFiltersCleared;
  const GenreFilterBottomSheet({super.key,
    required this.genres,
    required this.selectedGenres,
    required this.onFiltersApplied,
    required this.onFiltersCleared,});

  @override
  State<GenreFilterBottomSheet> createState() => _GenreFilterBottomSheetState();
}

class _GenreFilterBottomSheetState extends State<GenreFilterBottomSheet> {
  List<Genre> selectedGenres = [];

  @override
  void initState() {
    super.initState();
    selectedGenres = widget.selectedGenres;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      height: 300.h,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.h),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.genres.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (selectedGenres.contains(widget.genres[index])) {
                        selectedGenres =
                            selectedGenres
                                .where((genre) => genre != widget.genres[index])
                                .toList();
                      } else {
                        selectedGenres =
                            [...selectedGenres, widget.genres[index]];
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    margin: EdgeInsets.only(bottom: 8.h),
                    decoration: BoxDecoration(
                      color: selectedGenres.contains(widget.genres[index])
                          ? primaryColor
                          : containerColor,
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                    child: Text(
                      widget.genres[index].name,
                      style: Styles.labelMedium.copyWith(
                        color: selectedGenres.contains(widget.genres[index])
                            ? Colors.white
                            : secondaryTextColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: CustomButton(
                  text: "Clear",
                  onPressed: () {
                    widget.onFiltersCleared();
                    Navigator.pop(context);
                  },
                  buttonBackgroundColor: Colors.transparent,
                  buttonBorderColor: primaryColor,
                  buttonTextStyle: Styles.labelMedium.copyWith(
                    color: primaryColor,
                  ),
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              Flexible(
                flex: 1,
                child: CustomButton(
                  text: "Apply",
                  onPressed: () {
                    widget.onFiltersApplied(selectedGenres);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );

  }
}

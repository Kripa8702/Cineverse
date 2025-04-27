import 'package:flutter/material.dart';
import 'package:solguruz_practical_task/theme/colors.dart';
import 'package:solguruz_practical_task/utils/size_utils.dart';

class PaginationListWidget extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Function() loadNextPage;
  final bool showLoadingIndicator;
  final bool isGridView;

  const PaginationListWidget({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.loadNextPage,
    this.showLoadingIndicator = false,
    this.isGridView = true,
  });

  @override
  State<PaginationListWidget> createState() => _PaginationListWidgetState();
}

class _PaginationListWidgetState extends State<PaginationListWidget> {
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent &&
          controller.offset <= controller.position.maxScrollExtent + 100) {
        widget.loadNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: widget.isGridView
              ? GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 22.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 120.w/240.h,
                  ),
                  itemCount: widget.itemCount,
                  itemBuilder: widget.itemBuilder,
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    top: 0,
                    bottom: 16.h,
                  ),
                  itemCount: widget.itemCount,
                  itemBuilder: widget.itemBuilder,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 16.h);
                  },
                ),
        ),
        if (widget.showLoadingIndicator) ...[
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50.h,
              width: double.maxFinite,
              child: Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20.h,
            ),
          ),
        ],
        SliverToBoxAdapter(
          child: SizedBox(
            height: 50.h,
          ),
        ),
      ],
    );
  }
}

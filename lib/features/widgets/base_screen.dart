import 'package:flutter/material.dart';
import 'package:solguruz_practical_task/theme/colors.dart';
import 'package:solguruz_practical_task/theme/styles.dart';
import 'package:solguruz_practical_task/utils/size_utils.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({
    super.key,
    required this.child,
    this.title,
    this.verticalPadding = 0,
    this.horizontalPadding = 16,
    this.floatingActionButton,
  });

  final Widget child;
  final String? title;
  final double verticalPadding;
  final double horizontalPadding;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        bottom: false,
        top: verticalPadding > 0,
        child: body,
      ),
    );
  }

  Widget get body => Column(
        children: [
          if (title != null ) appBar,
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding.w,
                  vertical: verticalPadding.h,
                ),
                child: child,
              ),
            ),
          ),
        ],
      );

  Widget get appBar => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title ?? "",
              style: Styles.titleLarge.copyWith(
                fontSize: 32.fSize,
                color: primaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
}

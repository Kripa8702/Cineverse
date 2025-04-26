import 'package:flutter/material.dart';
import 'package:solguruz_practical_task/constants/assets_constants.dart';
import 'package:solguruz_practical_task/theme/colors.dart';
import 'package:solguruz_practical_task/theme/styles.dart';
import 'package:solguruz_practical_task/utils/size_utils.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String? message;
  final bool isEmpty;
  final VoidCallback? onRetry;

  const ErrorMessageWidget({
    super.key,
    required this.message,
    this.isEmpty = false,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isEmpty
              ? Image.asset(
                  crossCircleIcon,
                  height: 60.h,
                  color: warningColor,
                )
              : Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                  size: 65.h,
                ),
          SizedBox(
            height: 25.h,
          ),
          Text(
            "Oops!",
            style: Styles.titleMedium.copyWith(
              color: isEmpty ? warningColor : Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.h),
          Text(
            isEmpty
                ? "No data available."
                : message ?? 'Something went wrong. Please try again later.',
            style: Styles.bodyMedium.copyWith(
              fontSize: 14.fSize,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.h,
          ),
          isEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: warningColor,
                    size: 30.h,
                  ),
                  onPressed: () {
                    if (onRetry != null) {
                      onRetry!();
                    }
                  },
                )
              : ElevatedButton(
                  onPressed: () {
                    if (onRetry != null) {
                      onRetry!();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minimumSize: Size(200.w, 50.h),
                  ),
                  child: Text(
                    'Try Again',
                    style: Styles.titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

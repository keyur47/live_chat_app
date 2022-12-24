import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class LoaderView extends StatelessWidget {
  const LoaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("container loader view");
    return Container(
        color: AppColors.black.withOpacity(0.2),
        child: const Center(
          child: CircularProgressIndicator(
            backgroundColor: AppColors.black,
          ),
        ));
  }
}

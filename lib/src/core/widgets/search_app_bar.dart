import 'package:flutter/material.dart';
import 'package:fly_journey/src/core/constants/colors.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const SearchAppBar({
    super.key,
    this.title = '',
    this.onBackPressed,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.transparent,
      leading: showBackButton
          ? IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: Hero(
        tag: 'fly_journey_logo',
        child: Material(
          color: Colors.transparent,
          child: const Text(
            'Fly Journey',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Colors.grey.shade200,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

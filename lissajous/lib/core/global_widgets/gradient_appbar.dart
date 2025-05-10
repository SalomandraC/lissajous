import 'package:flutter/material.dart';
import 'package:lissajous/theme/theme.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final double fontSize;
  final bool isDarkTheme;

  const GradientAppBar({
    super.key,
    this.title,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.elevation = 0,
    this.fontSize = 24,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Gradient gradient =
        isDarkTheme ? AppTheme.gradientDark : AppTheme.gradientLigth;

    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: theme.textTheme.displaySmall?.copyWith(fontSize: fontSize),
            )
          : null,
      automaticallyImplyLeading: automaticallyImplyLeading,
      bottom: bottom,
      elevation: elevation,
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: gradient),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}

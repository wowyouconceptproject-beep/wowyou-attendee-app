import "package:flutter/material.dart";

import "package:attendee_app/theme/app_colors.dart";

class CategoryStrip extends StatefulWidget {
  final List<String> categories;

  final ValueChanged<String>? onSelected;

  const CategoryStrip({
    super.key,
    required this.categories,
    this.onSelected,
  });

  @override
  State<CategoryStrip> createState() =>
      _CategoryStripState();
}

class _CategoryStripState
    extends State<CategoryStrip> {
  late String selected;

  @override
  void initState() {
    super.initState();

    selected = widget.categories.first;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final category =
              widget.categories[index];

          final active =
              selected == category;

          return GestureDetector(
            onTap: () {
              setState(() {
                selected = category;
              });

              widget.onSelected?.call(
                category,
              );
            },
            child: AnimatedContainer(
              duration:
                  const Duration(
                milliseconds: 250,
              ),
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primary
                    : AppColors.card,
                borderRadius:
                    BorderRadius.circular(
                  50,
                ),
                border: Border.all(
                  color: active
                      ? AppColors.primary
                      : AppColors.border,
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: active
                        ? Colors.white
                        : AppColors.text,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
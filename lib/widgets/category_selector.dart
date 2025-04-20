import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kite/extensions/category_emoji.dart';
import 'package:kite/models/category.dart';

class CategorySelector extends StatelessWidget {
  final AsyncValue<CategoriesResponse> categories;
  final Category? selectedCategory;
  final ValueChanged<Category> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return PinnedHeaderSliver(
      child: categories.maybeWhen(
        data:
            (res) => Container(
              height: 40,
              margin: const EdgeInsets.only(top: 8, bottom: 12),
              child: ListView.builder(
                itemCount: res.categories.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (BuildContext context, int index) {
                  final category = res.categories[index];
                  final isSelected = selectedCategory?.file == category.file;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => onCategorySelected(category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? CupertinoColors.activeBlue.withOpacity(0.7)
                                  : CupertinoColors.darkBackgroundGray,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${category.emoji} ${category.name}',
                          style: theme.textTheme.textStyle,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        error: (error, _) => const SizedBox.shrink(),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:kite/models/category.dart';
import 'package:kite/providers/index.dart';
import 'package:kite/services/storage.dart';
import 'package:kite/widgets/category_selector.dart';
import 'package:kite/widgets/news_content_sliver.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  Category? selectedCategory;

  CupertinoThemeData get theme => CupertinoTheme.of(context);

  @override
  void initState() {
    super.initState();
    _loadLastSelectedCategory();
  }

  Future<void> _loadLastSelectedCategory() async {
    final lastCategoryFile = Storage.getLastSelectedCategory();

    // The category will be properly set when data is loaded in didChangeDependencies
    if (lastCategoryFile != null) {
      // We just store the file name to find the category later
      setState(() {
        // This is just a temporary placeholder to indicate we have a stored preference
        selectedCategory = Category(name: '', file: lastCategoryFile);
      });
    }
  }

  Future<void> _saveSelectedCategory(String categoryFile) async {
    await Storage.setLastSelectedCategory(categoryFile);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if categories are loaded and we need to select one
    final categories = ref.watch(categoriesProvider);
    categories.whenData((res) {
      if (res.categories.isNotEmpty) {
        if (selectedCategory == null) {
          // No category selected yet, select the first one
          _selectCategory(res.categories.first);
        } else if (selectedCategory!.name.isEmpty) {
          // We have a stored category file but haven't loaded the full category yet
          final storedCategoryFile = selectedCategory!.file;
          final matchingCategory = res.categories.firstWhere(
            (category) => category.file == storedCategoryFile,
            orElse: () => res.categories.first,
          );
          _selectCategory(matchingCategory);
        }
      }
    });
  }

  void _selectCategory(Category category) {
    setState(() {
      selectedCategory = category;
    });
    unawaited(HapticFeedback.selectionClick());
    _saveSelectedCategory(category.file);
  }

  @override
  Widget build(BuildContext context) {
    // Auto-select when loading the category list
    ref.listen<AsyncValue<CategoriesResponse>>(categoriesProvider, (
      prev,
      next,
    ) {
      next.whenData((res) {
        if (selectedCategory == null) {
          _selectCategory(res.categories.first);
        } else if (selectedCategory!.name.isEmpty) {
          final file = selectedCategory!.file;
          final match = res.categories.firstWhere(
            (c) => c.file == file,
            orElse: () => res.categories.first,
          );
          _selectCategory(match);
        }
      });
    });

    final categories = ref.watch(categoriesProvider);
    final newsAsync =
        selectedCategory != null
            ? ref.watch(categoryNewsProvider(selectedCategory!.file))
            : null;

    return CupertinoPageScaffold(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Row(
                children: [
                  SvgPicture.asset(
                    'assets/kite_dark.svg',
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 8),
                  Text('Kite'),
                ],
              ),
              stretch: true,
              backgroundColor: CupertinoColors.darkBackgroundGray,
              alwaysShowMiddle: false,
              middle: Text(
                'Today, ${DateFormat('MMMM d').format(DateTime.now())}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            CategorySelector(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: _selectCategory,
            ),
            if (selectedCategory != null && newsAsync != null)
              NewsContentSliver(newsAsync: newsAsync)
            else
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

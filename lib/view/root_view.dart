import 'package:flutter/material.dart';
import 'package:food_recipes_afame/view/Blogs/blogs_view.dart';
import 'package:food_recipes_afame/view/Explore/explore_view.dart';
import 'package:food_recipes_afame/view/Favorites/favorites_view.dart';
import 'package:food_recipes_afame/view/HomePage/home_page.dart';
import 'package:food_recipes_afame/view/Profile/profile_view.dart';
import 'package:food_recipes_afame/view/Recipes/recipe_view.dart';
import 'package:food_recipes_afame/utils/colors.dart';
import 'package:food_recipes_afame/utils/image_paths.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});
  static int currentIndex = 0;

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: RootView.currentIndex,
        children: [
          HomeView(),
          ExploreView(),
          RecipesView(),
          FavoritesView(),
          BlogsView(),
          ProfileView(),
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavBar(
        currentIndex: RootView.currentIndex,
        onTap: (index) {
          setState(() {
            RootView.currentIndex = index;
          });
        },
      ),
    );
  }
}

class AnimatedBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AnimatedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<AnimatedBottomNavBar> createState() => _AnimatedBottomNavBarState();
}

class _AnimatedBottomNavBarState extends State<AnimatedBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<_NavItem> _items = [
    _NavItem(
      selectedImagePath: ImagePaths.homeSelected,
      unselectedImagePath: ImagePaths.homeUnselected,
      label: "Home",
    ),
    _NavItem(
      selectedImagePath: ImagePaths.exploreSelected,
      unselectedImagePath: ImagePaths.exploreUnselected,
      label: "Explore",
    ),
    _NavItem(
      selectedImagePath: ImagePaths.recipesSelected,
      unselectedImagePath: ImagePaths.recipesUnselected,
      label: "Recipe",
    ),
    _NavItem(
      selectedImagePath: ImagePaths.favoriteSelected,
      unselectedImagePath: ImagePaths.favoriteUnselected,
      label: "Favorites",
    ),
    _NavItem(
      selectedImagePath: ImagePaths.blogsSelected,
      unselectedImagePath: ImagePaths.blogsUnselected,
      label: "Blogs",
    ),
    _NavItem(
      selectedImagePath: ImagePaths.profileSelected,
      unselectedImagePath: ImagePaths.profileUnselected,
      label: "Profile",
    ),
  ];

  double get _itemWidth => MediaQuery.of(context).size.width / _items.length;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(
      begin: widget.currentIndex.toDouble(),
      end: widget.currentIndex.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant AnimatedBottomNavBar oldWidget) {
    if (oldWidget.currentIndex != widget.currentIndex) {
      _animation = Tween<double>(
        begin: oldWidget.currentIndex.toDouble(),
        end: widget.currentIndex.toDouble(),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    if (index != widget.currentIndex) {
      widget.onTap(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      color: AppColors.primary,
      child: Stack(
        children: [
          Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isActive = widget.currentIndex == index;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _onTap(index),
                  child: SizedBox(
                    height: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          isActive
                              ? item.selectedImagePath
                              : item.unselectedImagePath,
                          width: 26,
                          height: 26,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            color: isActive ? AppColors.white : Colors.black38,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          child: commonText(item.label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),

          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                left: _animation.value * _itemWidth + (_itemWidth - 30) / 2,
                bottom: 16,
                child: Container(
                  width: 30,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(27),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final String selectedImagePath;
  final String unselectedImagePath;
  final String label;

  _NavItem({
    required this.selectedImagePath,
    required this.unselectedImagePath,
    required this.label,
  });
}

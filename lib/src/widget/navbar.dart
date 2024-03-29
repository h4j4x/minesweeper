import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../model/nav_item.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final List<NavItem> navItems;
  final Function(int) onChangeIndex;

  const NavBar({
    super.key,
    required this.selectedIndex,
    required this.navItems,
    required this.onChangeIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
          child: GNav(
            rippleColor: theme.colorScheme.tertiaryContainer,
            hoverColor: theme.colorScheme.onTertiaryContainer,
            gap: 4,
            activeColor: theme.colorScheme.onSecondaryContainer,
            iconSize: 20,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            duration: const Duration(milliseconds: 200),
            tabBackgroundColor: theme.colorScheme.primaryContainer,
            color: theme.colorScheme.onPrimaryContainer,
            tabs: navItems
                .map(
                  (item) => GButton(
                    icon: item.icon,
                    text: item.title,
                  ),
                )
                .toList(),
            selectedIndex: selectedIndex,
            onTabChange: onChangeIndex,
          ),
        ),
      ),
    );
  }
}

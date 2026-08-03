import "package:flutter/material.dart";

import "../utils/theme.dart";

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore_rounded,
      label: "Discover"
    ),
    (
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
      label: "For You"
    ),
    (icon: Icons.map_outlined, activeIcon: Icons.map_rounded, label: "Map"),
    (
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: "Profile"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 6, 16, 12 + bottomInset),
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppTheme.border),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryDark.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isSelected = index == currentIndex;
            return Expanded(
              child: Semantics(
                button: true,
                selected: isSelected,
                label: item.label,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.textSecondary,
                          size: 21,
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              item.label,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

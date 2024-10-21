import 'package:flutter/material.dart';
import 'tab_item.dart';

class TabSelector extends StatelessWidget {
  final bool isExistingUser;
  final Function(bool) onToggle;

  const TabSelector({
    super.key,
    required this.isExistingUser,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabItem(title: "Existing", isSelected: isExistingUser, onTap: () => onToggle(true)),
          TabItem(title: "New", isSelected: !isExistingUser, onTap: () => onToggle(false)),
        ],
      ),
    );
  }
}

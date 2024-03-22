import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final VoidCallback? onSharePressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onCancelPressed;

  const BottomNavBar({
    super.key,
    this.onSharePressed,
    this.onDeletePressed,
    this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: onSharePressed,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDeletePressed,
          ),
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: onCancelPressed,
          ),
        ],
      ),
    );
  }
}

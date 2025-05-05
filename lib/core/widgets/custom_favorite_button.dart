import 'package:flutter/material.dart';

class FavoriteIconButton extends StatefulWidget {
  final bool isFavorite;
  final double? size; // Make size optional
  final Color? activeColor;
  final Color? inactiveColor;
  final ValueChanged<bool> onToggle;

  const FavoriteIconButton({
    super.key,
    required this.isFavorite,
    required this.onToggle,
    this.size, // No default value here
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<FavoriteIconButton> createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends State<FavoriteIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    widget.onToggle(_isFavorite);
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        icon: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite
              ? widget.activeColor ?? Colors.red
              : widget.inactiveColor ?? Colors.grey,
          size: widget.size ?? 28.0, // Default to 28 if size is not provided
        ),
        onPressed: _toggleFavorite,
      ),
    );
  }
}

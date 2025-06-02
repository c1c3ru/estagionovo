// lib/core/widgets/loading_indicator.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart'; // Para cor primária

class LoadingIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;

  const LoadingIndicator({
    Key? key,
    this.size = 40.0,
    this.strokeWidth = 4.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

// Widget para mostrar um loading overlay sobre outro widget
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final double opacity;
  final Color? color; // Cor do overlay
  final Widget? progressIndicator;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.opacity = 0.5,
    this.color,
    this.progressIndicator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: (color ?? Colors.black).withOpacity(opacity),
              child: progressIndicator ?? const LoadingIndicator(),
            ),
          ),
      ],
    );
  }
}

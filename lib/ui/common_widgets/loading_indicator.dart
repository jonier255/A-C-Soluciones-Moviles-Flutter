import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;
  final double size;
  final String? message;

  const LoadingIndicator({
    super.key,
    this.color = const Color(0xFF2E91D8),
    this.size = 40,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SmallLoadingIndicator extends StatelessWidget {
  final Color color;

  const SmallLoadingIndicator({
    super.key,
    this.color = const Color(0xFF2E91D8),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

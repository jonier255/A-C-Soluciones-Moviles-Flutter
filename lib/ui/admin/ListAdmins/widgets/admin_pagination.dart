import 'package:flutter/material.dart';

/// Controles de paginación para la lista de administradores
class AdminPaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const AdminPaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final buttonSize = isTablet ? 48.0 : 40.0;
    final fontSize = isTablet ? 16.0 : 15.0;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isTablet ? 20 : 16,
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentPage > 1)
            _ArrowButton(
              icon: Icons.chevron_left_rounded,
              onPressed: () => onPageChanged(currentPage - 1),
              size: buttonSize,
            ),
          SizedBox(width: isTablet ? 12 : 8),
          ...List.generate(totalPages, (index) {
            final pageNumber = index + 1;
            return _PageButton(
              text: pageNumber.toString(),
              selected: pageNumber == currentPage,
              onPressed: () => onPageChanged(pageNumber),
              size: buttonSize,
              fontSize: fontSize,
            );
          }),
          SizedBox(width: isTablet ? 12 : 8),
          if (currentPage < totalPages)
            _ArrowButton(
              icon: Icons.chevron_right_rounded,
              onPressed: () => onPageChanged(currentPage + 1),
              size: buttonSize,
            ),
        ],
      ),
    );
  }
}

/// Page number button
class _PageButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onPressed;
  final double size;
  final double fontSize;

  const _PageButton({
    required this.text,
    required this.selected,
    required this.onPressed,
    required this.size,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: selected ? const Color.fromARGB(255, 43, 46, 206) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: selected ? 4 : 0,
        shadowColor: const Color.fromARGB(255, 37, 48, 197).withValues(alpha: 0.3),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: selected
                  ? null
                  : Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF636E72),
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Arrow button for navigation
class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const _ArrowButton({
    required this.icon,
    required this.onPressed,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 17, 68, 209),
      borderRadius: BorderRadius.circular(12),
      elevation: 4,
      shadowColor: const Color.fromARGB(255, 19, 38, 211).withValues(alpha: 0.3),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: Colors.white,
            size: size * 0.6,
          ),
        ),
      ),
    );
  }
}

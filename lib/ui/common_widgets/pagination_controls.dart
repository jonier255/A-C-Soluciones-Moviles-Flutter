import 'package:flutter/material.dart';

/// Controles de paginación reutilizables
class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;
  final Color? primaryColor;
  final Color? selectedColor;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.primaryColor,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;
    final sh = size.height;

    final maxVisiblePages = sw > 600 ? 5 : 3;
    final visiblePages = _getVisiblePages(totalPages, currentPage, maxVisiblePages);

    return Container(
      padding: EdgeInsets.symmetric(vertical: sh * 0.01, horizontal: sw * 0.04),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentPage > 1)
              _ArrowButton(
                text: "<",
                onPressed: () => onPageChanged(currentPage - 1),
                color: primaryColor,
              ),
            if (currentPage > 1) SizedBox(width: sw * 0.02),
            ...visiblePages.map((pageNumber) {
              if (pageNumber == -1) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: sw * 0.01),
                  child: SizedBox(
                    width: sw * 0.1,
                    child: const Center(
                      child: Text(
                        '...',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.01),
                child: _PageButton(
                  text: pageNumber.toString(),
                  selected: pageNumber == currentPage,
                  onPressed: () => onPageChanged(pageNumber),
                  primaryColor: primaryColor,
                  selectedColor: selectedColor,
                ),
              );
            }),
            if (currentPage < totalPages) SizedBox(width: sw * 0.02),
            if (currentPage < totalPages)
              _ArrowButton(
                text: ">",
                onPressed: () => onPageChanged(currentPage + 1),
                color: primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  List<int> _getVisiblePages(int total, int current, int maxVisible) {
    if (total <= maxVisible) {
      return List.generate(total, (index) => index + 1);
    }

    final half = maxVisible ~/ 2;
    int start = current - half;
    int end = current + half;

    if (start < 1) {
      start = 1;
      end = maxVisible;
    }

    if (end > total) {
      end = total;
      start = total - maxVisible + 1;
    }

    final List<int> pages = [];

    if (start > 1) {
      pages.add(1);
      if (start > 2) {
        pages.add(-1);
      }
    }

    for (int i = start; i <= end; i++) {
      pages.add(i);
    }

    if (end < total) {
      if (end < total - 1) {
        pages.add(-1);
      }
      pages.add(total);
    }

    return pages;
  }
}

class _PageButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onPressed;
  final Color? primaryColor;
  final Color? selectedColor;

  const _PageButton({
    required this.text,
    required this.selected,
    required this.onPressed,
    this.primaryColor,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;

    final Color buttonColor = selected
        ? (selectedColor ?? const Color(0xFF6B4CE6))
        : (primaryColor ?? const Color(0xFFE8EAF6));
    final Color textColor = selected ? Colors.white : const Color(0xFF6B4CE6);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: sw * 0.1,
        height: sw * 0.1,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: buttonColor.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const _ArrowButton({
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: sw * 0.1,
        height: sw * 0.1,
        decoration: BoxDecoration(
          color: color ?? const Color(0xFF6B4CE6),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: (color ?? const Color(0xFF6B4CE6)).withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

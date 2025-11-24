import 'package:flutter/material.dart';
import 'request_screen_constants.dart';

/// Pagination controls for request list
class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;
    final sh = size.height;

    // Limitar la cantidad de botones de página visibles
    final maxVisiblePages = sw > 600 ? 5 : 3;
    final List<int> visiblePages = _getVisiblePages(totalPages, currentPage, maxVisiblePages);

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
              ),
            if (currentPage > 1)
              SizedBox(width: sw * 0.02),
            ...visiblePages.map((pageNumber) {
              if (pageNumber == -1) {
                // Mostrar "..." para páginas omitidas
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
                          color: Color(0xFF6C757D),
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
                ),
              );
            }),
            if (currentPage < totalPages)
              SizedBox(width: sw * 0.02),
            if (currentPage < totalPages)
              _ArrowButton(
                text: ">",
                onPressed: () => onPageChanged(currentPage + 1),
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

    final pages = <int>[];
    
    // Agregar primera página si no está visible
    if (start > 1) {
      pages.add(1);
      if (start > 2) {
        pages.add(-1); // Marcador para "..."
      }
    }

    // Agregar páginas visibles
    for (int i = start; i <= end; i++) {
      pages.add(i);
    }

    // Agregar última página si no está visible
    if (end < total) {
      if (end < total - 1) {
        pages.add(-1); // Marcador para "..."
      }
      pages.add(total);
    }

    return pages;
  }
}

/// Page number button
class _PageButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onPressed;

  const _PageButton({
    required this.text,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;
    final buttonSize = sw * 0.1;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(buttonSize / 2),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            gradient: selected ? RequestScreenTheme.primaryGradient : null,
            color: selected ? null : RequestScreenTheme.cardBackground,
            shape: BoxShape.circle,
            boxShadow: selected ? RequestScreenTheme.buttonShadow() : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF6C757D),
                fontWeight: FontWeight.w600,
                fontSize: sw * 0.035,
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
  final String text;
  final VoidCallback onPressed;

  const _ArrowButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;
    final buttonSize = sw * 0.1;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(buttonSize / 2),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            gradient: RequestScreenTheme.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: RequestScreenTheme.buttonShadow(),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: sw * 0.04,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

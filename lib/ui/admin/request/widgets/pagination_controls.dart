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
    final paginationVerticalPadding = RequestScreenTheme.paginationVerticalPadding(size.height);
    final paginationSpacing = RequestScreenTheme.paginationSpacing(size.width);
    final paginationRunSpacing = RequestScreenTheme.paginationRunSpacing(size.height);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: paginationVerticalPadding),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: paginationSpacing,
        runSpacing: paginationRunSpacing,
        children: [
          if (currentPage > 1)
            _ArrowButton(
              text: "<",
              onPressed: () => onPageChanged(currentPage - 1),
            ),
          ...List.generate(totalPages, (index) {
            final pageNumber = index + 1;
            return _PageButton(
              text: pageNumber.toString(),
              selected: pageNumber == currentPage,
              onPressed: () => onPageChanged(pageNumber),
            );
          }),
          if (currentPage < totalPages)
            _ArrowButton(
              text: ">",
              onPressed: () => onPageChanged(currentPage + 1),
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

  const _PageButton({
    required this.text,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pageButtonPadding = RequestScreenTheme.pageButtonPadding(size.width);
    final pageButtonInnerPadding = RequestScreenTheme.pageButtonInnerPadding(size.width);

    return Container(
      padding: EdgeInsets.all(pageButtonPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.all(pageButtonInnerPadding),
          backgroundColor: selected
              ? RequestScreenTheme.lightBlue
              : RequestScreenTheme.backgroundColor,
          foregroundColor: selected
              ? Colors.white
              : RequestScreenTheme.primaryBlue,
        ),
        onPressed: onPressed,
        child: Text(text),
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
    final arrowButtonMargin = RequestScreenTheme.arrowButtonMargin(size.width);
    final arrowButtonPadding = RequestScreenTheme.arrowButtonPadding(size.width);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: arrowButtonMargin),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.all(arrowButtonPadding),
          backgroundColor: RequestScreenTheme.primaryBlue,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

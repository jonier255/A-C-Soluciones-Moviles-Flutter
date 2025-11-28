import 'package:flutter/material.dart';
import 'tecnico_menu_constants.dart';

class TecnicoMenuHeader extends StatelessWidget {
  const TecnicoMenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;
    final sh = size.height;
    
    return Container(
      height: sh * 0.15,
      decoration: BoxDecoration(
        gradient: TecnicoMenuTheme.primaryGradient,
        boxShadow: TecnicoMenuTheme.headerShadow(),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: TecnicoMenuTheme.horizontalPadding(sw),
        ),
        child: Row(
          children: [
            _buildBackButton(context, sw),
            const SizedBox(width: 12),
            Expanded(
              child: _buildHeaderText(sw),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, double sw) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: Colors.white,
        size: TecnicoMenuTheme.backButtonSize(sw),
      ),
    );
  }

  Widget _buildHeaderText(double sw) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gestión de Técnicos',
          style: TextStyle(
            fontSize: TecnicoMenuTheme.headerTitleSize(sw),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Administra el personal técnico',
          style: TextStyle(
            fontSize: TecnicoMenuTheme.headerSubtitleSize(sw),
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}

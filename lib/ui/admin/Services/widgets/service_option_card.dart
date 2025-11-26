import 'package:flutter/material.dart';
import 'service_menu_constants.dart';

class ServiceOptionCard extends StatelessWidget {
  final ServiceMenuOption option;
  
  const ServiceOptionCard({
    super.key,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final isTablet = sw > 600;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: option.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: ServiceMenuTheme.cardMaxWidth(sw),
          ),
          decoration: BoxDecoration(
            gradient: option.gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              ServiceMenuTheme.cardShadow(option.gradient.colors.first),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(ServiceMenuTheme.cardPadding(sw)),
            child: Row(
              children: [
                _buildIcon(sw, isTablet),
                SizedBox(width: ServiceMenuTheme.cardSpacing(sw)),
                Expanded(child: _buildTexts(sw, isTablet)),
                _buildArrow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(double sw, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(ServiceMenuTheme.cardIconPadding(sw)),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(64),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        option.icon,
        size: ServiceMenuTheme.cardIconSize(sw),
        color: Colors.white,
      ),
    );
  }

  Widget _buildTexts(double sw, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          option.title,
          style: TextStyle(
            fontSize: ServiceMenuTheme.cardTitleSize(sw),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: isTablet ? 8 : 6),
        Text(
          option.subtitle,
          style: TextStyle(
            fontSize: ServiceMenuTheme.cardSubtitleSize(sw),
            color: Colors.white.withAlpha(230),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildArrow() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(64),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}

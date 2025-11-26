import 'package:flutter/material.dart';

class ClientHomeContent extends StatelessWidget {
  const ClientHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1024;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        color: const Color(0xFFF5F7FA),
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? (isDesktop ? 48 : 32) : 20,
          vertical: isTablet ? 32 : 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner de la empresa
            Center(
              child: Container(
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    "assets/bannercompany-removebg-preview.png",
                    height: isTablet ? 250 : 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: isTablet ? 24 : 20),

            // Informacion de la empresa
            Container(
              padding: EdgeInsets.all(isTablet ? 24 : 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'A & C Soluciones',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 24 : 20,
                            color: const Color(0xFF2E91D8),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Reparaciones y Mantenimientos',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isTablet ? 16 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.orange[700],
                          size: isTablet ? 24 : 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '4.8',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 18 : 16,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: isTablet ? 24 : 20),

            Container(
              padding: EdgeInsets.all(isTablet ? 24 : 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2E91D8).withValues(alpha: 0.1),
                    const Color(0xFF56AFEC).withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF2E91D8).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    context: context,
                    icon: Icons.call_rounded,
                    label: 'Llamar',
                    color: Colors.green,
                    isTablet: isTablet,
                  ),
                  _buildActionButton(
                    context: context,
                    icon: Icons.shopping_cart_rounded,
                    label: 'Servicios',
                    color: const Color(0xFF2E91D8),
                    isTablet: isTablet,
                  ),
                  _buildActionButton(
                    context: context,
                    icon: Icons.message_rounded,
                    label: 'Chat',
                    color: Colors.orange,
                    isTablet: isTablet,
                  ),
                  _buildActionButton(
                    context: context,
                    icon: Icons.share_rounded,
                    label: 'Compartir',
                    color: Colors.purple,
                    isTablet: isTablet,
                  ),
                ],
              ),
            ),

            SizedBox(height: isTablet ? 24 : 20),

            // Descripcion
            Container(
              padding: EdgeInsets.all(isTablet ? 24 : 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: const Color(0xFF2E91D8),
                        size: isTablet ? 24 : 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sobre Nosotros',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 20 : 18,
                          color: const Color(0xFF2E91D8),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 16 : 12),
                  Text(
                    "Somos una empresa especializada en reparaciones y mantenimientos de alta calidad. Con años de experiencia en el sector, ofrecemos soluciones integrales para todas tus necesidades técnicas. Nuestro equipo de profesionales está comprometido con la excelencia y la satisfacción del cliente.",
                    style: TextStyle(
                      color: Colors.grey[700],
                      height: 1.6,
                      fontSize: isTablet ? 16 : 14,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required bool isTablet,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 14 : 12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: isTablet ? 28 : 24,
                ),
              ),
              SizedBox(height: isTablet ? 8 : 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: isTablet ? 12 : 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../model/administrador/admin_model.dart';
class AdminDetailScreen extends StatelessWidget {
  final UpdateAdminRequest admin;
  const AdminDetailScreen({super.key, required this.admin});
  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isTablet = sw > 600;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildAppBar(context, isTablet),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileSection(context, isTablet),
                  _buildInfoGrid(context, isTablet),
                  SizedBox(height: sh * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }  Widget _buildAppBar(BuildContext context, bool isTablet) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    return Container(
      height: sh * (isTablet ? 0.22 : 0.20),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 17, 28, 182), Color.fromARGB(255, 17, 28, 182)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -sw * 0.15,
            right: -sw * 0.15,
            child: Container(
              width: sw * 0.5,
              height: sw * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -sw * 0.1,
            left: -sw * 0.1,
            child: Container(
              width: sw * 0.4,
              height: sw * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.04, vertical: sh * 0.015),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: sw * (isTablet ? 0.04 : 0.06)),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.all(sw * 0.02),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: sw * (isTablet ? 0.06 : 0.09)),
                  SizedBox(height: sh * 0.01),
                  Text(
                    'Perfil de Administrador',
                    style: TextStyle(
                      fontSize: sw * (isTablet ? 0.045 : 0.065),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: sh * 0.005),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildProfileSection(BuildContext context, bool isTablet) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final avatarSize = sw * (isTablet ? 0.18 : 0.25);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sh * 0.03),
      child: Column(
        children: [
          Hero(
            tag: 'admin_${admin.id}',
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [Color.fromARGB(255, 20, 39, 212), Color.fromARGB(255, 17, 28, 182)]),
                boxShadow: [
                  BoxShadow(color: const Color.fromARGB(255, 20, 39, 212).withOpacity(0.4), blurRadius: 25, offset: const Offset(0, 12), spreadRadius: 2),
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8)),
                ],
                border: Border.all(color: Colors.white, width: 5),
              ),
              child: Center(
                child: Text(
                  '${admin.nombre[0]}${admin.apellido[0]}'.toUpperCase(),
                  style: TextStyle(fontSize: avatarSize * 0.35, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: sh * 0.025),
          Text(
            '${admin.nombre} ${admin.apellido}',
            style: TextStyle(fontSize: sw * (isTablet ? 0.04 : 0.055), fontWeight: FontWeight.bold, color: const Color(0xFF2D3436)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: sh * 0.015),
          Container(
            padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sh * 0.012),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [const Color(0xFF00D2A0).withOpacity(0.15), const Color(0xFF00B894).withOpacity(0.15)]),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0xFF00D2A0).withOpacity(0.3), width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, size: sw * (isTablet ? 0.025 : 0.035), color: const Color(0xFF00D2A0)),
                SizedBox(width: sw * 0.015),
                Text(
                  admin.rol.toUpperCase(),
                  style: TextStyle(fontSize: sw * (isTablet ? 0.025 : 0.035), fontWeight: FontWeight.w700, color: const Color(0xFF00B894), letterSpacing: 1.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildInfoGrid(BuildContext context, bool isTablet) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final spacing = sh * 0.015;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sw * 0.04),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildInfoCard(context, Icons.badge_outlined, 'Cédula', admin.numeroCedula, const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)]), isTablet)),
              SizedBox(width: spacing),
              Expanded(child: _buildInfoCard(context, Icons.email_outlined, 'Correo', admin.correoElectronico, const LinearGradient(colors: [Color(0xFF0984E3), Color(0xFF74B9FF)]), isTablet)),
            ],
          ),
          SizedBox(height: spacing),
          Row(
            children: [
              Expanded(child: _buildInfoCard(context, Icons.person_outline, 'Nombre', admin.nombre, const LinearGradient(colors: [Color(0xFFE17055), Color(0xFFFAB1A0)]), isTablet)),
              SizedBox(width: spacing),
              Expanded(child: _buildInfoCard(context, Icons.person_outline_rounded, 'Apellido', admin.apellido, const LinearGradient(colors: [Color(0xFFFD79A8), Color(0xFFFFCCCC)]), isTablet)),
            ],
          ),
          SizedBox(height: spacing),
          Row(
            children: [
              Expanded(child: _buildActionButton(context, 'Editar', Icons.edit_rounded, isTablet, false, () {})),
              SizedBox(width: spacing),
              Expanded(child: _buildActionButton(context, 'Eliminar', Icons.delete_rounded, isTablet, true, () => _showDeleteDialog(context))),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildInfoCard(BuildContext context, IconData icon, String title, String value, Gradient gradient, bool isTablet) {
    final sw = MediaQuery.of(context).size.width;
    final iconSize = sw * (isTablet ? 0.045 : 0.065);
    final padding = sw * (isTablet ? 0.035 : 0.03);
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: iconSize * 1.3,
            height: iconSize * 1.3,
            decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white, size: iconSize * 0.7),
          ),
          SizedBox(height: padding * 0.5),
          Text(title, style: TextStyle(fontSize: sw * (isTablet ? 0.02 : 0.028), color: const Color(0xFF95A5A6), fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: sw * (isTablet ? 0.025 : 0.035), color: const Color(0xFF2D3436), fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
  Widget _buildActionButton(BuildContext context, String label, IconData icon, bool isTablet, bool isOutlined, VoidCallback onTap) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final buttonHeight = sh * (isTablet ? 0.075 : 0.065);
    final iconSize = sw * (isTablet ? 0.035 : 0.055);
    final fontSize = sw * (isTablet ? 0.025 : 0.035);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: buttonHeight,
          decoration: BoxDecoration(
            gradient: isOutlined ? null : const LinearGradient(colors: [Color.fromARGB(255, 39, 77, 202), Color.fromARGB(255, 39, 77, 202)]),
            color: isOutlined ? Colors.white : null,
            border: isOutlined ? Border.all(color: const Color(0xFFE74C3C), width: 2) : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: isOutlined ? const Color(0xFFE74C3C).withOpacity(0.1) : const Color(0xFF00D2A0).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isOutlined ? const Color(0xFFE74C3C) : Colors.white, size: iconSize),
              SizedBox(height: sh * 0.005),
              Flexible(child: Text(label, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600, color: isOutlined ? const Color(0xFFE74C3C) : Colors.white), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      ),
    );
  }
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFE74C3C).withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.warning_rounded, color: Color(0xFFE74C3C)),
              ),
              const SizedBox(width: 12),
              const Expanded(child: Text('Confirmar eliminación', style: TextStyle(fontSize: 18))),
            ],
          ),
          content: Text('¿Estás seguro de que deseas eliminar a ${admin.nombre} ${admin.apellido}?', style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: Color(0xFF95A5A6)))),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE74C3C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'profile_constants.dart';

/// Encabezado con gradiente y logo para la pantalla de perfil
class ProfileHeader extends StatelessWidget implements PreferredSizeWidget {
  const ProfileHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ProfileTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: ProfileTheme.primaryBlue),
        onPressed: () => Navigator.pop(context),
        tooltip: 'Volver',
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Image.asset(
            'assets/logo.png',
            height: ProfileTheme.logoHeight,
          ),
        ),
      ],
    );
  }
}

/// Banner con gradiente y título
class ProfileBanner extends StatelessWidget {
  const ProfileBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ProfileTheme.headerHeight,
      decoration: const BoxDecoration(
        gradient: ProfileTheme.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(ProfileTheme.headerBorderRadius),
          bottomRight: Radius.circular(ProfileTheme.headerBorderRadius),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text('Perfil', style: ProfileTheme.titleStyle),
                  SizedBox(height: 4),
                  Text('Actualiza tu información', style: ProfileTheme.subtitleStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

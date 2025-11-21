import 'package:flutter/material.dart';
import 'profile_constants.dart';

/// Avatar circular con iniciales del usuario
class ProfileAvatar extends StatelessWidget {
  final String displayName;

  const ProfileAvatar({
    super.key,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    final initials = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'A';
    
    return Transform.translate(
      offset: const Offset(0, ProfileTheme.avatarOffset),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ProfileTheme.backgroundColor,
          boxShadow: ProfileTheme.avatarShadow(),
        ),
        padding: const EdgeInsets.all(ProfileTheme.avatarPadding),
        child: CircleAvatar(
          radius: ProfileTheme.avatarRadius,
          backgroundColor: ProfileTheme.primaryBlue,
          child: Text(
            initials,
            style: ProfileTheme.avatarTextStyle,
          ),
        ),
      ),
    );
  }
}

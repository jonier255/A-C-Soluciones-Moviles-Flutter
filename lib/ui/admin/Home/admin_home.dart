import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/administrador/request/request_bloc.dart';
import '../../../bloc/administrador/request/request_event.dart';
import '../../../repository/services_admin/request_repository.dart';
import 'widgets/admin_home_constants.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/main_buttons.dart';
import 'widgets/quick_access_buttons.dart';
import 'widgets/recent_requests.dart';
import 'widgets/wave_header.dart';

/// Pantalla principal del administrador - Dashboard moderno
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    
    return BlocProvider(
      create: (context) => RequestBloc(RequestRepository())..add(FetchRequests()),
      child: Scaffold(
        backgroundColor: AdminHomeTheme.backgroundColor,
        bottomNavigationBar: const AdminBottomNavBar(),
        body: SafeArea(
          child: Stack(
            children: [
              const WaveHeader(),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AdminHomeTheme.waveHeaderHeight(sh)),
                    SizedBox(height: AdminHomeTheme.sectionSpacing(sh)),
                    const MainButtonsSection(),
                    SizedBox(height: AdminHomeTheme.sectionSpacing(sh) * 1.3),
                    const QuickAccessSection(),
                    SizedBox(height: AdminHomeTheme.sectionSpacing(sh) * 0.8),
                    const RecentRequestsSection(),
                    SizedBox(height: AdminHomeTheme.sectionSpacing(sh)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
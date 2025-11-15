import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/request/request_bloc.dart';
import '../../../bloc/request/request_event.dart';
import '../../../repository/services_admin/request_repository.dart';
import 'widgets/wave_header.dart';
import 'widgets/main_buttons.dart';
import 'widgets/quick_access_buttons.dart';
import 'widgets/recent_requests.dart';
import 'widgets/bottom_nav_bar.dart';

/// Admin home screen - main dashboard
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestBloc(RequestRepository())..add(FetchRequests()),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: const AdminBottomNavBar(),
        body: SafeArea(
          child: Stack(
            children: [
              const WaveHeader(),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 160),
                    MainButtonsSection(),
                    SizedBox(height: 20),
                    QuickAccessSection(),
                    RecentRequestsSection(),
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
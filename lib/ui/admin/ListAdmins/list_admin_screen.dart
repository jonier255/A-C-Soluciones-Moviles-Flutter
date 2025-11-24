import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/listAdmins/admins_bloc.dart';
import '../../../../bloc/listAdmins/admins_event.dart';
import 'widgets/admin_list_bottom_nav.dart';
import 'widgets/admin_list_header.dart';
import 'widgets/widgets_seleccion_admin/admin_list_content.dart';

class AdminsScreen extends StatefulWidget {
  const AdminsScreen({super.key});

  @override
  AdminsScreenState createState() => AdminsScreenState();
}

class AdminsScreenState extends State<AdminsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminsBloc>().add(FetchAdmins());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      bottomNavigationBar: AdminListBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            AdminListHeader(),
            Expanded(child: AdminListContent()),
          ],
        ),
      ),
    );
  }
}

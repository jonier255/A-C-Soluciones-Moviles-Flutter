import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/listAdmins/admins_event.dart';
import '../../../../bloc/listAdmins/admins_bloc.dart';
import 'widgets/admin_list_header.dart';
import 'widgets/widgets_seleccion_admin/admin_list_content.dart';
import 'widgets/admin_list_bottom_nav.dart';

class AdminsScreen extends StatefulWidget {
  const AdminsScreen({super.key});

  @override
  _AdminsScreenState createState() => _AdminsScreenState();
}

class _AdminsScreenState extends State<AdminsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminsBloc>().add(FetchAdmins());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      bottomNavigationBar: const AdminListBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: const [
            AdminListHeader(),
            Expanded(child: AdminListContent()),
          ],
        ),
      ),
    );
  }
}

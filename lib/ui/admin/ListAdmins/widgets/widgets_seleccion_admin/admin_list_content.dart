import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/listAdmins/admins_bloc.dart';
import '../../../../../bloc/listAdmins/admins_state.dart';
import '../admin_card.dart';
import '../admin_pagination.dart';
import '../list_admin_constants.dart';

/// Área de contenido principal con la lista de administradores y paginación
class AdminListContent extends StatefulWidget {
  const AdminListContent({super.key});

  @override
  State<AdminListContent> createState() => _AdminListContentState();
}

class _AdminListContentState extends State<AdminListContent> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<AdminsBloc, AdminsState>(
              builder: (context, state) {
                if (state is AdminsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 18, 57, 230)),
                    ),
                  );
                } else if (state is AdminsSuccess) {
                  return _buildSuccessContent(state);
                } else if (state is AdminsError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Color(0xFFE74C3C)),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      "No hay administradores",
                      style: TextStyle(color: Color(0xFF636E72)),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent(AdminsSuccess state) {
    final totalPages = state.admins.isNotEmpty
        ? (state.admins.length / AdminListTheme.adminsPerPage).ceil()
        : 1;

    final safePage = _currentPage.clamp(1, totalPages);
    final startIndex = (safePage - 1) * AdminListTheme.adminsPerPage;
    final endIndex = (safePage * AdminListTheme.adminsPerPage)
        .clamp(0, state.admins.length);
    final currentAdmins = state.admins.isNotEmpty
        ? state.admins.sublist(startIndex, endIndex)
        : [];

    return Column(
      children: [
        Flexible(
          child: _buildAdminsContainer(currentAdmins),
        ),
        if (state.admins.isNotEmpty)
          AdminPaginationControls(
            currentPage: safePage,
            totalPages: totalPages,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
          ),
      ],
    );
  }

  Widget _buildAdminsContainer(List admins) {
    return admins.isNotEmpty
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: admins.length,
            itemBuilder: (context, index) {
              return AdminCard(admin: admins[index]);
            },
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline_rounded,
                  size: 80,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                const Text(
                  "No hay administradores registrados",
                  style: TextStyle(
                    color: Color(0xFF636E72),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
  }
}

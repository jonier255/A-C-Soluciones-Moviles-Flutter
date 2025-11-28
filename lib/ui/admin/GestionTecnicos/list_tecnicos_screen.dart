import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/ui/common_widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/tecnicos/tecnicos_bloc.dart';
import '../../../model/tecnico_model.dart';
import '../Home/widgets/bottom_nav_bar.dart';
import 'widgets/widgets_seleccion_tecnico/tecnico_menu_constants.dart';

///lista de técnicos registrados
class ListTecnicosScreen extends StatefulWidget {
  const ListTecnicosScreen({super.key});

  @override
  State<ListTecnicosScreen> createState() => _ListTecnicosScreenState();
}

class _ListTecnicosScreenState extends State<ListTecnicosScreen> {
  int _currentPage = 1;
  static const int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    context.read<TecnicosBloc>().add(LoadTecnicos());
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: TecnicoMenuTheme.backgroundColor,
      bottomNavigationBar: const AdminBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, sw, sh),
            Expanded(
              child: BlocBuilder<TecnicosBloc, TecnicosState>(
                builder: (context, state) {
                  if (state is TecnicosLoading) {
                    return const LoadingIndicator(
                      message: 'Cargando técnicos...',
                      color: TecnicoMenuTheme.primaryGradientStart,
                    );
                  } else if (state is TecnicosLoaded) {
                    if (state.tecnicos.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildTecnicosList(state.tecnicos, sw, sh);
                  } else if (state is TecnicosError) {
                    return ErrorState(
                      error: state.message,
                      onRetry: () {
                        context.read<TecnicosBloc>().add(LoadTecnicos());
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double sw, double sh) {
    return Container(
      height: sh * 0.15,
      decoration: BoxDecoration(
        gradient: TecnicoMenuTheme.primaryGradient,
        boxShadow: TecnicoMenuTheme.headerShadow(),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: TecnicoMenuTheme.horizontalPadding(sw),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              iconSize: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lista de Técnicos',
                    style: TextStyle(
                      fontSize: TecnicoMenuTheme.headerTitleSize(sw),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Personal técnico registrado',
                    style: TextStyle(
                      fontSize: TecnicoMenuTheme.headerSubtitleSize(sw),
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                context.read<TecnicosBloc>().add(LoadTecnicos());
              },
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              iconSize: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const EmptyState(
      icon: Icons.engineering_outlined,
      title: 'No hay técnicos registrados',
      message: 'Agrega tu primer técnico para empezar',
      iconColor: TecnicoMenuTheme.textSecondary,
    );
  }

  Widget _buildTecnicosList(List<Tecnico> tecnicos, double sw, double sh) {
    final totalPages = (tecnicos.length / _itemsPerPage).ceil();
    final safePage = _currentPage.clamp(1, totalPages);
    final startIndex = (safePage - 1) * _itemsPerPage;
    final endIndex = (safePage * _itemsPerPage).clamp(0, tecnicos.length);
    final currentTecnicos = tecnicos.sublist(startIndex, endIndex);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(TecnicoMenuTheme.horizontalPadding(sw)),
            itemCount: currentTecnicos.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: sh * 0.015),
                child: _buildTecnicoCard(currentTecnicos[index], sw),
              );
            },
          ),
        ),
        if (tecnicos.isNotEmpty)
          PaginationControls(
            currentPage: safePage,
            totalPages: totalPages,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            primaryColor: TecnicoMenuTheme.primaryGradientStart,
            selectedColor: TecnicoMenuTheme.primaryGradientStart,
          ),
      ],
    );
  }

  Widget _buildTecnicoCard(Tecnico tecnico, double sw) {
    return CustomCard(
      onTap: () {
        // Navegar a detalle del técnico
      },
      child: Row(
        children: [
          _buildTecnicoAvatar(tecnico),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTecnicoInfo(tecnico, sw),
          ),
        ],
      ),
    );
  }

  Widget _buildTecnicoAvatar(Tecnico tecnico) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: TecnicoMenuTheme.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.engineering_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildTecnicoInfo(Tecnico tecnico, double sw) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${tecnico.nombre} ${tecnico.apellido}',
          style: TextStyle(
            fontSize: TecnicoMenuTheme.cardTitleSize(sw),
            fontWeight: FontWeight.bold,
            color: TecnicoMenuTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.work_outline_rounded,
              size: TecnicoMenuTheme.cardSubtitleSize(sw),
              color: TecnicoMenuTheme.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              tecnico.cargo,
              style: TextStyle(
                fontSize: TecnicoMenuTheme.cardSubtitleSize(sw),
                color: TecnicoMenuTheme.textSecondary,
              ),
            ),
          ],
        ),
        if (tecnico.telefono.isNotEmpty) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(
                Icons.phone_rounded,
                size: TecnicoMenuTheme.cardSubtitleSize(sw),
                color: TecnicoMenuTheme.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                tecnico.telefono,
                style: TextStyle(
                  fontSize: TecnicoMenuTheme.cardSubtitleSize(sw) * 0.95,
                  color: TecnicoMenuTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

}

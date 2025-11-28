import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/ui/common_widgets/widgets.dart';
import 'widgets/service_menu_constants.dart';



class CreateServiceScreen extends StatefulWidget {  
  const CreateServiceScreen({super.key});

  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nombreController = TextEditingController();        
  final _descripcionController = TextEditingController();   
  
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;   
    final sh = MediaQuery.of(context).size.height;  
    
    return Scaffold(
      backgroundColor: ServiceMenuTheme.backgroundColor,  
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, sw, sh),
            
            Expanded(
              child: SingleChildScrollView(  
                physics: const BouncingScrollPhysics(),  
                child: Padding(
                  padding: EdgeInsets.all(ServiceMenuTheme.screenHorizontalPadding(sw)),
                  child: Form(  
                    key: _formKey,  
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,  
                      children: [
                        SizedBox(height: sh * 0.03),
                        _buildSectionTitle('Información del Servicio', sw),
                        SizedBox(height: sh * 0.02),
                        _buildNombreField(sw),        // Campo nombre
                        SizedBox(height: sh * 0.02),
                        _buildDescripcionField(sw),   // Campo descripción
                        SizedBox(height: sh * 0.04),
                        _buildSubmitButton(context, sw),  // Botón de guardar
                        SizedBox(height: sh * 0.02),
                      ],
                    ),
                  ),
                ),
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
      decoration: const BoxDecoration(
        gradient: ServiceMenuTheme.createServiceGradient,  
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ServiceMenuTheme.screenHorizontalPadding(sw),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),  // Regresa a la pantalla anterior
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              iconSize: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título principal
                  Text(
                    'Crear Nuevo Servicio',
                    style: TextStyle(
                      fontSize: ServiceMenuTheme.headerTitleSize(sw),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Subtítulo
                  Text(
                    'Registra un nuevo servicio en el sistema',
                    style: TextStyle(
                      fontSize: ServiceMenuTheme.headerSubtitleSize(sw),
                      color: Colors.white.withAlpha(230),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Título de sección
  Widget _buildSectionTitle(String title, double sw) {
    return Text(
      title,
      style: TextStyle(
        fontSize: ServiceMenuTheme.cardTitleSize(sw),
        fontWeight: FontWeight.bold,
        color: ServiceMenuTheme.textPrimary,
      ),
    );
  }

  
  Widget _buildNombreField(double sw) {
    return CustomTextField(
      controller: _nombreController,
      label: 'Nombre del Servicio',
      hintText: 'Ej: Instalación eléctrica',
      icon: Icons.label_rounded,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor ingrese el nombre del servicio';
        }
        if (value.trim().length < 3) {
          return 'El nombre debe tener al menos 3 caracteres';
        }
        return null;
      },
    );
  }

  
  Widget _buildDescripcionField(double sw) {
    return CustomTextField(
      controller: _descripcionController,
      label: 'Descripción',
      hintText: 'Describe los detalles del servicio...',
      icon: Icons.description_rounded,
      maxLines: 5,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor ingrese la descripción del servicio';
        }
        if (value.trim().length < 10) {
          return 'La descripción debe tener al menos 10 caracteres';
        }
        return null;
      },
    );
  }

  
  Widget _buildSubmitButton(BuildContext context, double sw) {
    return CustomGradientButton(
      label: 'Crear Servicio',
      icon: Icons.check_circle_rounded,
      onPressed: () => _handleSubmit(context),
      gradient: ServiceMenuTheme.createServiceGradient,
      isLoading: _isLoading,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

 
  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return; 
    }

    setState(() => _isLoading = true);

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      
      messenger.showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: ServiceMenuTheme.statusCompleted),  // Icono verde
            SizedBox(width: 12),
            Text('Servicio creado exitosamente'),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,  // Flota sobre la pantalla
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      );

      navigator.pop();
    } catch (e) {
      if (!mounted) return;
      
      messenger.showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_rounded, color: ServiceMenuTheme.statusError),  // Icono rojo
              SizedBox(width: 12),
              Text('Error al crear el servicio'),
            ],
          ),
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

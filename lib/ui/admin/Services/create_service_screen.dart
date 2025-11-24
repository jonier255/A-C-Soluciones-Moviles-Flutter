import 'package:flutter/material.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),  
        boxShadow: [
          BoxShadow(
            color: ServiceMenuTheme.primaryPurple.withAlpha(20),  
            blurRadius: 12,
            offset: const Offset(0, 4),  
          ),
        ],
      ),
      child: TextFormField(
        controller: _nombreController,
        decoration: InputDecoration(
          labelText: 'Nombre del Servicio',
          hintText: 'Ej: Instalación eléctrica',
          prefixIcon: const Icon(
            Icons.label_rounded,
            color: ServiceMenuTheme.primaryPurple,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: TextStyle(
          fontSize: ServiceMenuTheme.cardSubtitleSize(sw),
          color: ServiceMenuTheme.textPrimary,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Por favor ingrese el nombre del servicio';
          }
          if (value.trim().length < 3) {
            return 'El nombre debe tener al menos 3 caracteres';
          }
          return null;
        },
      ),
    );
  }

  
  Widget _buildDescripcionField(double sw) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ServiceMenuTheme.primaryPurple.withAlpha(20),  
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: _descripcionController,  
        maxLines: 5,  
        decoration: InputDecoration(
          labelText: 'Descripción',
          hintText: 'Describe los detalles del servicio...',
          prefixIcon: const Padding(
            padding: EdgeInsets.only(bottom: 60),  
            child: Icon(
              Icons.description_rounded,
              color: ServiceMenuTheme.primaryPurple,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: TextStyle(
          fontSize: ServiceMenuTheme.cardSubtitleSize(sw),
          color: ServiceMenuTheme.textPrimary,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Por favor ingrese la descripción del servicio';
          }
          // Si tiene menos de 10 caracteres
          if (value.trim().length < 10) {
            return 'La descripción debe tener al menos 10 caracteres';
          }
          return null;  
        },
      ),
    );
  }

  
  Widget _buildSubmitButton(BuildContext context, double sw) {
    return SizedBox(
      width: double.infinity,  
      height: 56,               
      child: Material(
        color: Colors.transparent,
        child: InkWell(  
          onTap: _isLoading ? null : () => _handleSubmit(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: ServiceMenuTheme.createServiceGradient,  
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: ServiceMenuTheme.createServiceGradient.colors.first.withAlpha(77),
                  blurRadius: 12,
                  offset: const Offset(0, 6),  
                ),
              ],
            ),
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2.5,  
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Crear Servicio',
                          style: TextStyle(
                            fontSize: ServiceMenuTheme.cardTitleSize(sw) * 0.9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

 
  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return; 
    }

    setState(() => _isLoading = true);

    try {
     
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
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

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
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

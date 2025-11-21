import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'assign_visits_widgets.dart';

/// Campo de selección de fecha y hora
class DateTimeField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const DateTimeField({
    super.key,
    required this.controller,
    required this.label,
    this.icon = Icons.calendar_month,
  });

  @override
  Widget build(BuildContext context) {
    return FieldContainer(
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: buildInputDecoration(context, label, icon: icon),
        onTap: () => _selectDateTime(context),
        validator: (value) =>
            value == null || value.isEmpty ? 'Por favor ingrese la fecha' : null,
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    FocusScope.of(context).unfocus();
    
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      
      if (time != null) {
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        controller.text = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
      }
    }
  }
}

/// Campo numérico genérico
class NumericField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? errorMessage;

  const NumericField({
    super.key,
    required this.controller,
    required this.label,
    this.icon = Icons.numbers,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return FieldContainer(
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: buildInputDecoration(context, label, icon: icon),
        validator: (value) => value == null || value.isEmpty
            ? (errorMessage ?? 'Por favor ingrese $label')
            : null,
      ),
    );
  }
}

/// Campo de notas con múltiples líneas
class NotesField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final bool required;

  const NotesField({
    super.key,
    required this.controller,
    required this.label,
    this.icon = Icons.notes,
    this.maxLines = 2,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return FieldContainer(
      child: TextFormField(
        controller: controller,
        decoration: buildInputDecoration(context, label, icon: icon),
        maxLines: maxLines,
        validator: required
            ? (value) => value == null || value.isEmpty
                ? 'Por favor ingrese $label'
                : null
            : null,
      ),
    );
  }
}

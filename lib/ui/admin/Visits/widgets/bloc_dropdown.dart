import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'assign_visits_constants.dart';
import 'assign_visits_widgets.dart';

/// Dropdown genérico que funciona con cualquier BLoC
class BlocDropdownField<B extends StateStreamable<S>, S, T> extends StatelessWidget {
  final T? value;
  final String label;
  final IconData icon;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool Function(S) isLoading;
  final bool Function(S) isLoaded;
  final bool Function(S) isError;
  final List<T> Function(S) getItems;
  final int Function(T) getId;
  final String Function(T) getDisplayText;
  final String? Function(S)? getErrorMessage;

  const BlocDropdownField({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.onChanged,
    required this.validator,
    required this.isLoading,
    required this.isLoaded,
    required this.isError,
    required this.getItems,
    required this.getId,
    required this.getDisplayText,
    this.getErrorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      builder: (context, state) {
        if (isLoading(state)) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (isLoaded(state)) {
          final items = getItems(state);
          return FieldContainer(
            child: DropdownButtonFormField<int>(
              isExpanded: true,
              initialValue: value != null ? getId(value as T) : null,
              decoration: buildInputDecoration(context, label, icon: icon),
              icon: const Icon(Icons.arrow_drop_down, color: AssignVisitsTheme.accentBlue),
              items: items.map((item) {
                return DropdownMenuItem<int>(
                  value: getId(item),
                  child: Text(
                    getDisplayText(item),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null && items.isNotEmpty) {
                  final selectedItem = items.firstWhere(
                    (item) => getId(item) == newValue,
                  );
                  onChanged?.call(selectedItem);
                }
              },
              validator: (value) => validator?.call(value as T?),
            ),
          );
        }
        
        if (isError(state)) {
          final errorMsg = getErrorMessage?.call(state) ?? 'Error al cargar datos';
          return Text('Error: $errorMsg', style: const TextStyle(color: Colors.red));
        }
        
        return Container();
      },
    );
  }
}

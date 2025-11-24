import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/editProfileTechnical/edit_profile_technical_bloc.dart';
import 'package:flutter_a_c_soluciones/model/technical/technical_model.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Profile/updateProfileTechnical.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockEditProfileTechnicalBloc extends MockBloc<EditProfileTechnicalEvent, EditProfileTechnicalState>
    implements EditProfileTechnicalBloc {}

void main() {
  group('EditarInformacionScreenTechnical', () {
    late MockEditProfileTechnicalBloc mockEditProfileTechnicalBloc;

    setUp(() {
      mockEditProfileTechnicalBloc = MockEditProfileTechnicalBloc();
    });

    tearDown(() {
      mockEditProfileTechnicalBloc.close();
    });

    final tTechnical = const UpdateTechnicalRequest(
      id: 1,
      nombre: 'John',
      apellido: 'Doe',
      numeroCedula: '123456789',
      correoElectronico: 'john.doe@example.com',
      rol: 'tecnico',
      telefono: '1234567890',
      especialidad: 'Flutter',
    );

    Future<void> pumpEditarInformacionScreenTechnical(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<EditProfileTechnicalBloc>.value(
            value: mockEditProfileTechnicalBloc,
            child: const EditarInformacionScreenTechnical(),
          ),
        ),
      );
    }

    testWidgets('shows loading indicator when state is initial', (WidgetTester tester) async {
      whenListen(
        mockEditProfileTechnicalBloc,
        Stream.fromIterable([EditProfileTechnicalInitial()]),
        initialState: EditProfileTechnicalInitial(),
      );

      await pumpEditarInformacionScreenTechnical(tester);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('populates form fields when state is EditProfileTechnicalLoaded', (WidgetTester tester) async {
      whenListen(
        mockEditProfileTechnicalBloc,
        Stream.fromIterable([EditProfileTechnicalLoaded(tTechnical)]),
        initialState: EditProfileTechnicalLoaded(tTechnical),
      );

      await pumpEditarInformacionScreenTechnical(tester);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'John'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Doe'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'john.doe@example.com'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '1234567890'), findsOneWidget);
    });

    testWidgets('shows success message when state is EditProfileTechnicalSuccess', (WidgetTester tester) async {
      whenListen(
        mockEditProfileTechnicalBloc,
        Stream.fromIterable([EditProfileTechnicalLoaded(tTechnical), EditProfileTechnicalSuccess()]),
        initialState: EditProfileTechnicalLoaded(tTechnical),
      );

      await pumpEditarInformacionScreenTechnical(tester);
      await tester.pumpAndSettle();
      
      mockEditProfileTechnicalBloc.emit(EditProfileTechnicalSuccess());
      await tester.pump();

    });

    testWidgets('shows error message when state is EditProfileTechnicalFailure', (WidgetTester tester) async {
      whenListen(
        mockEditProfileTechnicalBloc,
        Stream.fromIterable([EditProfileTechnicalLoaded(tTechnical), const EditProfileTechnicalFailure('Test Error')]),
        initialState: EditProfileTechnicalLoaded(tTechnical),
      );

      await pumpEditarInformacionScreenTechnical(tester);
      await tester.pumpAndSettle();
      
      mockEditProfileTechnicalBloc.emit(const EditProfileTechnicalFailure('Test Error'));
      await tester.pump();

    });
  });
}

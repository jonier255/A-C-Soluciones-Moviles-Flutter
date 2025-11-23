import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_a_c_soluciones/bloc/editProfileTechnical/edit_profile_technical_bloc.dart';
import 'package:flutter_a_c_soluciones/model/technical/technical_model.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Profile/accountTechnical.dart';

class MockEditProfileTechnicalBloc extends MockBloc<EditProfileTechnicalEvent, EditProfileTechnicalState>
    implements EditProfileTechnicalBloc {}

void main() {
  group('AccountTechnicalScreen', () {
    late MockEditProfileTechnicalBloc mockEditProfileTechnicalBloc;

    setUp(() {
      mockEditProfileTechnicalBloc = MockEditProfileTechnicalBloc();
    });

    tearDown(() {
      mockEditProfileTechnicalBloc.close();
    });

    final tTechnical = UpdateTechnicalRequest(
      id: 1,
      nombre: 'John',
      apellido: 'Doe',
      numeroCedula: '123456789',
      correoElectronico: 'john.doe@example.com',
      rol: 'tecnico',
      telefono: '1234567890',
      especialidad: 'Flutter',
    );

    Future<void> pumpAccountTechnicalScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<EditProfileTechnicalBloc>.value(
            value: mockEditProfileTechnicalBloc,
            child: AccountTechnicalScreen(),
          ),
        ),
      );
    }

    testWidgets('shows CircularProgressIndicator when state is EditProfileTechnicalLoading', (WidgetTester tester) async {
      whenListen(
        mockEditProfileTechnicalBloc,
        Stream.fromIterable([EditProfileTechnicalLoading()]),
        initialState: EditProfileTechnicalLoading(),
      );

      await pumpAccountTechnicalScreen(tester);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows user profile when state is EditProfileTechnicalLoaded', (WidgetTester tester) async {
      whenListen(
        mockEditProfileTechnicalBloc,
        Stream.fromIterable([EditProfileTechnicalLoaded(tTechnical)]),
        initialState: EditProfileTechnicalLoaded(tTechnical),
      );

      await pumpAccountTechnicalScreen(tester);
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('123456789'), findsOneWidget);
      expect(find.text('1234567890'), findsOneWidget);
      expect(find.text('Flutter'), findsOneWidget);
      expect(find.text('john.doe@example.com'), findsOneWidget);
    });

    testWidgets('shows error message when state is EditProfileTechnicalFailure', (WidgetTester tester) async {
      whenListen(
        mockEditProfileTechnicalBloc,
        Stream.fromIterable([EditProfileTechnicalFailure('Test Error')]),
        initialState: EditProfileTechnicalFailure('Test Error'),
      );

      await pumpAccountTechnicalScreen(tester);
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      expect(find.text('Error: Test Error'), findsOneWidget);
    });
  });
}
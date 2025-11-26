import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/client/edit_profile_client_bloc.dart';
import 'package:flutter_a_c_soluciones/model/client/client_profile_model.dart';
import 'package:flutter_a_c_soluciones/repository/client/client_profile_repository.dart';
import 'package:flutter_a_c_soluciones/ui/client/profile/edit_profile_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock para ClientProfileRepository
class MockClientProfileRepository implements ClientProfileRepository {
  @override
  Future<ClientProfileModel> getClientProfile() async {
    return ClientProfileModel(
      id: 1,
      numeroDeCedula: '1234567890',
      nombre: 'Juan',
      apellido: 'Pérez',
      correoElectronico: 'juan@test.com',
      telefono: '1234567890',
      direccion: 'Calle Test 123',
      rol: 'cliente',
      estado: 'activo',
    );
  }

  @override
  Future<void> updateClientProfile(ClientProfileModel data) async {
    return;
  }
}

// Mock para EditProfileClientBloc
class MockEditProfileClientBloc extends MockBloc<EditProfileClientEvent, EditProfileClientState>
    implements EditProfileClientBloc {}

void main() {
  group('EditProfileClientScreen', () {
    late MockEditProfileClientBloc mockBloc;

    setUp(() {
      mockBloc = MockEditProfileClientBloc();
    });

    tearDown(() {
      mockBloc.close();
    });

    Future<void> pumpEditProfileScreen(WidgetTester tester, {Size? screenSize}) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: screenSize ?? const Size(1200, 2000)),
            child: BlocProvider<EditProfileClientBloc>.value(
              value: mockBloc,
              child: const EditProfileClientScreen(),
            ),
          ),
        ),
      );
    }

    testWidgets('Muestra el título "Editar Perfil"', (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([EditProfileClientInitial()]),
        initialState: EditProfileClientInitial(),
      );

      await pumpEditProfileScreen(tester);
      await tester.pumpAndSettle();

      expect(find.text('Editar Perfil'), findsOneWidget);
    });

    testWidgets('Muestra CircularProgressIndicator cuando el estado es EditProfileClientLoading', (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([EditProfileClientLoading()]),
        initialState: EditProfileClientLoading(),
      );

      await pumpEditProfileScreen(tester);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Muestra el formulario cuando el estado es EditProfileClientLoaded', (WidgetTester tester) async {
      final client = ClientProfileModel(
        id: 1,
        numeroDeCedula: '1234567890',
        nombre: 'Juan',
        apellido: 'Pérez',
        correoElectronico: 'juan@test.com',
        telefono: '1234567890',
        direccion: 'Calle Test 123',
        rol: 'cliente',
        estado: 'activo',
      );

      whenListen(
        mockBloc,
        Stream.fromIterable([EditProfileClientLoaded(client)]),
        initialState: EditProfileClientLoaded(client),
      );

      await pumpEditProfileScreen(tester);
      await tester.pumpAndSettle();

      // Verificar que se muestran los campos del formulario
      expect(find.text('Información Personal'), findsOneWidget);
      expect(find.text('Número de Cédula'), findsOneWidget);
      expect(find.text('Nombre'), findsOneWidget);
      expect(find.text('Apellido'), findsOneWidget);
      expect(find.text('Correo Electrónico'), findsOneWidget);
      expect(find.text('Teléfono'), findsOneWidget);
      expect(find.text('Dirección'), findsOneWidget);
    });

    testWidgets('Muestra los botones Cancelar y Guardar Cambios', (WidgetTester tester) async {
      final client = ClientProfileModel(
        id: 1,
        numeroDeCedula: '1234567890',
        nombre: 'Juan',
        apellido: 'Pérez',
        correoElectronico: 'juan@test.com',
        telefono: '1234567890',
        direccion: 'Calle Test 123',
        rol: 'cliente',
        estado: 'activo',
      );

      whenListen(
        mockBloc,
        Stream.fromIterable([EditProfileClientLoaded(client)]),
        initialState: EditProfileClientLoaded(client),
      );

      await pumpEditProfileScreen(tester);
      await tester.pumpAndSettle();

      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Guardar Cambios'), findsOneWidget);
    });

    testWidgets('Muestra el checkbox para cambiar contraseña', (WidgetTester tester) async {
      final client = ClientProfileModel(
        id: 1,
        numeroDeCedula: '1234567890',
        nombre: 'Juan',
        apellido: 'Pérez',
        correoElectronico: 'juan@test.com',
        telefono: '1234567890',
        direccion: 'Calle Test 123',
        rol: 'cliente',
        estado: 'activo',
      );

      whenListen(
        mockBloc,
        Stream.fromIterable([EditProfileClientLoaded(client)]),
        initialState: EditProfileClientLoaded(client),
      );

      await pumpEditProfileScreen(tester);
      await tester.pumpAndSettle();

      expect(find.text('Cambiar contraseña'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('Muestra el checkbox para cambiar contraseña', (WidgetTester tester) async {
      final client = ClientProfileModel(
        id: 1,
        numeroDeCedula: '1234567890',
        nombre: 'Juan',
        apellido: 'Pérez',
        correoElectronico: 'juan@test.com',
        telefono: '1234567890',
        direccion: 'Calle Test 123',
        rol: 'cliente',
        estado: 'activo',
      );

      whenListen(
        mockBloc,
        Stream.fromIterable([EditProfileClientLoaded(client)]),
        initialState: EditProfileClientLoaded(client),
      );

      await pumpEditProfileScreen(tester, screenSize: const Size(1200, 2000));
      await tester.pumpAndSettle();

      // Verificar que el checkbox existe
      expect(find.text('Cambiar contraseña'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('Muestra el botón Cancelar', (WidgetTester tester) async {
      final client = ClientProfileModel(
        id: 1,
        numeroDeCedula: '1234567890',
        nombre: 'Juan',
        apellido: 'Pérez',
        correoElectronico: 'juan@test.com',
        telefono: '1234567890',
        direccion: 'Calle Test 123',
        rol: 'cliente',
        estado: 'activo',
      );

      whenListen(
        mockBloc,
        Stream.fromIterable([EditProfileClientLoaded(client)]),
        initialState: EditProfileClientLoaded(client),
      );

      await pumpEditProfileScreen(tester, screenSize: const Size(1200, 2000));
      await tester.pumpAndSettle();

      // Verificar que el botón Cancelar existe
      expect(find.text('Cancelar'), findsOneWidget);
    });
  });
}


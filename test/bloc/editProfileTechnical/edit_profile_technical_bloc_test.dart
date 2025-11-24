import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_a_c_soluciones/bloc/editProfileTechnical/edit_profile_technical_bloc.dart';
import 'package:flutter_a_c_soluciones/model/technical/technical_model.dart';
import 'package:flutter_a_c_soluciones/repository/services_technical/service_TechnicalUpdateProfile.dart';
import 'package:flutter_test/flutter_test.dart';

// Manual mock for success case
class MockTechnicalUpdateProfileRepositorySuccess implements TechnicalUpdateProfileRepository {
  UpdateTechnicalRequest _technicalProfile = const UpdateTechnicalRequest(
    id: 1,
    nombre: 'John',
    apellido: 'Doe',
    numeroCedula: '123456789',
    correoElectronico: 'john.doe@example.com',
    rol: 'Technical',
    telefono: '987654321',
    especialidad: 'Software',
  );

  @override
  Future<UpdateTechnicalRequest> getTechnicalProfile() async {
    return _technicalProfile;
  }

  @override
  Future<void> updateTechnicalProfile(UpdateTechnicalRequest data) async {
    _technicalProfile = data; // Simulate update
    return Future.value();
  }
}

// Manual mock for failure case
class MockTechnicalUpdateProfileRepositoryFailure implements TechnicalUpdateProfileRepository {
  @override
  Future<UpdateTechnicalRequest> getTechnicalProfile() async {
    throw Exception('Failed to load technical profile');
  }

  @override
  Future<void> updateTechnicalProfile(UpdateTechnicalRequest data) async {
    throw Exception('Failed to update technical profile');
  }
}

void main() {
  group('EditProfileTechnicalBloc', () {
    late EditProfileTechnicalBloc editProfileTechnicalBloc;

    test('initial state is EditProfileTechnicalInitial', () {
      editProfileTechnicalBloc = EditProfileTechnicalBloc(
        technicalUpdateProfileRepository: MockTechnicalUpdateProfileRepositorySuccess(),
      );
      expect(editProfileTechnicalBloc.state, EditProfileTechnicalInitial());
    });

    blocTest<EditProfileTechnicalBloc, EditProfileTechnicalState>(
      'emits [EditProfileTechnicalLoading, EditProfileTechnicalLoaded] when LoadTechnicalProfile is added and successful.',
      build: () => EditProfileTechnicalBloc(
        technicalUpdateProfileRepository: MockTechnicalUpdateProfileRepositorySuccess(),
      ),
      act: (bloc) => bloc.add(LoadTechnicalProfile()),
      expect: () => [
        EditProfileTechnicalLoading(),
        const EditProfileTechnicalLoaded(
          UpdateTechnicalRequest(
            id: 1,
            nombre: 'John',
            apellido: 'Doe',
            numeroCedula: '123456789',
            correoElectronico: 'john.doe@example.com',
            rol: 'Technical',
            telefono: '987654321',
            especialidad: 'Software',
          ),
        ),
      ],
    );

    blocTest<EditProfileTechnicalBloc, EditProfileTechnicalState>(
      'emits [EditProfileTechnicalLoading, EditProfileTechnicalFailure] when LoadTechnicalProfile is added and fails.',
      build: () => EditProfileTechnicalBloc(
        technicalUpdateProfileRepository: MockTechnicalUpdateProfileRepositoryFailure(),
      ),
      act: (bloc) => bloc.add(LoadTechnicalProfile()),
      expect: () => [
        EditProfileTechnicalLoading(),
        const EditProfileTechnicalFailure('Exception: Failed to load technical profile'),
      ],
    );

    blocTest<EditProfileTechnicalBloc, EditProfileTechnicalState>(
      'emits [EditProfileTechnicalLoading, EditProfileTechnicalSuccess] when UpdateTechnicalProfile is added and successful.',
      build: () => EditProfileTechnicalBloc(
        technicalUpdateProfileRepository: MockTechnicalUpdateProfileRepositorySuccess(),
      ),
      act: (bloc) => bloc.add(
        const UpdateTechnicalProfile(
          technicalData: UpdateTechnicalRequest(
            id: 1,
            nombre: 'Jane', // Changed name
            apellido: 'Doe',
            numeroCedula: '123456789',
            correoElectronico: 'john.doe@example.com',
            rol: 'Technical',
            telefono: '987654321',
            especialidad: 'Software',
          ),
        ),
      ),
      expect: () => [
        EditProfileTechnicalLoading(),
        EditProfileTechnicalSuccess(),
      ],
    );

    blocTest<EditProfileTechnicalBloc, EditProfileTechnicalState>(
      'emits [EditProfileTechnicalLoading, EditProfileTechnicalFailure] when UpdateTechnicalProfile is added and fails.',
      build: () => EditProfileTechnicalBloc(
        technicalUpdateProfileRepository: MockTechnicalUpdateProfileRepositoryFailure(),
      ),
      act: (bloc) => bloc.add(
        const UpdateTechnicalProfile(
          technicalData: UpdateTechnicalRequest(
            id: 1,
            nombre: 'Jane',
            apellido: 'Doe',
            numeroCedula: '123456789',
            correoElectronico: 'john.doe@example.com',
            rol: 'Technical',
            telefono: '987654321',
            especialidad: 'Software',
          ),
        ),
      ),
      expect: () => [
        EditProfileTechnicalLoading(),
        const EditProfileTechnicalFailure('Exception: Failed to update technical profile'),
      ],
    );
  });
}

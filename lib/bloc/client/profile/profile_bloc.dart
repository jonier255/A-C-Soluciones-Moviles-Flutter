
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones_moviles_flutter/bloc/client/profile/profile_event.dart';
import 'package:flutter_a_c_soluciones_moviles_flutter/bloc/client/profile/profile_state.dart';
import 'package:flutter_a_c_soluciones_moviles_flutter/model/client/client_model.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoading()) {
    on<FetchProfileData>((event, emit) async {
      emit(ProfileLoading());
      await Future.delayed(const Duration(seconds: 2));
      try {
        // Replace this with your actual data fetching logic
        final user = Client(
          id: 1,
          rol: 'client',
          name: 'John Doe',
          email: 'john.doe@example.com',
        );
        emit(ProfileLoaded(user));
      } catch (e) {
        emit(ProfileError('Failed to fetch profile data: ${e.toString()}'));
      }
    });
  }
}

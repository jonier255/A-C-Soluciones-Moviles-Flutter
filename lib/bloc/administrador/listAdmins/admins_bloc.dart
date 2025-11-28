import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/services_admin/service_list_admin.dart';
import 'admins_event.dart';
import 'admins_state.dart';

class AdminsBloc extends Bloc<AdminsEvent, AdminsState> {
  final AdminRepository repository;

  AdminsBloc(this.repository) : super(AdminsInitial()) {
    on<FetchAdmins>((event, emit) async {
      emit(AdminsLoading());
      try {
        final admins = await repository.getAdmins();
        emit(AdminsSuccess(admins));
      } catch (e) {
        emit(AdminsError(e.toString()));
      }
    });
  }
}
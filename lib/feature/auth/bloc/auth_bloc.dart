import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/feature/auth/data/register_confirmation_method.dart';
import 'package:just_do_it/models/task/task_category.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitState()) {
    on<SendProfileEvent>(_sendProfile);
    on<ConfirmCodeEvent>(_confirmCode);
    on<RestoreCodeEvent>(_restoreProfile);
    on<RestoreCodeCheckEvent>(_restoreCodeConfirm);
    on<GetCategoriesEvent>(_getCategories);
    on<SignInEvent>(_signIn);
    on<CheckUserExistEvent>(_checkUser);
    on<ConfirmCodeResetEvent>(_confirmCodeReset);
    on<EditPasswordEvent>(_editPassword);
  }

  List<TaskCategory> categories = [];

  int? refCode;

  void setRef(int? value) => refCode = value;

  void _sendProfile(SendProfileEvent event, Emitter<AuthState> emit) async {
    String? otp;
    if (event.registerConfirmationMethod == RegisterConfirmationMethod.phone ||
        event.registerConfirmationMethod ==
            RegisterConfirmationMethod.whatsapp) {
      otp = await Repository().sendCodeForConfirmation(
        confirmMethod: 'phone',
        value: event.userRegModel.phoneNumber!,
      );
    } else if (event.registerConfirmationMethod ==
        RegisterConfirmationMethod.email) {
      otp = await Repository().sendCodeForConfirmation(
        confirmMethod: 'email',
        value: event.userRegModel.email!,
      );
    }

    if (otp != null) {
      event.sendCodeServer = otp;

      emit(SendProfileSuccessState(event));
    } else {
      emit(SendProfileErrorState({}));
    }
  }
  // void _sendProfile(SendProfileEvent event, Emitter<AuthState> emit) async {
  //   if (event.registerConfirmationMethod == RegisterConfirmationMethod.phone) {
  //     final otp = await Repository().sendCodeForConfirmation(
  //       confirmMethod: 'phone',
  //       value: event.userRegModel.phoneNumber!,
  //     );

  //     if (otp != null) {
  //       event.sendCodeServer = otp;

  //       emit(SendProfileSuccessState(event));
  //     } else {
  //       emit(SendProfileErrorState({}));
  //     }
  //   } else {
  //     Map<String, dynamic>? res = await Repository().confirmRegister(
  //       event.userRegModel,
  //       event.token,
  //       event.registerConfirmationMethod,
  //     );
  //     if (res == null) {
  //       emit(SendProfileSuccessState(event));
  //     } else {
  //       emit(SendProfileErrorState(res));
  //     }
  //   }
  // }

  void _confirmCode(ConfirmCodeEvent event, Emitter<AuthState> emit) async {
    String? error = await Repository().register(event);
    if (error == null) {
      emit(ConfirmCodeRegistrSuccessState());
    } else {
      emit(ConfirmCodeRegisterErrorState(error));
    }
  }

  void _editPassword(EditPasswordEvent event, Emitter<AuthState> emit) async {
    bool res = await Repository()
        .editPassword(event.password, event.token, event.fcmToken);
    if (res) {
      emit(EditPasswordSuccessState());
    } else {
      emit(EditPasswordErrorState());
    }
  }

  void _confirmCodeReset(
      ConfirmCodeResetEvent event, Emitter<AuthState> emit) async {
    String? res = await Repository().confirmCodeReset(event.phone, event.code);
    if (res != null) {
      emit(ConfirmCodeResetSuccessState());
    } else {
      emit(ConfirmCodeResetErrorState());
    }
  }

  void _checkUser(CheckUserExistEvent event, Emitter<AuthState> emit) async {
    String? res = await Repository().checkUserExist(event.phone, event.email);
    emit(CheckUserState(res));
  }

  void _getCategories(GetCategoriesEvent event, Emitter<AuthState> emit) async {
    List<TaskCategory>? res = await Repository().getCategories();
    categories = res;
    emit(GetCategoriesState(res));
  }

  void _restoreProfile(RestoreCodeEvent event, Emitter<AuthState> emit) async {
    bool res = await Repository().resetPassword(event.login);
    if (res) {
      emit(ResetPasswordSuccessState());
    } else {
      emit(ResetPasswordErrorState());
    }
  }

  void _restoreCodeConfirm(
      RestoreCodeCheckEvent event, Emitter<AuthState> emit) async {
    String? res = await Repository()
        .confirmRestorePassword(event.code, event.phone, event.updatePassword);
    if (res != null) {
      emit(ConfirmRestoreSuccessState(res));
    } else {
      emit(ConfirmRestoreErrorState());
    }
  }

  void _signIn(SignInEvent event, Emitter<AuthState> emit) async {
    String? res =
        await Repository().signIn(event.phone, event.password, event.token);
    if (res != null) {
      emit(SignInSuccessState(res));
    } else {
      emit(SignInErrorState());
    }
  }
}

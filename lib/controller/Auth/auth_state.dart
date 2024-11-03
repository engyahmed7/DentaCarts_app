part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

 class AuthInitial extends AuthState {}

class AuthLoginLoadingState extends AuthState {}

class AuthLoginSuccessState extends AuthState {}

class AuthLoginErrorState extends AuthState {
  final dynamic error;

  AuthLoginErrorState({required this.error});
}

class ChangeCheckBoxState extends AuthState{

}


class AuthRegisterLoadingState extends AuthState {}

class AuthRegisterSuccessState extends AuthState {}

class AuthRegisterErrorState extends AuthState {
  final dynamic error;

  AuthRegisterErrorState({required this.error});
}

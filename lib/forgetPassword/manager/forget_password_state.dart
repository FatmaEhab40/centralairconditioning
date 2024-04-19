// ignore_for_file: overridden_fields

class ForgetPasswordState {
  final bool isObscure;
  final String? errorMessage;

  ForgetPasswordState({this.isObscure = true, this.errorMessage});
}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordSuccessState extends ForgetPasswordState {}

class ForgetPasswordFailureState extends ForgetPasswordState {
  @override
  final String errorMessage;
  ForgetPasswordFailureState(this.errorMessage);
}

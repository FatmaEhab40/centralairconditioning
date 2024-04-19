
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class GetUsersSuccessState extends ProfileState {}

class GetUsersFailureState extends ProfileState {
  final String errorMessage;
  GetUsersFailureState(this.errorMessage);
}

class UpdateUsersSuccessState extends ProfileState {}

class UpdateUsersFailureState extends ProfileState {
  final String errorMessage;
  UpdateUsersFailureState(this.errorMessage);
}
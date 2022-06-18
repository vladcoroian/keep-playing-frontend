import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/models/user.dart';

class CurrentCoachUserCubit extends Cubit<User> {
  CurrentCoachUserCubit({required User user}) : super(user);

  void retrieveUserInformation() async {
    User user = await API.users.getCurrentUser();
    emit(user);
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/models/user.dart';

class CoachUserCubit extends Cubit<User> {
  CoachUserCubit({required User user}) : super(user);

}

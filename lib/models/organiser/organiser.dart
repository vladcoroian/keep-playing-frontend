import 'package:keep_playing_frontend/models/user.dart';

import 'organiser_model.dart';

class Organiser {
  final List<int> favourites;
  final List<int> blocked;

  Organiser._({
    required this.favourites,
    required this.blocked,
  });

  Organiser.fromModel({required OrganiserModel organiserModel})
      : this._(
          favourites: organiserModel.favourites,
          blocked: organiserModel.blocked,
        );

  bool hasUserAsAFavourite(User user) {
    return favourites.contains(user.pk);
  }

  bool hasBlockedUser(User user) {
    return blocked.contains(user.pk);
  }
}

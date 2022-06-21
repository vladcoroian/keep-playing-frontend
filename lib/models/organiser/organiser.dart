import 'organiser_model.dart';

class Organiser {
  final List<int> favouriteCoachesPKs;
  final List<int> blockedCoachesPKs;

  Organiser._({
    required this.favouriteCoachesPKs,
    required this.blockedCoachesPKs,
  });

  Organiser.fromModel({required OrganiserModel organiserModel})
      : this._(
          favouriteCoachesPKs: organiserModel.favourite,
          blockedCoachesPKs: organiserModel.blocked,
        );
}

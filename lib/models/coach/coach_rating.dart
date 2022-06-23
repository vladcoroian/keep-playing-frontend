import 'coach_rating_model.dart';

class CoachRating {
  final int pk;

  final int votes;
  final int experience;
  final int flexibility;
  final int reliability;

  CoachRating._({
    required this.pk,
    required this.votes,
    required this.experience,
    required this.flexibility,
    required this.reliability,
  });

  CoachRating.fromModel({
    required CoachRatingModel coachModel,
  }) : this._(
          pk: coachModel.pk,
          votes: coachModel.votes,
          experience: coachModel.experience,
          flexibility: coachModel.flexibility,
          reliability: coachModel.reliability,
        );
}

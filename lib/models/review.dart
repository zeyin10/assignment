class Review {
  String id;
  String profileImageUrl;
  String comment;
  String timestamp;

  Review(
    this.id,
    this.profileImageUrl,
    this.comment,
    this.timestamp,
  );
}

List<Review> reviews = [
  Review('1', 'assets/profile_pics/person_cesare.jpeg',
      'Just watched Oppenheimer again — still gives me chills every time 🔥', '10'),
  Review('2', 'assets/profile_pics/person_stef.jpeg',
      'Dune Part Two was absolutely breathtaking. Best cinematography of the year.', '25'),
  Review('3', 'assets/profile_pics/person_crispy.png',
      'Poor Things is unlike anything I\'ve ever seen. Absolute must-watch!', '20'),
  Review('4', 'assets/profile_pics/person_joe.jpeg',
      'Finally caught Killers of the Flower Moon — Scorsese is still the GOAT.', '30'),
  Review('5', 'assets/profile_pics/person_katz.jpeg',
      '''Past Lives wrecked me emotionally. The ending is hauntingly beautiful. Go see it before it leaves theaters!''',
      '40'),
  Review('6', 'assets/profile_pics/person_kevin.jpeg',
      '''The Zone of Interest is the most unsettling film I\'ve ever seen. Masterpiece.''',
      '50'),
  Review('7', 'assets/profile_pics/person_sandra.jpeg',
      '''Anatomy of a Fall had me completely riveted from start to finish. The courtroom scenes are electric!''',
      '55'),
  Review('8', 'assets/profile_pics/person_manda.png',
      'Anyone have recommendations for what to watch this weekend? Feeling like a thriller.', '60'),
  Review('9', 'assets/profile_pics/person_ray.jpeg',
      'Monster by Kore-eda is quietly devastating — don\'t sleep on it.', '70'),
  Review('10', 'assets/profile_pics/person_tiffani.jpeg',
      'Inside Out 2 somehow made me cry even more than the original 😭', '90'),
];

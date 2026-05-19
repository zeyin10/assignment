class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final int points;

  const AppUser({
    required this.uid,
    required this.email,
    this.displayName = '',
    this.points = 0,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
    uid:         map['uid']         as String? ?? '',
    email:       map['email']       as String? ?? '',
    displayName: map['displayName'] as String? ?? '',
    points:      (map['points']     as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toMap() => {
    'uid':         uid,
    'email':       email,
    'displayName': displayName,
    'points':      points,
  };
}
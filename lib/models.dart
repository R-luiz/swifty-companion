class UserProfile {
  final String login;
  final String displayName;
  final String email;
  final String? imageUrl;
  final int wallet;
  final String? location;
  final double level;
  final int correctionPoints;
  final List<Skill> skills;
  final List<UserProject> projects;

  UserProfile({
    required this.login,
    required this.displayName,
    required this.email,
    this.imageUrl,
    required this.wallet,
    this.location,
    required this.level,
    required this.correctionPoints,
    required this.skills,
    required this.projects,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Get the 42cursus entry (or fallback to last cursus)
    final cursusUsers = json['cursus_users'] as List? ?? [];
    Map<String, dynamic>? activeCursus;
    for (var c in cursusUsers) {
      if (c['cursus']?['slug'] == '42cursus') {
        activeCursus = c;
        break;
      }
    }
    activeCursus ??= cursusUsers.isNotEmpty ? cursusUsers.last : null;

    double level = 0;
    List<Skill> skills = [];
    if (activeCursus != null) {
      level = (activeCursus['level'] ?? 0).toDouble();
      final rawSkills = activeCursus['skills'] as List? ?? [];
      skills = rawSkills.map((s) => Skill.fromJson(s)).toList();
    }

    final rawProjects = json['projects_users'] as List? ?? [];
    final projects = rawProjects
        .where((p) => p['status'] == 'finished')
        .map((p) => UserProject.fromJson(p))
        .toList();

    final imageData = json['image'] as Map<String, dynamic>?;

    return UserProfile(
      login: json['login'] ?? '',
      displayName: json['displayname'] ?? json['login'] ?? '',
      email: json['email'] ?? 'N/A',
      imageUrl: imageData?['link'],
      wallet: json['wallet'] ?? 0,
      location: json['location'],
      level: level,
      correctionPoints: json['correction_point'] ?? 0,
      skills: skills,
      projects: projects,
    );
  }
}

class Skill {
  final String name;
  final double level;

  Skill({required this.name, required this.level});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] ?? 'Unknown',
      level: (json['level'] ?? 0).toDouble(),
    );
  }
}

class UserProject {
  final String name;
  final int? finalMark;
  final bool validated;

  UserProject({
    required this.name,
    this.finalMark,
    required this.validated,
  });

  factory UserProject.fromJson(Map<String, dynamic> json) {
    return UserProject(
      name: json['project']?['name'] ?? 'Unknown',
      finalMark: json['final_mark'],
      validated: json['validated?'] == true,
    );
  }
}

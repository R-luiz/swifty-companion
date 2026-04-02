import 'package:flutter/material.dart';
import 'models.dart';

class ProfilePage extends StatelessWidget {
  final UserProfile user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf0f0f5),
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          SliverToBoxAdapter(child: _buildInfoCards()),
          SliverToBoxAdapter(child: _buildSkillsSection()),
          SliverToBoxAdapter(child: _buildProjectsSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  SliverAppBar _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: const Color(0xFF1a1a2e),
      iconTheme: IconThemeData(color: Colors.grey.shade300),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                CircleAvatar(
                  radius: 45,
                  backgroundColor: const Color(0xFF2a2a4a),
                  backgroundImage:
                      user.imageUrl != null ? NetworkImage(user.imageUrl!) : null,
                  child: user.imageUrl == null
                      ? Text(
                          user.login.isNotEmpty ? user.login[0].toUpperCase() : '?',
                          style: const TextStyle(fontSize: 32, color: Colors.white70),
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  user.displayName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade200,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.login,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCards() {
    final levelInt = user.level.floor();
    final levelFrac = user.level - levelInt;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        children: [
          // Level bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Level',
                        style: TextStyle(fontSize: 13, color: Color(0xFF666680))),
                    Text(user.level.toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: levelFrac,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFe0e0ea),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF5c5c8a)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Info grid
          Row(
            children: [
              Expanded(child: _infoTile('Email', user.email)),
              const SizedBox(width: 12),
              Expanded(
                  child: _infoTile(
                      'Location', user.location ?? 'Unavailable')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _infoTile('Wallet', '${user.wallet} \u20B3')),
              const SizedBox(width: 12),
              Expanded(
                  child: _infoTile(
                      'Eval. points', '${user.correctionPoints}')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF9999b0))),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    if (user.skills.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Skills',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333350))),
            const SizedBox(height: 12),
            ...user.skills.map((s) => _skillRow(s)),
          ],
        ),
      ),
    );
  }

  Widget _skillRow(Skill skill) {
    final pct = (skill.level / 21.0).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(skill.name,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF555570)),
                    overflow: TextOverflow.ellipsis),
              ),
              Text('${skill.level.toStringAsFixed(1)} (${(pct * 100).toStringAsFixed(0)}%)',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF888898))),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 5,
              backgroundColor: const Color(0xFFe8e8f0),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF7070a0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection() {
    if (user.projects.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Projects',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333350))),
            const SizedBox(height: 12),
            ...user.projects.map((p) => _projectRow(p)),
          ],
        ),
      ),
    );
  }

  Widget _projectRow(UserProject project) {
    final color = project.validated ? const Color(0xFF4a9060) : const Color(0xFFa04050);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(project.name,
                style: const TextStyle(fontSize: 13, color: Color(0xFF444460))),
          ),
          Text(
            project.finalMark != null ? '${project.finalMark}' : '-',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

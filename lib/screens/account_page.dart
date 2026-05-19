import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import 'bookmarks_page.dart';

typedef LogoutCallback = Future<void> Function(bool didLogout);

class AccountPage extends StatefulWidget {
  final User user;
  final LogoutCallback onLogOut;
  final FavoriteManager favoriteManager;

  const AccountPage({
    super.key,
    required this.onLogOut,
    required this.user,
    required this.favoriteManager,
  });

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    widget.favoriteManager.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.favoriteManager.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildProfileHeader(context)),
          SliverToBoxAdapter(child: _buildMenuSection(context)),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withOpacity(0.6),
            colorScheme.surfaceContainerLowest,
          ],
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.primary, width: 3),
                ),
                child: ClipOval(
                  child: Image.asset(
                    widget.user.profileImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => CircleAvatar(
                      radius: 60,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        widget.user.firstName.isNotEmpty
                            ? widget.user.firstName[0]
                            : '?',
                        style: TextStyle(
                          fontSize: 40,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${widget.user.firstName} ${widget.user.lastName}'.trim(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            widget.user.role,
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 15),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatChip(context,
                  icon: Icons.star_rounded,
                  label: '${widget.user.points} pts',
                  color: Colors.amber.shade600),
              const SizedBox(width: 12),
              _buildStatChip(context,
                  icon: Icons.bookmark,
                  label: '${widget.favoriteManager.count} saved',
                  color: colorScheme.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: Text('My Activity',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 0.8)),
          ),
          _buildMenuCard(context, [
            _MenuTile(
              icon: Icons.bookmark,
              iconColor: colorScheme.primary,
              title: 'Favorites',
              subtitle: widget.favoriteManager.count == 0
                  ? 'No saved cinemas yet'
                  : '${widget.favoriteManager.count} saved cinema${widget.favoriteManager.count == 1 ? '' : 's'}',
              badge: widget.favoriteManager.count > 0
                  ? widget.favoriteManager.count
                  : null,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      BookmarksPage(favoriteManager: widget.favoriteManager),
                ));
              },
            ),
          ]),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: Text('General',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 0.8)),
          ),
          _buildMenuCard(context, [
            _MenuTile(
              icon: Icons.movie_outlined,
              iconColor: colorScheme.secondary,
              title: 'Browse All Cinemas',
              subtitle: 'Explore on Fandango',
              onTap: () async {
                await launchUrl(Uri.parse('https://www.fandango.com/'));
              },
            ),
            _MenuTile(
              icon: Icons.logout,
              iconColor: colorScheme.error,
              title: 'Log out',
              subtitle: 'Sign out of your account',
              onTap: () async {
                await widget.onLogOut(true);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, List<_MenuTile> tiles) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: tiles.asMap().entries.map((entry) {
          final i = entry.key;
          final tile = entry.value;
          return Column(
            children: [
              ListTile(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: tile.iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(tile.icon, color: tile.iconColor, size: 20),
                ),
                title: Text(tile.title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(tile.subtitle,
                    style: TextStyle(
                        fontSize: 12, color: colorScheme.onSurfaceVariant)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (tile.badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('${tile.badge}',
                            style: TextStyle(
                                color: colorScheme.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right,
                        color: colorScheme.outline, size: 20),
                  ],
                ),
                onTap: tile.onTap,
              ),
              if (i < tiles.length - 1)
                Divider(
                    height: 1,
                    indent: 68,
                    color: colorScheme.outlineVariant.withOpacity(0.5)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuTile {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final int? badge;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.onTap,
  });
}
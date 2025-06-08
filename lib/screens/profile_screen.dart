import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For date formatting

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName =
      '/profile'; // Define routeName

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email;
    // Placeholder data - replace with actual data from your user model
    final String userName =
        user?.displayName ?? "User Name";
    const String userRole = "First Responder";
    const String teamId = "Alpha-7";
    final String joinedDate =
        user?.metadata.creationTime != null
            ? DateFormat.yMMMMd().format(
              user!.metadata.creationTime!,
            )
            : "Not Available";

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(
        0xFFEFFDFE,
      ), // Consistent background
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor:
            Colors
                .transparent, // Optional: for a blended look
        elevation: 0, // Optional
        foregroundColor:
            theme.colorScheme.primary, // Adapts to theme
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor:
                  theme.colorScheme.surfaceVariant,
              backgroundImage: const AssetImage(
                'assets/images/profile.png', // Ensure this path is correct
              ),
              child:
                  const AssetImage(
                            'assets/images/profile.png',
                          )
                          .assetName
                          .isEmpty // Basic check if asset exists
                      ? Icon(
                        Icons.person,
                        size: 60,
                        color:
                            theme
                                .colorScheme
                                .onSurfaceVariant,
                      )
                      : null,
            ),
            const SizedBox(height: 16),
            Text(
              userName,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              userEmail ?? 'No Email Provided',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // User Information Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    _buildProfileListTile(
                      icon: Icons.work_outline,
                      title: "Role",
                      subtitle: userRole,
                      theme: theme,
                    ),
                    const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    _buildProfileListTile(
                      icon: Icons.group_work_outlined,
                      title: "Team ID",
                      subtitle: teamId,
                      theme: theme,
                    ),
                    const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    _buildProfileListTile(
                      icon: Icons.calendar_today_outlined,
                      title: "Member Since",
                      subtitle: joinedDate,
                      theme: theme,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Actions Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    _buildProfileListTile(
                      icon: Icons.edit_outlined,
                      title: "Edit Profile",
                      theme: theme,
                      onTap: () {
                        // TODO: Navigate to an edit profile screen
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Edit Profile (WIP)',
                            ),
                          ),
                        );
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    _buildProfileListTile(
                      icon: Icons.lock_outline,
                      title: "Change Password",
                      theme: theme,
                      onTap: () {
                        // TODO: Navigate to a change password screen
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Change Password (WIP)',
                            ),
                          ),
                        );
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Logout button can be added here if desired, though it's also in HomeScreen AppBar
            // ElevatedButton.icon(
            //   icon: const Icon(Icons.logout),
            //   label: const Text("Logout"),
            //   onPressed: () async {
            //     await FirebaseAuth.instance.signOut();
            //     Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: theme.colorScheme.error,
            //     foregroundColor: theme.colorScheme.onError,
            //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    required ThemeData theme,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle:
          subtitle != null
              ? Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              )
              : null,
      onTap: onTap,
      trailing: trailing,
      dense:
          subtitle == null, // Make it denser if no subtitle
    );
  }
}

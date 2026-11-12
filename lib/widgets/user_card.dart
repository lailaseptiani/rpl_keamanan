import 'package:flutter/material.dart';

import '../models/user.dart';

/// Kartu untuk menampilkan ringkasan satu [User] di dalam list.
///
/// Widget ini hanya bertugas menampilkan data (Single Responsibility),
/// aksi ketika diketuk diserahkan ke pemanggil melalui [onTap].
class UserCard extends StatelessWidget {
  /// Data pengguna yang ditampilkan.
  final User user;

  /// Callback ketika kartu diketuk.
  final VoidCallback? onTap;

  const UserCard({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          child: Text(user.initials),
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(user.email),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../data/model/user_model.dart';
import 'user_image_widget.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const UserImageWidget(size: 60),
        const SizedBox(height: 10),
        Text(
          UserAccount.currentUser!.username ?? 'user',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

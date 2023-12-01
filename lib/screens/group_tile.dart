import 'package:btechshayak/screens/chatpage.dart';
import 'package:btechshayak/screens/dashboard.dart';
import 'package:btechshayak/screens/widgets.dart';
import 'package:btechshayak/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupTile extends ConsumerStatefulWidget {
  final String groupId;
  final String groupName;
  const GroupTile({
    Key? key,
    required this.groupName,
    required this.groupId,
  }) : super(key: key);

  @override
  ConsumerState<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends ConsumerState<GroupTile> {
  @override
  Widget build(BuildContext context) {
    final studentName = ref.watch(studentNameProvider);

    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: ref.read(authProvider).currentUser!.displayName ?? '',
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Join the conversation as $studentName",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}

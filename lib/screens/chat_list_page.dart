import 'package:flutter/material.dart';
import '../animations/animations.dart';
import '../models/app_user.dart';
import '../models/message.dart';
import '../repositories/chat_repository.dart';
import '../repositories/auth_repository.dart';
import 'chat_room_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({
    super.key,
    required this.chatRepository,
    required this.authRepository,
  });

  final ChatRepository chatRepository;
  final AuthRepository authRepository;

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  AppUser? get _me => widget.authRepository.currentUser;

  void _openRoom(BuildContext context, ChatRoom room) {
    final me = _me;
    if (me == null) return;
    Navigator.push(
      context,
      slidePageRoute(
        ChatRoomPage(
          roomId: room.id,
          roomTitle: _roomTitle(room),
          chatRepository: widget.chatRepository,
          currentUser: me,
        ),
      ),
    );
  }

  Future<void> _createRoom(BuildContext context) async {
    final me = _me;
    if (me == null) return;

    final otherEmail = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('New Chat'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Other user's email",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text('Start Chat'),
            ),
          ],
        );
      },
    );

    if (otherEmail == null || otherEmail.isEmpty) return;
    if (otherEmail == me.email) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You can't chat with yourself.")),
        );
      }
      return;
    }

    try {
      final otherId = await widget.chatRepository.findUserIdByEmail(otherEmail);
      if (otherId == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No account found for $otherEmail')),
          );
        }
        return;
      }

      final roomId = await widget.chatRepository.createOrGetRoom(
        myUid:      me.uid,
        myEmail:    me.email,
        otherUid:   otherId,
        otherEmail: otherEmail,
      );

      if (context.mounted) {
        final room = ChatRoom(
          id:             roomId,
          lastMessage:    '',
          lastMessageAt:  DateTime.now(),
          participantIds: [me.uid, otherId],
          participantEmails: {
            me.uid:  me.email,
            otherId: otherEmail,
          },
        );
        _openRoom(context, room);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String _roomTitle(ChatRoom room) {
    final me = _me;
    if (me == null) return '';
    final emails = room.participantEmails;
    if (emails.isNotEmpty) {
      return emails.entries
          .firstWhere(
            (e) => e.key != me.uid,
        orElse: () => emails.entries.first,
      )
          .value;
    }
    return room.participantIds.firstWhere((id) => id != me.uid, orElse: () => '');
  }

  @override
  Widget build(BuildContext context) {
    final me = _me;

    if (me == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: StreamBuilder<List<ChatRoom>>(
        stream: widget.chatRepository.watchRooms(me.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final rooms = snapshot.data ?? [];

          if (rooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('No chats yet',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const Text('Tap + to start a conversation'),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: rooms.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final room = rooms[i];
              final title = _roomTitle(room);
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    title.isNotEmpty ? title[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: room.lastMessage.isNotEmpty
                    ? Text(room.lastMessage,
                    maxLines: 1, overflow: TextOverflow.ellipsis)
                    : const Text('No messages yet',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                trailing: Text(
                  _formatTime(room.lastMessageAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () => _openRoom(context, room),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createRoom(context),
        child: const Icon(Icons.edit),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }
}
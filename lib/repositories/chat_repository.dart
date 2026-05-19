import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

/// Always produces the same room ID for any two users, regardless of order.
String _roomId(String uidA, String uidB) {
  final sorted = [uidA, uidB]..sort();
  return '${sorted[0]}_${sorted[1]}';
}

class ChatRepository {
  final _firestore = FirebaseFirestore.instance;

  // ── User lookup ──────────────────────────────────────────────────────────

  Future<String?> findUserIdByEmail(String email) async {
    final snap = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return snap.docs.first.id;
  }

  // ── Rooms ────────────────────────────────────────────────────────────────

  Stream<List<ChatRoom>> watchRooms(String userId) {
    return _firestore
        .collection('chatRooms')
        .where('participantIds', arrayContains: userId)
        .snapshots()
        .map((s) {
      final rooms = s.docs
          .map((d) => ChatRoom.fromMap(d.id, d.data()))
          .toList();
      // Sort by lastMessageAt in Dart instead of Firestore
      rooms.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
      return rooms;
    })
        .handleError((e) => <ChatRoom>[]);
  }

  Future<String> createOrGetRoom({
    required String myUid,
    required String myEmail,
    required String otherUid,
    required String otherEmail,
  }) async {
    final id = _roomId(myUid, otherUid);
    final ref = _firestore.collection('chatRooms').doc(id);
    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'lastMessage':       '',
        'lastMessageAt':     DateTime.now().millisecondsSinceEpoch,
        'participantIds':    [myUid, otherUid],
        'participantEmails': {
          myUid:    myEmail,
          otherUid: otherEmail,
        },
      });
    }

    return id;
  }

  // ── Messages ─────────────────────────────────────────────────────────────

  Stream<List<Message>> watchMessages(String roomId) => _firestore
      .collection('chatRooms')
      .doc(roomId)
      .collection('messages')
      .orderBy('sentAt')
      .snapshots()
      .map((s) => s.docs.map((d) => Message.fromMap(d.id, d.data())).toList());

  Future<void> sendMessage({
    required String roomId,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final batch = _firestore.batch();

    batch.set(
      _firestore
          .collection('chatRooms')
          .doc(roomId)
          .collection('messages')
          .doc(),
      {
        'senderId':   senderId,
        'senderName': senderName,
        'text':       text,
        'sentAt':     now,
      },
    );
    batch.update(
      _firestore.collection('chatRooms').doc(roomId),
      {
        'lastMessage':   text.length > 60 ? '${text.substring(0, 60)}…' : text,
        'lastMessageAt': now,
      },
    );
    await batch.commit();
  }
}
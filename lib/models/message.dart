class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime sentAt;

  const Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.sentAt,
  });

  factory Message.fromMap(String id, Map<String, dynamic> map) => Message(
    id:         id,
    senderId:   map['senderId']   as String? ?? '',
    senderName: map['senderName'] as String? ?? 'Unknown',
    text:       map['text']       as String? ?? '',
    sentAt:     DateTime.fromMillisecondsSinceEpoch(map['sentAt'] as int? ?? 0),
  );

  Map<String, dynamic> toMap() => {
    'senderId':   senderId,
    'senderName': senderName,
    'text':       text,
    'sentAt':     sentAt.millisecondsSinceEpoch,
  };
}

class ChatRoom {
  final String id;
  final String lastMessage;
  final DateTime lastMessageAt;
  final List<String> participantIds;
  final Map<String, String> participantEmails; // uid -> email

  const ChatRoom({
    required this.id,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.participantIds,
    this.participantEmails = const {},
  });

  factory ChatRoom.fromMap(String id, Map<String, dynamic> map) => ChatRoom(
    id:            id,
    lastMessage:   map['lastMessage'] as String? ?? '',
    lastMessageAt: DateTime.fromMillisecondsSinceEpoch(map['lastMessageAt'] as int? ?? 0),
    participantIds: List<String>.from(map['participantIds'] as List? ?? []),
    participantEmails: Map<String, String>.from(
      (map['participantEmails'] as Map? ?? {}).map(
            (k, v) => MapEntry(k.toString(), v.toString()),
      ),
    ),
  );

  Map<String, dynamic> toMap() => {
    'lastMessage':       lastMessage,
    'lastMessageAt':     lastMessageAt.millisecondsSinceEpoch,
    'participantIds':    participantIds,
    'participantEmails': participantEmails,
  };
}
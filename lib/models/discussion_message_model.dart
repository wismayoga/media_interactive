class MessageModel {
  final int id;
  final String message;
  final String userName;
  final String role;
  final String time;

  MessageModel({
    required this.id,
    required this.message,
    required this.userName,
    required this.role,
    required this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      message: json['message'],
      userName: json['user']['name'],
      role: json['user']['role'],
      time: json['sent_time'],
    );
  }
}
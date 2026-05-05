import 'package:flutter/material.dart';
import 'package:media_interactive/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../providers/discussion_provider.dart';

class DiscussionScreen extends StatefulWidget {
  final int groupId;
  final String title;

  const DiscussionScreen({
    super.key,
    required this.groupId,
    required this.title,
  });

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  final TextEditingController messageC = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 🔥 ambil pesan pertama kali
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DiscussionProvider>().fetchMessages(widget.groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<DiscussionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await context.read<DiscussionProvider>().fetchMessages(
                widget.groupId,
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // 🔥 LIST CHAT
          Expanded(
            child: prov.isLoading
                ? const Center(child: CircularProgressIndicator())
                : prov.messages.isEmpty
                ? const Center(child: Text("Belum ada diskusi"))
                : ListView.builder(
                    reverse: true,
                    itemCount: prov.messages.length,
                    itemBuilder: (context, index) {
                      final msg = prov.messages[index];

                      final myId = context.read<AuthProvider>().user?.id;
                      final isMe = msg['user']['id'] == myId;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(maxWidth: 250),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🔥 NAMA
                              Text(
                                isMe ? "Anda" : msg['user']['name'] ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isMe ? Colors.white70 : Colors.black54,
                                ),
                              ),

                              const SizedBox(height: 4),

                              // 💬 PESAN
                              Text(
                                msg['message'] ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // 🕒 TANGGAL + JAM
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  "${msg['sent_at'] ?? ''} • ${msg['sent_time'] ?? ''}",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isMe
                                        ? Colors.white70
                                        : Colors.black45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // 🔥 INPUT CHAT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageC,
                      decoration: const InputDecoration(
                        hintText: "Ketik pesan...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      if (messageC.text.trim().isEmpty) return;

                      await context.read<DiscussionProvider>().sendMessage(
                        widget.groupId,
                        messageC.text,
                      );

                      messageC.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

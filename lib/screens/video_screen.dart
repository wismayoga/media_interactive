import 'package:flutter/material.dart';
import 'video_player_screen.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videos = [
      {"title": "Kabel LAN Cross", "videoId": "dOqm495Inng"},
      {"title": "Kabel LAN Straight", "videoId": "ictWNhVKtmY"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4EFF5),
      appBar: AppBar(
        title: const Text("Video Pembelajaran"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerScreen(
                      title: video['title']!,
                      videoId: video['videoId']!,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(0.35),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 54,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      video['title']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

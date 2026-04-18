import 'package:flutter/material.dart';
import 'video_player_screen.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videos = [
      {
        "title": "Kabel LAN Cross",
        "url":
            "https://drive.google.com/file/d/1zekeTVry3MkJyi7g_HpFX-SIGYhavnmp/view?usp=drive_link",
        "image": "assets/images/cross_lan.png",
      },
      {
        "title": "Kabel LAN Straight",
        "url":
            "https://drive.google.com/file/d/16AVDxQCNzTVHBtEMjIsIfNnRTjTPAoiX/view?usp=drive_link",
        "image": "assets/images/straight_lan.png",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Video Pembelajaran")),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];

          return Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerScreen(
                      title: video['title']!,
                      url: video['url']!,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔥 GAMBAR (ASSET)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          video['image']!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),

                        // ▶️ ICON PLAY
                        const Icon(
                          Icons.play_circle_fill,
                          size: 60,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),

                  // 🔤 TITLE
                  Padding(
                    padding: const EdgeInsets.all(12),
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

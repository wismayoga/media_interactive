import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:media_interactive/screens/discussion_screen.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../providers/materi_provider.dart';
import '../models/materi_model.dart';
import 'show_pdf_screen.dart';
import '../core/api/api_service.dart';

class MateriScreen extends StatefulWidget {
  const MateriScreen({super.key});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  bool _downloading = false;
  CancelToken? _cancelToken;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MateriProvider>().fetchMateri();
    });
  }

  @override
  Widget build(BuildContext context) {
    final materiProv = context.watch<MateriProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("List Materi"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: materiProv.isLoading
          ? const Center(child: CircularProgressIndicator())
          : materiProv.materi.isEmpty
          ? const Center(child: Text("Tidak ada materi"))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: materiProv.materi.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.70,
                ),
                itemBuilder: (context, index) {
                  final item = materiProv.materi[index];

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Icon(Icons.menu_book_rounded, size: 42),
                          const SizedBox(height: 10),

                          Expanded(
                            child: Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Column(
                            children: [
                              // 📄 PDF BUTTON
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _downloading
                                      ? null
                                      : () async {
                                          if (item.pdfUrl == null) return;

                                          final messenger =
                                              ScaffoldMessenger.of(context);

                                          try {
                                            await _downloadAndOpenPdf(
                                              context,
                                              item.pdfUrl!,
                                              item.title,
                                              messenger,
                                            );
                                          } catch (e) {
                                            messenger.showSnackBar(
                                              SnackBar(
                                                content: Text("Error: $e"),
                                              ),
                                            );
                                          }
                                        },
                                  child: const Text("Lihat PDF"),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // 💬 DISKUSI BUTTON
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: item.hasGroup
                                      ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => DiscussionScreen(
                                                groupId: item.groupId!,
                                                title: item.title,
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: const Text("Diskusi"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  // 🔥 DOWNLOAD + OPEN PDF
  Future<void> _downloadAndOpenPdf(
    BuildContext context,
    String rawUrl,
    String title,
    ScaffoldMessengerState messenger,
  ) async {
    if (mounted) setState(() => _downloading = true);

    _cancelToken = CancelToken();

    // 🔥 NORMALISASI URL (pakai ApiService)
    String url = rawUrl.trim();
    if (url.startsWith('/')) {
      url = ApiService.baseDomain + url;
    }

    final dio = Dio();

    final tempDir = await getTemporaryDirectory();
    final filename = p.basename(Uri.parse(url).path);
    final path = p.join(tempDir.path, filename);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _DownloadDialog(),
    );

    try {
      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            _DownloadDialog.update(received / total);
          }
        },
      );

      if (mounted) Navigator.pop(context);

      final file = File(path);
      await file.writeAsBytes(response.data!);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ShowPdfScreen(title: title, filePath: file.path),
        ),
      );
    } catch (e) {
      if (mounted) Navigator.pop(context);
      messenger.showSnackBar(SnackBar(content: Text("Gagal download: $e")));
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }
}

class _DownloadDialog extends StatefulWidget {
  static _DownloadDialogState? _state;

  static void update(double value) {
    _state?._update(value);
  }

  const _DownloadDialog();

  @override
  State<_DownloadDialog> createState() {
    final s = _DownloadDialogState();
    _state = s;
    return s;
  }
}

class _DownloadDialogState extends State<_DownloadDialog> {
  double progress = 0;

  void _update(double v) {
    if (!mounted) return;
    setState(() => progress = v);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Mengunduh..."),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 10),
          Text("${(progress * 100).toStringAsFixed(0)}%"),
        ],
      ),
    );
  }
}

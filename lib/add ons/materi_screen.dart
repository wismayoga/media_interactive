// materi_screen.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:media_interactive_app/providers/siswa_provider.dart';
import 'package:media_interactive_app/models/materi_model.dart';
import 'package:media_interactive_app/screens/show_pdf_screen.dart';

class MateriScreen extends StatefulWidget {
  const MateriScreen({super.key});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  bool _downloading = false;
  CancelToken? _cancelToken;

  @override
  Widget build(BuildContext context) {
    final siswaProvider = Provider.of<SiswaProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          "List Materi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<MateriModel>>(
        future: siswaProvider.fetchMateriList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Gagal memuat data: ${snapshot.error}"));
          }

          final allMateri = snapshot.data ?? [];
          final materiList = allMateri
              .where((m) => m.type == "materi")
              .toList();

          if (materiList.isEmpty) {
            return const Center(child: Text("Tidak ada Materi"));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: materiList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.70,
              ),
              itemBuilder: (context, index) {
                final item = materiList[index];

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.menu_book_rounded,
                          size: 42,
                          color: Colors.black87,
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _downloading
                                ? null
                                : () async {
                                    if (item.pdfUrl == null ||
                                        item.pdfUrl!.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Tidak ada file PDF'),
                                        ),
                                      );
                                      return;
                                    }

                                    // Tangkap messenger terlebih dahulu agar aman setelah await
                                    final messenger = ScaffoldMessenger.of(
                                      context,
                                    );

                                    try {
                                      await _downloadAndOpenPdf(
                                        context,
                                        item.pdfUrl!,
                                        item.title,
                                        messenger,
                                      );
                                    } catch (e) {
                                      // aman karena menggunakan messenger yang sudah ditangkap
                                      messenger.showSnackBar(
                                        SnackBar(content: Text('Gagal: $e')),
                                      );
                                    }
                                  },
                            child: const Text(
                              "Show PDF",
                              style: TextStyle(fontSize: 13),
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
        },
      ),
    );
  }

  Future<void> _downloadAndOpenPdf(
    BuildContext context,
    String rawUrl,
    String title,
    ScaffoldMessengerState messenger,
  ) async {
    // set state sebelum operasi async
    if (mounted) {
      setState(() => _downloading = true);
    }
    _cancelToken = CancelToken();

    // normalisasi URL
    String url = rawUrl.trim();
    if (url.startsWith('//')) {
      url = 'https:$url';
    } else if (url.startsWith('/')) {
      url = 'https://rakitanku.xyz$url';
    } else if (!url.startsWith(RegExp(r'https?://'))) {
      url = 'https://rakitanku.xyz/$url';
    }

    final dio = Dio();
    dio.options.followRedirects = true;
    dio.options.connectTimeout = const Duration(seconds: 30);

    final tempDir = await getTemporaryDirectory();
    final filename = p.basename(Uri.parse(url).path).isNotEmpty
        ? p.basename(Uri.parse(url).path)
        : 'materi_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final outPath = p.join(tempDir.path, filename);
    final outFile = File(outPath);

    // tampilkan dialog progress (dipanggil sebelum await)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _DownloadProgressDialog(),
    );

    try {
      if (await outFile.exists()) {
        try {
          await outFile.delete();
        } catch (_) {}
      }

      // download sebagai bytes agar file ditulis atomik
      final resp = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {"Accept": "application/pdf, */*"},
        ),
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            _DownloadProgressDialog.updateProgress(received / total);
          } else {
            _DownloadProgressDialog.updateProgress(null);
          }
        },
      );

      // tutup dialog (cek mounted agar aman)
      try {
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
      } catch (_) {}

      if (resp.statusCode != 200) {
        throw Exception('HTTP ${resp.statusCode}');
      }

      final bytes = resp.data;
      if (bytes == null || bytes.isEmpty) throw Exception('File kosong.');

      await outFile.create(recursive: true);
      await outFile.writeAsBytes(bytes, flush: true);

      if (!mounted) return;

      // buka ShowPdfScreen dengan file lokal
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ShowPdfScreen(title: title, filePath: outFile.path),
        ),
      );
    } on DioException catch (e) {
      // pastikan dialog ditutup
      try {
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
      } catch (_) {}
      if (CancelToken.isCancel(e)) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Unduhan dibatalkan.')),
        );
      } else {
        messenger.showSnackBar(
          SnackBar(content: Text('Gagal unduh PDF: ${e.message}')),
        );
      }
    } catch (e) {
      try {
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
      } catch (_) {}
      messenger.showSnackBar(SnackBar(content: Text('Gagal unduh PDF: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _downloading = false;
          _cancelToken = null;
        });
      } else {
        _cancelToken = null;
      }
    }
  }
}

class _DownloadProgressDialog extends StatefulWidget {
  static _DownloadProgressDialogState? _currentState;
  static void updateProgress(double? value) {
    _currentState?._update(value);
  }

  @override
  State<_DownloadProgressDialog> createState() {
    final s = _DownloadProgressDialogState();
    _DownloadProgressDialog._currentState = s;
    return s;
  }
}

class _DownloadProgressDialogState extends State<_DownloadProgressDialog> {
  double? _progress;

  void _update(double? v) {
    if (!mounted) return;
    setState(() => _progress = v);
  }

  @override
  void dispose() {
    if (_DownloadProgressDialog._currentState == this) {
      _DownloadProgressDialog._currentState = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Mengunduh...'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _progress == null
              ? const LinearProgressIndicator()
              : LinearProgressIndicator(value: _progress),
          const SizedBox(height: 12),
          Text(
            _progress == null
                ? 'Mengunduh...'
                : '${(_progress! * 100).toStringAsFixed(0)}%',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // hanya menutup dialog; pembatalan aktual harus panggil cancel token
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Tutup'),
        ),
      ],
    );
  }
}

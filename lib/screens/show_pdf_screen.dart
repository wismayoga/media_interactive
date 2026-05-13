// show_pdf_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

/// ShowPdfScreen: jika filePath diberikan -> langsung buka file lokal.
/// Jika tidak ada filePath, akan menampilkan pesan error (atau Anda bisa menambahkan download).
class ShowPdfScreen extends StatefulWidget {
  final String title;
  final String? pdfUrl; // optional
  final String? filePath; // local file path optional

  const ShowPdfScreen({
    super.key,
    required this.title,
    this.pdfUrl,
    this.filePath,
  });

  @override
  State<ShowPdfScreen> createState() => _ShowPdfScreenState();
}

class _ShowPdfScreenState extends State<ShowPdfScreen> {
  String? _filePath;
  String? _error;
  bool _pdfReady = false;
  int _pages = 0;
  int _currentPage = 0;
  PDFViewController? _pdfViewController;

  @override
  void initState() {
    super.initState();

    // Utamakan filePath lokal bila tersedia
    if (widget.filePath != null && widget.filePath!.isNotEmpty) {
      final fp = widget.filePath!;
      final normalized = _normalizeFilePath(fp);
      final file = File(normalized);
      if (!file.existsSync()) {
        _error = 'File lokal tidak ditemukan: $normalized';
      } else {
        _filePath = normalized;
      }
    } else {
      // jika tidak ada filePath, jangan otomatis download lagi di sini
      _error = widget.pdfUrl != null && widget.pdfUrl!.isNotEmpty
          ? 'File belum diunduh. Kembali ke daftar untuk mengunduh.'
          : 'Tidak ada file atau URL tersedia untuk ditampilkan.';
    }
  }

  String _normalizeFilePath(String p) {
    if (p.startsWith('file://')) {
      return p.replaceFirst('file://', '');
    }
    return p;
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Gagal memuat PDF:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  // jika filePath hilang, beri kesempatan buat refresh cek sederhana
                  if (widget.filePath != null && widget.filePath!.isNotEmpty) {
                    final file = File(_normalizeFilePath(widget.filePath!));
                    if (file.existsSync()) {
                      setState(() {
                        _filePath = file.path;
                        _error = null;
                      });
                      return;
                    }
                  }
                },
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_filePath == null) {
      return const Center(child: Text('File belum tersedia.'));
    }

    final file = File(_filePath!);
    if (!file.existsSync()) {
      return Center(child: Text('File tidak ditemukan: $_filePath'));
    }

    return Stack(
      children: [
        PDFView(
          filePath: _filePath,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: true,
          pageFling: true,
          onRender: (pages) {
            setState(() {
              _pages = pages ?? 0;
              _pdfReady = true;
            });
          },
          onError: (err) {
            setState(() {
              _error = 'PDF error: $err';
            });
          },
          onPageError: (page, err) {
            setState(() {
              _error = 'Error halaman $page: $err';
            });
          },
          onViewCreated: (PDFViewController vc) {
            _pdfViewController = vc;
          },
          onPageChanged: (int? page, int? total) {
            setState(() {
              _currentPage = page ?? 0;
            });
          },
        ),
        if (!_pdfReady) const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title.isNotEmpty ? widget.title : 'PDF Viewer';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (_filePath != null && _pdfReady)
            Center(child: Text('${_currentPage + 1}/$_pages')),
          const SizedBox(width: 12),
        ],
      ),

      body: _buildBody(),

      bottomNavigationBar: _pdfReady
          ? Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _currentPage > 0
                          ? () async {
                              final prevPage = _currentPage - 1;
                              await _pdfViewController?.setPage(prevPage);
                            }
                          : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("PREV"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _currentPage < (_pages - 1)
                          ? () async {
                              final nextPage = _currentPage + 1;
                              await _pdfViewController?.setPage(nextPage);
                            }
                          : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("NEXT"),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _pdfViewController = null;
    super.dispose();
  }
}

// lib/screens/show_pdf_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;

class ShowPdfScreen extends StatefulWidget {
  final String url;
  final String? title;

  const ShowPdfScreen({super.key, required this.url, this.title});

  @override
  State<ShowPdfScreen> createState() => _ShowPdfScreenState();
}

class _ShowPdfScreenState extends State<ShowPdfScreen> {
  PdfControllerPinch? _pdfController;
  bool _loading = true;
  String? _error;
  int _pagesCount = 0;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    setState(() {
      _loading = true;
      _error = null;
      _pagesCount = 0;
      _currentPage = 1;
      _pdfController?.dispose();
      _pdfController = null;
    });

    try {
      final uri = Uri.parse(widget.url);
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception('Gagal mengunduh file: ${response.statusCode}');
      }
      final Uint8List bytes = response.bodyBytes;

      // IMPORTANT: pass Future<PdfDocument> (PdfDocument.openData(bytes)) to controller
      final futureDoc = PdfDocument.openData(bytes);

      _pdfController = PdfControllerPinch(document: futureDoc);

      // retrieve page count once document is ready
      final doc = await futureDoc;
      if (!mounted) return;
      setState(() {
        _pagesCount = doc.pagesCount;
        _loading = false;
      });

      // listen to page changes to update UI
      _pdfController!.addListener(_onControllerChanged);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _onControllerChanged() {
    try {
      final page = _pdfController?.page ?? 1;
      if (page != null && mounted) {
        setState(() {
          _currentPage = page;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _pdfController?.removeListener(_onControllerChanged);
    _pdfController?.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 56,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 12),
              Text(
                'Terjadi kesalahan saat memuat PDF:\n$_error',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadPdf,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    // PdfViewPinch with controller (supports pinch-to-zoom)
    return Stack(
      children: [
        PdfViewPinch(controller: _pdfController!),
        // small page indicator top-right
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$_currentPage/$_pagesCount',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _gotoPageDialog() async {
    final pageText = await showDialog<String?>(
      context: context,
      builder: (_) {
        final txtController = TextEditingController();
        return AlertDialog(
          title: const Text('Buka halaman'),
          content: TextField(
            controller: txtController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Nomor halaman (1 - $_pagesCount)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, txtController.text),
              child: const Text('Buka'),
            ),
          ],
        );
      },
    );

    if (pageText != null && pageText.trim().isNotEmpty) {
      final n = int.tryParse(pageText.trim());
      if (n != null &&
          _pdfController != null &&
          n >= 1 &&
          (_pagesCount == 0 || n <= _pagesCount)) {
        _pdfController!.jumpToPage(n);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nomor halaman tidak valid')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'PDF Viewer'),
        actions: [
          if (!_loading && _error == null)
            IconButton(
              tooltip: 'Buka halaman',
              icon: const Icon(Icons.search),
              onPressed: _gotoPageDialog,
            ),
          if (!_loading && _error == null)
            IconButton(
              tooltip: 'Previous',
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                final prev = (_currentPage - 1).clamp(
                  1,
                  _pagesCount == 0 ? _currentPage : _pagesCount,
                );
                _pdfController?.jumpToPage(prev);
              },
            ),
          if (!_loading && _error == null)
            IconButton(
              tooltip: 'Next',
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                final next = (_currentPage + 1).clamp(
                  1,
                  _pagesCount == 0 ? _currentPage : _pagesCount,
                );
                _pdfController?.jumpToPage(next);
              },
            ),
        ],
      ),
      body: _buildBody(),
    );
  }
}

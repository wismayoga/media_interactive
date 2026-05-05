import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MateriDetailScreen extends StatefulWidget {
  final String title;
  final String pdfUrl;

  const MateriDetailScreen({
    super.key,
    required this.title,
    required this.pdfUrl,
  });

  @override
  State<MateriDetailScreen> createState() => _MateriDetailScreenState();
}

class _MateriDetailScreenState extends State<MateriDetailScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    // 🔥 DEBUG URL
    debugPrint("PDF URL: ${widget.pdfUrl}");

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.pdfUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: WebViewWidget(controller: controller),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class SourceBelajarScreen extends StatefulWidget {
  final String url;
  const SourceBelajarScreen({super.key, required this.url});

  @override
  State<SourceBelajarScreen> createState() => _SourceBelajarScreenState();
}

class _SourceBelajarScreenState extends State<SourceBelajarScreen> {
  late WebViewXController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sumber Belajar"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: WebViewX(
        initialContent: widget.url,
        initialSourceType: SourceType.url,
        javascriptMode: JavascriptMode.unrestricted,
        height: double.infinity,
        width: double.infinity,
        onWebViewCreated: (controller) {
          _controller = controller;
        },
      ),
    );
  }
}
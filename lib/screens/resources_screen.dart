import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:getwidget/getwidget.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.wikipedia.org'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Resources'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Column(
        children: [
          GFCard(
            boxFit: BoxFit.cover,
            titlePosition: GFPosition.start,
            title: const GFListTile(
              title: Text('Learning Resources'),
              subTitle: Text('Access educational content to help with your quiz'),
            ),
            content: const Text(
              'Browse through various educational resources to enhance your quiz performance.',
            ),
          ),
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}

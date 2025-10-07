import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

// Untuk Android/iOS
import 'package:webview_flutter/webview_flutter.dart';

// Untuk Web (iframe modern)
import 'dart:ui_web' as ui; // ✅ ganti dari dart:ui ke dart:ui_web
import 'package:web/web.dart' as web;

class HelpResourcesScreen extends StatefulWidget {
  final String username;
  const HelpResourcesScreen({super.key, required this.username});

  @override
  State<HelpResourcesScreen> createState() => _HelpResourcesScreenState();
}

class _HelpResourcesScreenState extends State<HelpResourcesScreen> {
  WebViewController? _controller;
  bool isLoading = true;
  String currentUrl = 'https://brainly.co.id/';

  final List<Map<String, String>> resources = [
    {
      'title': 'Brainly',
      'url': 'https://brainly.co.id/',
      'description': 'Tanya jawab pelajaran sekolah'
    },
    {
      'title': 'Wikipedia',
      'url': 'https://id.wikipedia.org/',
      'description': 'Ensiklopedia online'
    },
    {
      'title': 'Ruangguru',
      'url': 'https://www.ruangguru.com/',
      'description': 'Platform belajar online'
    },
  ];

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _registerIFrame(currentUrl);
    } else {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              setState(() {
                isLoading = true;
                currentUrl = url;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                isLoading = false;
              });
            },
          ),
        )
        ..loadRequest(Uri.parse(currentUrl));
    }
  }

  void _registerIFrame(String url) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
          (int viewId) {
        final iframe = web.HTMLIFrameElement();
        iframe.src = url;
        iframe.style.border = 'none';
        iframe.style.width = '100%';
        iframe.style.height = '100%';
        return iframe;
      },
    );
  }

  void _loadResource(String url) {
    setState(() {
      currentUrl = url;
    });

    if (kIsWeb) {
      _registerIFrame(url);
    } else {
      _controller?.loadRequest(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget webviewContent;

    if (kIsWeb) {
      webviewContent = const HtmlElementView(viewType: 'iframeElement');
    } else {
      webviewContent = Stack(
        children: [
          if (_controller != null) WebViewWidget(controller: _controller!),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sumber Belajar'),
        actions: [
          if (!kIsWeb && _controller != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _controller!.reload(),
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: resources.length,
              itemBuilder: (context, index) {
                final resource = resources[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ElevatedButton(
                    onPressed: () => _loadResource(resource['url']!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentUrl == resource['url']
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200],
                      foregroundColor: currentUrl == resource['url']
                          ? Colors.white
                          : Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          resource['title']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          resource['description']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: currentUrl == resource['url']
                                ? Colors.white70
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(child: webviewContent),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpResourcesScreen extends StatefulWidget {
  final String username;
  const HelpResourcesScreen({super.key, required this.username});

  @override
  State<HelpResourcesScreen> createState() => _HelpResourcesScreenState();
}

class _HelpResourcesScreenState extends State<HelpResourcesScreen> {
  late final WebViewController _controller;
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
    _initializeWebView();
  }

  void _initializeWebView() {
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
          onNavigationRequest: (request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(currentUrl));
  }

  void _loadResource(String url) {
    setState(() {
      currentUrl = url;
    });
    _controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sumber Belajar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
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
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
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
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

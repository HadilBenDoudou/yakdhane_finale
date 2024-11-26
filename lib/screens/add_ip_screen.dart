import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CameraStreamPage extends StatefulWidget {
  @override
  _CameraStreamPageState createState() => _CameraStreamPageState();
}

class _CameraStreamPageState extends State<CameraStreamPage> {
  late final WebViewController _webViewController;
  String? enteredIp;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  void _loadCameraStream(String ip) {
    final url = 'http://$ip:8080/video?type=mjpeg';
    _webViewController.loadRequest(Uri.parse(url));
    setState(() {
      enteredIp = ip;
    });
  }

  void _showIpInputDialog() {
    final TextEditingController ipController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Entrer l\'adresse IP'),
        content: TextField(
          controller: ipController,
          decoration: InputDecoration(hintText: 'Adresse IP'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              final ip = ipController.text.trim();
              if (ip.isNotEmpty) {
                _loadCameraStream(ip);
                Navigator.of(context).pop();
              }
            },
            child: Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera Stream"),
      ),
      body: enteredIp == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _showIpInputDialog,
              child: CircleAvatar(
                radius: 35, // Taille du cercle
                backgroundColor: Colors.black54,
                child: Icon(
                  Icons.add,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 8), // Espacement entre l'icône et le texte
            Text(
              'Ajouter une adresse IP de caméra',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      )
          : WebViewWidget(controller: _webViewController),
    );
  }
}

void main() => runApp(MaterialApp(home: CameraStreamPage()));

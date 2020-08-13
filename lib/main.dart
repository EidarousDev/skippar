import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skippar',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(),
    ));

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  String selectedUrl = 'https://skippar.com';
  // ignore: prefer_collection_literals
  final Set<JavascriptChannel> jsChannels = [
    JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        }),
  ].toSet();
  TextEditingController _teController = new TextEditingController();
  bool showLoading = false;

  void updateLoading(bool ls) {
    this.setState(() {
      showLoading = ls;
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.deepPurple);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                    flex: 10,
                    child: Stack(
                      children: <Widget>[
                        WebviewScaffold(
                          url: selectedUrl,
                          javascriptChannels: jsChannels,
                          mediaPlaybackRequiresUserGesture: false,
                          withZoom: true,
                          withLocalStorage: true,
                          hidden: true,
                          initialChild: Container(
                            color: Colors.deepPurple,
                            child: const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.cyanAccent,
                                strokeWidth: 10,
                              ),
                            ),
                          ),
                          bottomNavigationBar: BottomAppBar(
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_ios),
                                  onPressed: () {
                                    flutterWebViewPlugin.goBack();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios),
                                  onPressed: () {
                                    flutterWebViewPlugin.goForward();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.autorenew),
                                  onPressed: () {
                                    flutterWebViewPlugin.reload();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        (showLoading)
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Center()
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return flutterWebViewPlugin.goBack();
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewPDF extends StatefulWidget {
  final String html;


  ViewPDF(this.html);

  @override
  _ViewPDFState createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {

  @override
  Widget build(BuildContext context) {
    //using webView to decode HTML code to generate pdf from it and can view and print the pdf file
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: Uri.dataFromString(widget.html,
              mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString(),

    );
  }
}

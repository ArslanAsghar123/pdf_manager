import 'dart:convert';
import 'dart:io' as platform;

import 'package:flpdf/iframe.dart';
import 'package:flpdf/model/paper_size_model.dart';
import 'package:flpdf/view_pdf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import 'model/setting_model.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //impliment Controllers to textField to pass data and genarate PDF from required HTML code paste in TextField
  var controller = TextEditingController();
  var controller1 = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pdf Manager'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           //Checking the required platform (WEB,Android,IOS),if it,s not web web then...
            // Paste JSON Code Here to perform Setting operations
            if(!kIsWeb)
            TextFormField(
              controller: controller1,
              decoration: InputDecoration(
                  hintText: 'Paste Settings Here',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
            SizedBox(
              height: 20,
            ),
            //Paste HTML code here to Generate PDF
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                  hintText: 'Paste Html Here',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                if (controller.text.isEmpty) {
                } else {
                  //If the platform is WEB Then Navigate to iframe screen where WEB dependencies and operation perform to run the pdf file on web
                  if (kIsWeb) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          {
                            return IframeScreen(controller.text);
                          }
                        },
                      ),
                    );
                  } else {
                    // NOT running on the web! You can check for additional platforms here.
                    //ViewPdf before Doing Print Operations
                    _viewPdf(
                      controller1.text,
                      controller.text,
                    );
                  }
                }
              },
              child: Text(
                'Generate Pdf',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
//most importand step in App where you can generate pdf from HTML code and apply Settings that has been provided through JSON code
  _generatePdf(String settings, String html) async {
    var setting = convertToModel(settings);
    if (platform.Platform.isAndroid || platform.Platform.isIOS) {
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
        return await Printing.convertHtml(
          format: format.copyWith(
              width: setting.paperSize.width.toDouble(),
              height: setting.paperSize.height.toDouble()),
          html: html,
        );
      });
    } else {}
  }
//handle click enables you to choose from diffrent options either you can exit or you can pront and save pdf File
  void handleClick(String choice) {
    if (choice == 'Print & Save') {
      _generatePdf(controller1.text, controller.text);
    } else if (choice == "Exit") {
      Navigator.pop(context);
    }
  }

  //Here you use JSONDecode method to decode JSON code And apply settings to print page of your desired size and can apply color properties

  Setting convertToModel(String settings) {
    var setting = Setting();
    Map<String, dynamic> user = jsonDecode(settings);
    setting.backgroundColor = user["backgroundColor"] as String;
    setting.color = user["color"] as String;
    setting.headerSize = user["headerSize"] as double;
    setting.footerSize = user["footerSize"] as double;
    setting.paperSize = PaperSize();
    try {
      setting.paperSize.width = user["paperSize"]["width"] as int;
    } catch (err) {
      print(err);
    }
    setting.paperSize.height = user["paperSize"]["height"] as int;
    return setting;
  }
//ViewPdf before Doing Print Operations
  _viewPdf(String settings, String html) {
    if (controller.text.isNotEmpty) {
      var setting = convertToModel(settings);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        {
          return SafeArea(
            child: Column(
              children: [
                Container(
                  clipBehavior: Clip.none,
                  height: setting.headerSize,
                  padding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
                  color: Colors.blue,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text(
                          "Header",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.none),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: IconButton(
                                icon: Image.asset('asset/images/pdf.png'),
                                iconSize: 16,
                                onPressed: () {
                                  //   window.print();
                                },
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: PopupMenuButton<String>(
                                onSelected: handleClick,
                                itemBuilder: (BuildContext context) {
                                  return {'Print & Save', 'Exit'}
                                      .map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                 Flexible(child: Container(child: ViewPDF(html))),
                Container(
                  height: setting.footerSize,
                  padding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
                  color: Colors.grey,
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Footer",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        decoration: TextDecoration.none),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        }
      }));
    } else {}
  }
}

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_student.dart';

class scannerScreen extends StatefulWidget {
  const scannerScreen({super.key});

  @override
  State<scannerScreen> createState() => _scannerScreenState();
}

class _scannerScreenState extends State<scannerScreen> {
  ScanResult? scanResult;
  String? testPlatform;

  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');

  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(
            children: [
              NavbarStudent(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              ),
              //Text(testPlatform!),
            ],
          )
        ],
      ),
    );
  }
}

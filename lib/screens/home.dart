import 'package:flutter/material.dart';

class homeScreen extends StatelessWidget {
  const homeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var kPrimary = Color.fromARGB(255, 0, 166, 90);
    //ใช้หาขนานความกว้างของหน้าจอขณะนั้น
    double widthPage = MediaQuery.of(context).size.width;
    //ใช้หาขนานความสูงของหน้าจอขณะนั้น
    double hightPage = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimary,
      
    );
  }
}
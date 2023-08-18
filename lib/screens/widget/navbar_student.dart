import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class NavbarStudent extends StatefulWidget {
  const NavbarStudent({super.key});

  @override
  State<NavbarStudent> createState() => _NavbarStudentState();
}

class _NavbarStudentState extends State<NavbarStudent> {
  bool pressed1 = true;
  bool pressed2 = true;
  bool pressed3 = true;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
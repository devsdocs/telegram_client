import 'package:flutter/material.dart';
import 'package:galaxeus_lib_flutter/galaxeus_lib_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: context.width,
            minHeight: context.height,
          ),
          child: Center(
            child: Text(
              "Slo: ${Navigator.canPop(context)}",
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }
}

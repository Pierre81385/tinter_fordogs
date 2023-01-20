import 'package:flutter/material.dart';
import '../cards/background_widget.dart';
import '../cards/cardstack_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Cards extends StatelessWidget {
  Cards({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: const [
          BackgroudCurveWidget(),
          CardsStackWidget(),
        ],
      ),
    );
  }
}

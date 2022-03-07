import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';

class LogoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
        //  ShaderMask(
        //   // blendMode: BlendMode.s,
        //   shaderCallback: (Rect bounds) {
        //     return LinearGradient(
        //       colors: <Color>[
        //         Color(0xffFFA800),
        //         Color(0xffFFC700),
        //         Color(0xffFCE740)
        //       ],
        //       tileMode: TileMode.mirror,
        //       begin: Alignment.bottomCenter,
        //       end: Alignment.topCenter,
        //     ).createShader(bounds);
        //   },
        BorderedText(
      strokeColor: Colors.black,
      child: const Text(
        'SKRIBBL GAME',
        style: TextStyle(fontSize: 50, color: Colors.amber),
      ),
    );
  }
}

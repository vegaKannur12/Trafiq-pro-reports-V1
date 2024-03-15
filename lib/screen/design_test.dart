import 'package:flutter/material.dart';
import 'package:trafiqpro/components/waveclipper.dart';

class DesignState extends StatefulWidget {
  const DesignState({super.key});

  @override
  State<DesignState> createState() => DesignStateState();
}

class DesignStateState extends State<DesignState> {
  WaveClipper wc = WaveClipper();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Container(
          child: Stack(
            children: [
              Opacity(
                opacity: 0.5,
                child: ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: 200,
                    color: Colors.black,
                  ),
                ),
              ),
              // Container(
              //   height: size.height * 100,
              //   color: Colors.red,
              //   child: ClipPath(
              //     clipper: WaveClipper(),
              //     child: Container(
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }
}

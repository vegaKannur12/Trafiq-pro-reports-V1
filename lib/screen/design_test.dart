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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // value.setIsSearch(false);
            },
            // onPressed: () => Navigator.of(context).pop(),
          ),
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
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 180,
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Medicine",
                      style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
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

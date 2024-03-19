import 'package:flutter/material.dart';

class Design3 extends StatefulWidget {
  const Design3({super.key});

  @override
  State<Design3> createState() => _Design3State();
}

class _Design3State extends State<Design3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/back4.png",
                    ),
                    fit: BoxFit.fill),
              ),
              child: Container(
                color: Color.fromARGB(255, 151, 136, 247).withOpacity(0.5),
                child: Padding(
                  padding: EdgeInsets.only(top: 60, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 2),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 250,
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 1,
                        color: const Color.fromARGB(255, 235, 231, 231),
                        spreadRadius: 1),
                  ]),
              child: Text(
                "Login",
                style: TextStyle(
                    color: Colors.black, fontSize: 30, letterSpacing: 1),
              ),
            ),
          )
        ],
      ),
    );
  }
}

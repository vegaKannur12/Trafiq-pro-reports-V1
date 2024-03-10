import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/components/date_find.dart';
import 'package:trafiqpro/controller/controller.dart';
import 'package:trafiqpro/screen/batch_detail.dart';
import 'package:trafiqpro/screen/product_detail_table.dart';

class Detail_list extends StatefulWidget {
  Map<String, dynamic> map = {};
  int id;
  String title;
  Detail_list({required this.map, required this.id, required this.title});

  @override
  State<Detail_list> createState() => _Detail_listState();
}

class _Detail_listState extends State<Detail_list> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateFind dateFind = DateFind();
    String? todaydate;
    DateTime now = DateTime.now();

    return Scaffold(
      // backgroundColor: Colors.transparent,

      // appBar: AppBar(
      //   // brightness: Brightness.dark,
      //   elevation: 0.0,
      //   toolbarHeight: 100,
      //   title: Text(
      //     "${widget.title}",
      //     style: TextStyle(
      //         color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      //   ),
      //   centerTitle: true,
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //         borderRadius: BorderRadius.only(
      //             bottomLeft: Radius.circular(20),
      //             bottomRight: Radius.circular(20)),
      //         gradient: LinearGradient(colors: [
      //           Color.fromARGB(255, 122, 104, 236),
      //           Color.fromARGB(255, 233, 106, 148)
      //         ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
      //   ),
      //   leading: InkWell(
      //       onTap: () {
      //         Navigator.pop(context);
      //       },
      //       child: Icon(
      //         Icons.arrow_back,
      //         color: Colors.white,
      //       )),
      // ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 59, 77, 239),
        title: Text(
          "${widget.title}",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: Stack(
        children: [
          Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("assets/back.png"),
                    fit: BoxFit.fill)),
          ),
          SingleChildScrollView(
            child: Consumer<Controller>(
              builder:
                  (BuildContext context, Controller value, Widget? child) =>
                      Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: GestureDetector(
                  //     onTap: () async {
                  //       Provider.of<Controller>(context, listen: false)
                  //           .getProductBatchList(context, widget.id);
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => BatchDataList(
                  //               scrollController: _scrollController,
                  //               id: widget.id,
                  //               context: context),
                  //         ),
                  //       );
                  //     },
                  //     child: Text(
                  //       'Batch',
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.white,
                  //         fontSize: 17,
                  //         decoration: TextDecoration.underline,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Divider(
                  //   color: Colors.grey,
                  //   thickness: 1,
                  // ),
                  value.isLoading
                      ? SpinKitCircle(
                          color: Colors.black,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: size.height * 0.9,
                            child: REport_Table(
                              scrollController: _scrollController,
                              id: widget.id,
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

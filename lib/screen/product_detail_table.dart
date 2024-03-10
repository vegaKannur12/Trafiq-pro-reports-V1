import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/controller/controller.dart';

class REport_Table extends StatefulWidget {
  ScrollController scrollController;
  int id;
  REport_Table({super.key, required this.scrollController, required this.id});

  @override
  State<REport_Table> createState() => _REport_TableState();
}

class _REport_TableState extends State<REport_Table> {
  Map<String, dynamic> mapTabledata = {};
  List<String> tableColumn = [];
  Map<String, dynamic> valueMap = {};
  List<Map<dynamic, dynamic>> newMp = [];
  List<dynamic> rowMap = [];
  double? datatbleWidth;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Consumer<Controller>(
        builder: (context, value, child) => Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              // physics: ScrollPhysics(),
              shrinkWrap: true,
              // itemCount: value.dashboard_report.length,
              itemCount: value.productdetail_report.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // print("producttttttt.......${value.productdetail_report[index]}");
                    multipleValueContainer(
                        size, value.productdetail_report[index], widget.id),

                    // Text(value.productdetail_report[index]["PRODUCT_NAME"]
                    //     .toString())
                  ],
                );
              },
            ),
            ////////////////////////////////////////////////
            value.batch_report.length == 0
                ? Visibility(
                    child: Text(
                      "BATCH",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.yellow),
                    ),
                    visible: false,
                  )
                : Text(
                    "BATCH",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.yellow, fontSize: 18),
                  ),
            // Text("${value.branch_list[0]}"),
            value.isProLoading
                ? SpinKitCircle(
                    color: Colors.black,
                  )
                : ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: value.batch_report.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          // print("producttttttt.......${value.productdetail_report[index]}");
                          multipleValueContainer2(
                              size, value.batch_report[index]),
                          // Text(value.productdetail_report[index]["PRODUCT_NAME"]
                          //     .toString())
                        ],
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  /////////////////////////////////////////////////////////////////

  Widget multipleValueContainer(Size size, Map<String, dynamic> map, int id) {
    List<Map<String, dynamic>> valueMap = [];
    map.entries.forEach((e) => valueMap.add({e.key: e.value}));
    print("product values bar-------$map...........$valueMap");

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // width: (size.width * 0.8) * len,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: valueMap
                        .map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  VerticalDivider(
                                    color: Colors.transparent,
                                  ),
                                  Column(
                                    // crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                          "${item.keys.first.toString().toUpperCase()} :",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 14)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(item.values.first.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              // fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 200, 193, 243),
                                              fontSize: 14))
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: Colors.transparent,
                                  )
                                ],
                              ),
                            ))
                        .toList()),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget multipleValueContainer2(Size size, Map<String, dynamic> map) {
    List<Map<String, dynamic>> valueMap = [];
    map.entries.forEach((e) => valueMap.add({e.key: e.value}));
    print("batch values bar-------$map...........$valueMap");

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Color.fromARGB(255, 93, 67, 92),
        // Color.fromARGB(255, 85, 60, 84),
        elevation: 5.0,
        child: Container(
          // color: Color.fromARGB(255, 49, 48, 48),
          // width: (size.width * 0.8) * len,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Divider(
              //   color: Colors.pink,
              // ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: valueMap
                          .map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    VerticalDivider(
                                      color: Colors.transparent,
                                    ),
                                    Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                            "${item.keys.first.toString().toUpperCase()} :",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 14)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(item.values.first.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 242, 230, 125)))
                                      ],
                                    ),
                                    VerticalDivider(
                                      color: Colors.transparent,
                                    )
                                  ],
                                ),
                              ))
                          .toList()),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}

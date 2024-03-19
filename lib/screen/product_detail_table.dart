import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/controller/controller.dart';
import 'package:trafiqpro/screen/detailtable.dart';
import 'package:trafiqpro/screen/tabledata.dart';

class REport_Table extends StatefulWidget {
  ScrollController scrollController;
  int id;
  BuildContext context;
  REport_Table(
      {super.key,
      required this.scrollController,
      required this.id,
      required this.context});

  @override
  State<REport_Table> createState() => _REport_TableState();
}

class _REport_TableState extends State<REport_Table> {
  // DetailedInfoSheet info = DetailedInfoSheet();

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
    Provider.of<Controller>(context, listen: false)
        .getProductBatchList(context, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Consumer<Controller>(
        builder: (context, value, child) => Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            value.isProdetailLoading
                ? SpinKitCircle(
                    color: Colors.transparent,
                  )
                : ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    // physics: ScrollPhysics(),
                    shrinkWrap: true,
                    // itemCount: value.dashboard_report.length,
                    itemCount: value.productdetail_report.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Color.fromARGB(255, 38, 46, 71),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // print("producttttttt.......${value.productdetail_report[index]}");
                            multipleValueContainer(size,
                                value.productdetail_report[index], widget.id),

                            // Text(value.productdetail_report[index]["PRODUCT_NAME"]
                            //     .toString())
                          ],
                        ),
                      );
                    },
                  ),
            SizedBox(
              height: 40,
            ),
//////////////////////////////batch data/////////////////////////////////
            value.isBatchLoading
                ? SpinKitCircle(
                    color: Colors.white,
                  )
                : value.batch_report.length == 0
                    ? Container(
                        alignment: Alignment.center,
                        height: size.height * 0.5,
                        child: Text(
                          "No batch data !!!",
                          style:
                              TextStyle(color: Colors.grey[300], fontSize: 15),
                        ))
                    : SingleChildScrollView(
                        // child: DetaildDataTable(),
                        child:
                            //  DetaildDataTable(
                            //     // decodd: jsonEncoded,
                            //     ),
                            TableDataval(
                          decodd: value.batch_report_json,
                          keyVal: "1",
                          popuWidth: width,
                          level: 1,
                          title: "BATCH",
                          rpt_key: "1",
                        ),
                      ),
            // DetaildDataTable(
            //     // decodd: jsonEncoded,
            //     ),
            // SingleChildScrollView(
            //   child:
            // )
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
        // color: Color.fromARGB(255, 129, 118, 85),
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
                                              fontFamily: 'Oswald',
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
                                                  255, 236, 223, 127),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold))
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
          // border: Border.all(color: Colors.grey),
        ),
      ),
    );
  }
////////////////////////////////////////////////////
}

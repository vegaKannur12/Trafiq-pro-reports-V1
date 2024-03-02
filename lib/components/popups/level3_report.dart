import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/components/date_find.dart';
import 'package:trafiqpro/components/table_data.dart';

import '../../controller/controller.dart';

class Level3ReportDetails {
  Color parseColor(String color) {
    print("Colorrrrr...$color");
    String hex = color.replaceAll("#", "");
    if (hex.isEmpty) hex = "ffffff";
    if (hex.length == 3) {
      hex =
          '${hex.substring(0, 1)}${hex.substring(0, 1)}${hex.substring(1, 2)}${hex.substring(1, 2)}${hex.substring(2, 3)}${hex.substring(2, 3)}';
    }
    Color col = Color(int.parse(hex, radix: 16)).withOpacity(1.0);
    return col;
  }

  Future viewData(BuildContext context, Map map, String val, String rpt_key) {
    print("level 3-------map ------$rpt_key-------$map");
    DateFind dateFind = DateFind();
    String? todaydate;
    DateTime now = DateTime.now();
    todaydate = DateFormat('dd-MM-yyyy').format(now);
    Size size = MediaQuery.of(context).size;
    double appbarHeight = AppBar().preferredSize.height;

    var width = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            contentPadding: EdgeInsets.all(8),
            insetPadding: EdgeInsets.all(8),
            //  backgroundColor: Colors.grey[200],
            title: Consumer<Controller>(
              builder:
                  (BuildContext context, Controller value, Widget? child) =>
                      Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    map["Sub_Caption"],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  InkWell(
                      onTap: () {
                        Provider.of<Controller>(context, listen: false)
                            .splitParametr("3");

                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: parseColor(value.colorString!),
                      ))
                ],
              ),
            ),
            content: Builder(
              builder: (context) {
                return Consumer<Controller>(
                  builder: (context, value, child) => Container(
                    // color: Colors.black,
                    width: width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                val.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        value.isl3SubReportLoading
                            ? SpinKitCircle(
                                color: Colors.black,
                              )
                            : value.sub_report_data.length == 0
                                ? Center(
                                    child: Text(
                                      "No Data",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  )
                                : Expanded(
                                    child: Container(
                                      // height: size.height * 0.5,
                                      // color: Colors.white,
                                      child: TableData(
                                        decodd: value.l3_sub_report_data_json,
                                        keyVal: "0",
                                        popuWidth: width,
                                        level: 3,
                                        title: val,
                                        rpt_key: rpt_key.toString(),
                                      ),
                                    ),
                                  )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}

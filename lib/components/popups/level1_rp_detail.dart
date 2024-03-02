import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/components/date_find.dart';
import 'package:trafiqpro/components/table_data.dart';

import '../../controller/controller.dart';

class Level1ReportDetails {
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

  Future viewData(BuildContext context, Map<String, dynamic> map, int rpt_key) {
    // Map report_data = {
    //   "id": "3",
    //   "title": "SALES",
    //   "graph": "0",
    //   "sum": "NY",
    //   "align": 'LR',
    //   "width": "60,40",
    //   "search": "0",
    //   "data": [
    //     {"DESCRIPTION": "CASH SALES", 'VALUE': "0"},
    //     {"DESCRIPTION": "CREDIT SALES", "VALUE": "0"},
    //     {"DESCRIPTION": "CARD SALES", "VALUE": "0"},
    //     {"DESCRIPTION": "WALLET,OTHER SALES", "VALUE": "0"}
    //   ]
    // };
    // var jsonEncoded = jsonEncode(report_data);

    print("single map----$rpt_key-$map");
    DateFind dateFind = DateFind();
    Size size = MediaQuery.of(context).size;
    var width = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            // backgroundColor: parseColor(map["Rpt_ColorId"]),
            contentPadding: EdgeInsets.all(8),
            insetPadding: EdgeInsets.all(8),
            //  backgroundColor: Colors.grey[200],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    map["Rpt_Name"],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child:
                      Icon(Icons.close, color: parseColor(map["Rpt_ColorId"])),
                ),
              ],
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
                        Container(
                          height: size.height * 0.1,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    map["Rpt_MultiDt"] == 0 ||
                                            map["Rpt_MultiDt"] == 1
                                        ? Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    dateFind.selectDateFind(
                                                        context, "from date");
                                                  },
                                                  icon: const Icon(
                                                    Icons.calendar_month,
                                                    // color: P_Settings.loginPagetheme,
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 0),
                                                child: Text(
                                                  value.fromDate == null
                                                      ? value.lastdate
                                                          .toString()
                                                      : value.fromDate
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[700],
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    map["Rpt_MultiDt"] == 1
                                        ? Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    dateFind.selectDateFind(
                                                        context, "to date");
                                                  },
                                                  icon: Icon(
                                                      Icons.calendar_month)),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 0.0),
                                                child: Text(
                                                  value.todate == null
                                                      ? value.lastdate
                                                          .toString()
                                                      : value.todate.toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    Flexible(
                                        child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: size.height * 0.05,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              parseColor(map["Rpt_ColorId"]),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                2), // <-- Radius
                                          ),
                                        ),
                                        onPressed: () {
                                          String df;
                                          String tf;

                                          if (value.fromDate == null) {
                                            value.fromDate =
                                                value.lastdate.toString();
                                          } else {
                                            value.fromDate =
                                                value.fromDate.toString();
                                          }
                                          if (value.todate == null) {
                                            value.todate =
                                                value.lastdate.toString();
                                          } else {
                                            value.todate =
                                                value.todate.toString();
                                          }
                                          value.getReportTabledata(
                                              context,
                                              map["Rpt_Script"],
                                              value.fromDate.toString(),
                                              value.todate.toString(),
                                              map["Rpt_MultiDt"]);
                                        },
                                        child: const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        value.isReportLoading
                            ? SpinKitCircle(
                                color: Colors.black,
                              )
                            : value.report_data.length == 0
                                ? Center(
                                    child: Text(
                                      "No Data Found!!!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  )
                                : Expanded(
                                    child: TableData(
                                      decodd: value.jsonEncoded,
                                      keyVal: "1",
                                      popuWidth: width,
                                      level: 1,
                                      title: "",
                                      rpt_key: rpt_key.toString(),
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

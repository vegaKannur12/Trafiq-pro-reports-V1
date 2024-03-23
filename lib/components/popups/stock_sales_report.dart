import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/components/date_find.dart';
import 'package:trafiqpro/controller/controller.dart';
import 'package:trafiqpro/screen/tabledata.dart';

class SalesStockReport {
  Future viewData(BuildContext context) {
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
                    "Stock & Sales",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color.fromARGB(255, 16, 32, 46)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close, color: Colors.black),
                ),
              ],
            ),
            content: Builder(
              builder: (context) {
                return Consumer<Controller>(
                  builder: (context, value, child) {
                    return Container(
                      // color: Colors.black,
                      width: width,
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          value.issalesLoading
                              ? SpinKitCircle(
                                  color: Colors.black,
                                )
                              : Expanded(
                                  child: TableDataval(
                                    decodd: value.sales_stock_json,
                                    keyVal: "1",
                                    popuWidth: width,
                                    level: 1,
                                    title: "Stock",
                                    rpt_key: "1",
                                  ),
                                )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          );
        });
  }
}

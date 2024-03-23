import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/controller/controller.dart';

import 'package:trafiqpro/screen/1_product_details.dart';
import 'package:trafiqpro/screen/design_test.dart';
import 'package:trafiqpro/screen/design_test2.dart';
import 'package:trafiqpro/screen/design_test3.dart';
import 'package:trafiqpro/screen/stock_sales.dart';

class CustomPopup {
  String? gen_condition;

  Widget buildPopupDialog(BuildContext context, String content1,
      String content2, String fromDate, String todate) {
    return Consumer(
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.only(top: 50),
        child: AlertDialog(
          alignment: Alignment.topCenter,
          backgroundColor: Colors.black,
          shadowColor: Colors.black,
          // title: const Text('Popup example'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Text("${content}"),
            ],
          ),
          actions: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  // height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(
                          255, 201, 198, 198), // background (button) color
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Product_DetailList(
                                  context: context,
                                )),
                      );
                      // Navigator.of(context).pop();
                    },
                    // textColor: Theme.of(context).primaryColor,
                    child: Text(
                      '${content1}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  // height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(
                          255, 201, 198, 198), // background (button) color
                    ),
                    onPressed: () {
                      Provider.of<Controller>(context, listen: false)
                          .getSalesStock(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Sales_Stock(
                                  context: context,
                                )),
                      );
                    },
                    // textColor: Theme.of(context).primaryColor,
                    child: Text(
                      '${content2}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // child:
    );
  }
}

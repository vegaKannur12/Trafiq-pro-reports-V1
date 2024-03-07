import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/controller/controller.dart';
import 'package:trafiqpro/screen/batch_data.dart';
import 'package:trafiqpro/screen/product_details.dart';

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
                      print("product detail page");
                      Provider.of<Controller>(context, listen: false)
                          .getCustomerList(
                        context,
                        fromDate,
                        todate,
                        0,
                      );
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(
                          255, 201, 198, 198), // background (button) color
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Batch_data()),
                      );
                      // Navigator.of(context).pop();
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
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/components/date_find.dart';
import 'package:trafiqpro/controller/controller.dart';
import 'package:trafiqpro/screen/ledger_report.dart';

class CustomerList extends StatefulWidget {
  Map<String, dynamic> map = {};
  CustomerList({required this.map});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  DateFind dateFind = DateFind();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController seacrh = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Consumer<Controller>(
            builder: (BuildContext context, Controller value, Widget? child) =>
                AppBar(
              backgroundColor: parseColor(value.colorString!),
              title: Text(
                "Select Account Heads",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
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
          ),
        ),
        body: Consumer<Controller>(
          builder: (context, value, child) => Column(
            children: [
              // Container(
              //   height: size.height * 0.1,
              //   color: Colors.white,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             widget.map["Rpt_MultiDt"] == 0 ||
              //                     widget.map["Rpt_MultiDt"] == 1
              //                 ? Row(
              //                     children: [
              //                       IconButton(
              //                           onPressed: () {
              //                             dateFind.selectDateFind(
              //                                 context, "from date");
              //                           },
              //                           icon: const Icon(
              //                             Icons.calendar_month,
              //                             // color: P_Settings.loginPagetheme,
              //                           )),
              //                       Padding(
              //                         padding: const EdgeInsets.only(right: 0),
              //                         child: Text(
              //                           value.fromDate == null
              //                               ? value.lastdate.toString()
              //                               : value.fromDate.toString(),
              //                           style: TextStyle(
              //                             fontWeight: FontWeight.bold,
              //                             color: Colors.grey[700],
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   )
              //                 : Container(),
              //             widget.map["Rpt_MultiDt"] == 1
              //                 ? Row(
              //                     children: [
              //                       IconButton(
              //                           onPressed: () {
              //                             dateFind.selectDateFind(
              //                                 context, "to date");
              //                           },
              //                           icon: Icon(Icons.calendar_month)),
              //                       Padding(
              //                         padding:
              //                             const EdgeInsets.only(right: 10.0),
              //                         child: Text(
              //                           value.todate == null
              //                               ? value.lastdate.toString()
              //                               : value.todate.toString(),
              //                           style: TextStyle(
              //                             fontWeight: FontWeight.bold,
              //                             color: Colors.grey[700],
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   )
              //                 : Container(),
              //             Flexible(
              //                 child: Container(
              //               margin: EdgeInsets.only(top: 10),
              //               height: size.height * 0.05,
              //               child: ElevatedButton(
              //                   style: ElevatedButton.styleFrom(
              //                     primary: Color.fromARGB(255, 48, 4, 243),
              //                     shape: RoundedRectangleBorder(
              //                       borderRadius:
              //                           BorderRadius.circular(2), // <-- Radius
              //                     ),
              //                   ),
              //                   onPressed: () {
              //                     String df;
              //                     String tf;

              //                     if (value.fromDate == null) {
              //                       value.fromDate = value.lastdate.toString();
              //                     } else {
              //                       value.fromDate = value.fromDate.toString();
              //                     }
              //                     if (value.todate == null) {
              //                       value.todate = value.lastdate.toString();
              //                     } else {
              //                       value.todate = value.todate.toString();
              //                     }
              //                     value.getCustomerList(
              //                       context,
              //                       value.fromDate.toString(),
              //                       value.todate.toString(),
              //                       widget.map["Rpt_MultiDt"],
              //                     );
              //                   },
              //                   child: Text(
              //                     "Apply",
              //                     style: TextStyle(
              //                         fontWeight: FontWeight.bold,
              //                         color: Colors.white,
              //                         fontSize: 16),
              //                   )),
              //             ))
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height * 0.05,
                  child: TextField(
                    controller: seacrh,
                    onChanged: (v) => value.searchCustomerList(v),
                    decoration: new InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 18),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        hintText: 'search here',
                        hintStyle: TextStyle(fontSize: 13),
                        suffixIcon: InkWell(
                          onTap: () {
                            seacrh.clear();
                            value.setIsSearch(false);
                          },
                          child: Icon(
                            Icons.close,
                            size: 19,
                          ),
                        ),
                        ),
                  ),
                ),
              ),
              value.isCusLoading
                  ? SpinKitCircle(
                      color: Colors.black,
                    )
                  : Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: value.isSearch
                              ? value.filteredList.length
                              : value.customer_list.length,
                          itemBuilder: (context, int index) {
                            return ListTile(
                              onTap: () {
                                String id;
                                String title;
                                print(
                                    "bhsbhd---------${value.customer_list[index]}");
                                if (value.isSearch) {
                                  id = value.filteredList[index]["Acc_ID"]
                                      .toString();
                                  print("djknjfnjf-----$id");
                                  title = value.filteredList[index]["Head"]
                                      .toString();
                                } else {
                                  id = value.customer_list[index]["Acc_ID"]
                                      .toString();
                                  title = value.customer_list[index]["Head"]
                                      .toString();
                                }

                                value.getLedger(
                                  context,
                                  value.fromDate.toString(),
                                  value.todate.toString(),
                                  widget.map["Rpt_Script"],
                                  id,
                                  widget.map["Rpt_MultiDt"],
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LedgerReport(
                                            map: widget.map,
                                            id: id,
                                            title: title,
                                          )),
                                );
                              },
                              trailing: value.isSearch
                                  ? value.filteredList[index]["Balance"] ==
                                              null ||
                                          value.filteredList[index]
                                                  ["Balance"] ==
                                              0.0
                                      ? SizedBox()
                                      : Wrap(
                                          children: [
                                            Text(
                                              value.filteredList[index]
                                                          ["Balance"] <
                                                      0
                                                  ? (value.filteredList[index]
                                                              ["Balance"] *
                                                          -1)
                                                      .toStringAsFixed(2)
                                                  : value.filteredList[index]
                                                          ["Balance"]
                                                      .toStringAsFixed(2),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: value.filteredList[index]
                                                            ["Balance"] <
                                                        0
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              value.filteredList[index]
                                                          ["Balance"] <
                                                      0
                                                  ? "Cr"
                                                  : "Db",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                  // color: item["Amount"] < 0 ? Colors.red : Colors.green,
                                                  fontSize: 15),
                                            )
                                          ],
                                        )
                                  : value.customer_list[index]["Balance"] ==
                                              null ||
                                          value.customer_list[index]
                                                  ["Balance"] ==
                                              0.0
                                      ? SizedBox()
                                      : Wrap(
                                          children: [
                                            Text(
                                              value.customer_list[index]
                                                          ["Balance"] <
                                                      0
                                                  ? (value.customer_list[index]
                                                              ["Balance"] *
                                                          -1)
                                                      .toStringAsFixed(2)
                                                  : value.customer_list[index]
                                                          ["Balance"]
                                                      .toStringAsFixed(2),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    value.customer_list[index]
                                                                ["Balance"] <
                                                            0
                                                        ? Colors.red
                                                        : Colors.green,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              value.customer_list[index]
                                                          ["Balance"] <
                                                      0
                                                  ? "Cr"
                                                  : "Db",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                  // color: item["Amount"] < 0 ? Colors.red : Colors.green,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                              leading: CircleAvatar(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                backgroundColor: value.isSearch
                                    ? value.filteredList[index]["Balance"] < 0
                                        ? Colors.red
                                        : Colors.green
                                    : value.customer_list[index]["Balance"] < 0
                                        ? Colors.red
                                        : Colors.green,
                              ),
                              title: Text(
                                value.isSearch
                                    ? value.filteredList[index]["Head"]
                                    : value.customer_list[index]["Head"],
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            );
                          }),
                    ),
            ],
          ),
        ));
  }

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
}

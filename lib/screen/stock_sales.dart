import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/components/date_find.dart';
import 'package:trafiqpro/controller/controller.dart';

class Sales_Stock extends StatefulWidget {
  const Sales_Stock({super.key});

  @override
  State<Sales_Stock> createState() => _Sales_StockState();
}

class _Sales_StockState extends State<Sales_Stock> {
  final _formKey = GlobalKey<FormState>();

  String? selected;
  String? todaydate;
  DateTime now = DateTime.now();
  ScrollController _scrollController = ScrollController();
  TextEditingController itemname = TextEditingController();
  TextEditingController packing = TextEditingController();
  @override
  Widget build(BuildContext context) {
    DateFind dateFind = DateFind();

    Size size = MediaQuery.of(context).size;
    double topInsets = MediaQuery.of(context).viewInsets.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<Controller>(
        builder: (context, value, child) => Stack(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Stock & Sales",
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
              top: 100,
              child: SingleChildScrollView(
                child: Container(
                  height: 470,
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
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 8, left: 8, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Branch/Location",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        letterSpacing: 1),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: ButtonTheme(
                                      // alignedDropdown: true,
                                      child: DropdownButton<String>(
                                        value: selected,
                                        // isDense: true,
                                        hint: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 9.0),
                                          child: Text(
                                            value.selected.toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ),
                                        isExpanded: false,
                                        autofocus: false,
                                        underline: SizedBox(),
                                        elevation: 0,
                                        items: value.branch_list
                                            .map((item) => DropdownMenuItem<
                                                    String>(
                                                value: item["Br_ID"].toString(),
                                                child: Container(
                                                  // width: size.width * 0.4,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 9.0),
                                                    child: Text(
                                                      item["Br_Name"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.blue),
                                                    ),
                                                  ),
                                                )))
                                            .toList(),
                                        onChanged: (item) {
                                          print("clicked");
                                          String? date;
                                          if (item != null) {
                                            if (value.dashDate == null) {
                                              date = todaydate.toString();
                                            } else {
                                              date = value.dashDate.toString();
                                            }
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .setDropdowndata(
                                                    item.toString(),
                                                    date.toString(),
                                                    context);
                                            print("clicked------$item");
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Item Group",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        letterSpacing: 1),
                                  ),
                                  Container(
                                    // width: size.width * 0.45,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    // width: size.width * 0.4,
                                    // height: size.height * 0.04,

                                    child: ButtonTheme(
                                      // alignedDropdown: true,
                                      child: DropdownButton<String>(
                                        value: selected,
                                        // isDense: true,
                                        hint: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 9.0),
                                          child: Text(
                                            value.selected.toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ),
                                        isExpanded: false,
                                        autofocus: false,
                                        underline: SizedBox(),
                                        elevation: 0,
                                        items: value.branch_list
                                            .map((item) => DropdownMenuItem<
                                                    String>(
                                                value: item["Br_ID"].toString(),
                                                child: Container(
                                                  // width: size.width * 0.4,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 9.0),
                                                    child: Text(
                                                      item["Br_Name"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.blue),
                                                    ),
                                                  ),
                                                )))
                                            .toList(),
                                        onChanged: (item) {
                                          print("clicked");
                                          String? date;
                                          if (item != null) {
                                            if (value.dashDate == null) {
                                              date = todaydate.toString();
                                            } else {
                                              date = value.dashDate.toString();
                                            }
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .setDropdowndata(
                                                    item.toString(),
                                                    date.toString(),
                                                    context);
                                            print("clicked------$item");
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Company",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        letterSpacing: 1),
                                  ),
                                  Container(
                                    // width: size.width * 0.45,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    // width: size.width * 0.4,
                                    // height: size.height * 0.04,

                                    child: ButtonTheme(
                                      // alignedDropdown: true,
                                      child: DropdownButton<String>(
                                        value: selected,
                                        // isDense: true,
                                        hint: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 9.0),
                                          child: Text(
                                            value.selected.toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ),
                                        isExpanded: false,
                                        autofocus: false,
                                        underline: SizedBox(),
                                        elevation: 0,
                                        items: value.branch_list
                                            .map((item) => DropdownMenuItem<
                                                    String>(
                                                value: item["Br_ID"].toString(),
                                                child: Container(
                                                  // width: size.width * 0.4,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 9.0),
                                                    child: Text(
                                                      item["Br_Name"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.blue),
                                                    ),
                                                  ),
                                                )))
                                            .toList(),
                                        onChanged: (item) {
                                          print("clicked");
                                          String? date;
                                          if (item != null) {
                                            if (value.dashDate == null) {
                                              date = todaydate.toString();
                                            } else {
                                              date = value.dashDate.toString();
                                            }
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .setDropdowndata(
                                                    item.toString(),
                                                    date.toString(),
                                                    context);
                                            print("clicked------$item");
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Category",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        letterSpacing: 1),
                                  ),
                                  Container(
                                    // width: size.width * 0.45,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    // width: size.width * 0.4,
                                    // height: size.height * 0.04,

                                    child: ButtonTheme(
                                      // alignedDropdown: true,
                                      child: DropdownButton<String>(
                                        value: selected,
                                        // isDense: true,
                                        hint: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 9.0),
                                          child: Text(
                                            value.selected.toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ),
                                        isExpanded: false,
                                        autofocus: false,
                                        underline: SizedBox(),
                                        elevation: 0,
                                        items: value.branch_list
                                            .map((item) => DropdownMenuItem<
                                                    String>(
                                                value: item["Br_ID"].toString(),
                                                child: Container(
                                                  // width: size.width * 0.4,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 9.0),
                                                    child: Text(
                                                      item["Br_Name"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.blue),
                                                    ),
                                                  ),
                                                )))
                                            .toList(),
                                        onChanged: (item) {
                                          print("clicked");
                                          String? date;
                                          if (item != null) {
                                            if (value.dashDate == null) {
                                              date = todaydate.toString();
                                            } else {
                                              date = value.dashDate.toString();
                                            }
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .setDropdowndata(
                                                    item.toString(),
                                                    date.toString(),
                                                    context);
                                            print("clicked------$item");
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: itemname,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: "Item Name",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Packing [1,10,...]",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          letterSpacing: 1),
                                    ),
                                    TextFormField(
                                      controller: packing,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        // hintText: "Item Name",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          // height: size.height * 0.1,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              dateFind
                                                                  .selectDateFind(
                                                                      context,
                                                                      "from date");
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .calendar_month,
                                                              // color: P_Settings.loginPagetheme,
                                                            )),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 0),
                                                          child: Text(
                                                            value.fromDate ==
                                                                    null
                                                                ? value.lastdate
                                                                    .toString()
                                                                : value.fromDate
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .grey[700],
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                        ////////////////////////////
                                                        IconButton(
                                                            onPressed: () {
                                                              dateFind
                                                                  .selectDateFind(
                                                                      context,
                                                                      "to date");
                                                            },
                                                            icon: Icon(Icons
                                                                .calendar_month)),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 0.0),
                                                          child: Text(
                                                            value.todate == null
                                                                ? value.lastdate
                                                                    .toString()
                                                                : value.todate
                                                                    .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[700],
                                                            ),
                                                          ),
                                                        ),
                                                        /////////////////
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TextButton(
                                                    style: TextButton.styleFrom(
                                                      // primary: Colors.purpleAccent,
                                                      backgroundColor: Colors
                                                          .blue, // Background Color
                                                    ),
                                                    onPressed: () async {},
                                                    child: Text(
                                                      "View",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

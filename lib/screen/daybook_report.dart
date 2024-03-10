import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/components/date_find.dart';
import 'package:trafiqpro/components/popups/level1_rp_detail.dart';
import 'package:trafiqpro/controller/controller.dart';

class DaybookReports extends StatefulWidget {
  Map<String, dynamic> map = {};
  DaybookReports({required this.map});

  @override
  State<DaybookReports> createState() => _DaybookReportsState();
}

class _DaybookReportsState extends State<DaybookReports> {
  DateFind dateFind = DateFind();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // ScrollController _scrollController = new ScrollController();

  // var key1 = GlobalKey();
  // var key2 = GlobalKey();

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
              "Daybook",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
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
      body: SingleChildScrollView(
        // controller: _scrollController,
        child: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) =>
              Column(
            children: [
              Container(
                // key: key1,
                height: size.height * 0.1,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.map["Rpt_MultiDt"] == 0 ||
                                  widget.map["Rpt_MultiDt"] == 1
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
                                      padding: const EdgeInsets.only(right: 0),
                                      child: Text(
                                        value.fromDate == null
                                            ? value.lastdate.toString()
                                            : value.fromDate.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          widget.map["Rpt_MultiDt"] == 1
                              ? Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          dateFind.selectDateFind(
                                              context, "to date");
                                        },
                                        icon: Icon(Icons.calendar_month)),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        value.todate == null
                                            ? value.lastdate.toString()
                                            : value.todate.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
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
                                      parseColor(value.colorString!),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(2), // <-- Radius
                                  ),
                                ),
                                onPressed: () {
                                  String df;
                                  String tf;

                                  if (value.fromDate == null) {
                                    value.fromDate = value.lastdate.toString();
                                  } else {
                                    value.fromDate = value.fromDate.toString();
                                  }
                                  if (value.todate == null) {
                                    value.todate = value.lastdate.toString();
                                  } else {
                                    value.todate = value.todate.toString();
                                  }

                                  value.getdaybookReportTabledata(
                                    context,
                                    widget.map["Rpt_Script"],
                                    value.fromDate.toString(),
                                    value.todate.toString(),
                                    widget.map["Rpt_MultiDt"],
                                    0,
                                  );
                                },
                                child: Icon(
                                  Icons.done,
                                  color: Colors.white,
                                )),
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Divider(),

              value.isReportLoading
                  ? SpinKitCircle(
                      color: Colors.black,
                    )
                  : value.listWidget.length == 0
                      ? Container(
                          alignment: Alignment.center,
                          height: size.height * 0.7,
                          child: LottieBuilder.asset(
                            "assets/noData.json",
                            height: size.height * 0.23,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            // key: key2,
                            color: Colors.white,
                            child: ListView.builder(
                                // controller: _scrollController,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: value.listWidget.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    child: Container(
                                        // color: Colors.red,

                                        child: value.listWidget[index]),
                                  );
                                }),
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }

  Color parseColor(String color) {
    // print("Colorrrrr...$color");
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

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/controller/controller.dart';

class DashboardReport extends StatefulWidget {
  ScrollController scrollController;
  DashboardReport({super.key, required this.scrollController});

  @override
  State<DashboardReport> createState() => _DashboardReportState();
}

class _DashboardReportState extends State<DashboardReport> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      double minExtent = _scrollController.position.minScrollExtent;
      double maxExtent = _scrollController.position.maxScrollExtent;
      animatetoMaxmin(maxExtent, minExtent, maxExtent, _scrollController);
      // Provider.of<Controller>(context, listen: false).getBranches(
      //   context,
      // );
      // Provider.of<Controller>(context, listen: false).getDbName();
    });
  }

  animatetoMaxmin(double max, double min, double direction,
      ScrollController scrollController) {
    scrollController.animateTo(direction,
        duration: Duration(seconds: 10), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<Controller>(
      builder: (context, value, child) => Column(
        children: [
          Container(
            height: size.height * 0.23,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              // physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: value.dashboard_report.length,
              itemBuilder: (context, index) {
                // print("sfjknkjdfnd-${value.dashboard_report[index]}");
                if (value.dashboard_report[index]["values"].length > 0) {
                  if (value.dashboard_report[index]["values"][0].length == 1) {
                    return singlevalContainer(
                        size, value.dashboard_report[index]);
                  } else {
                    print(
                        "cbjhzdbhzcb----${value.dashboard_report[index]["values"]}");
                    return multipleValueContainer(
                        size, value.dashboard_report[index]);
                  }
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromARGB(255, 12, 155, 250),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              value.dashboard_report[index]["Rpt_Name"]
                                  .toString()
                                  .toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget singlevalContainer(Size size, Map<String, dynamic> map) {
    Map<String, dynamic> valueMap = map["values"][0];
    // print("values-------$valueMap");
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FittedBox(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: parseColor(map["Rpt_ColorId"])),
          // gradient: LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   colors: [
          //     Color.fromARGB(124, 250, 59, 225),
          //     Color.fromARGB(255, 12, 155, 250),
          //   ],
          // )),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage("assets/${map["Rpt_ImgID"]}.png"),
                    ),
                    //  Image.asset(
                    //                   "assets/${list[ind]["Rpt_ImgID"]}.png",
                    //                   height: size.height * 0.04,
                    //                 ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Text(
                      map["Rpt_Name"].toString().toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.white,
                  height: 6,
                ),
                SizedBox(
                  height: size.height * 0.004,
                ),
                Text(valueMap.values.first.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget multipleValueContainer(Size size, Map<String, dynamic> map) {
    List<Map<String, dynamic>> valueMap = [];
    map["values"][0].entries.forEach((e) => valueMap.add({e.key: e.value}));
    // print("values-------$map");

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // width: (size.width * 0.8) * len,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 18.0, right: 18, top: 8, bottom: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        AssetImage("assets/${map["Rpt_ImgID"]}.png"),
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Text(
                    map["Rpt_Name"].toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ],
              ),
              Divider(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: valueMap
                      .map((item) => Row(
                            children: [
                              VerticalDivider(
                                color: Colors.transparent,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(item.keys.first.toString().toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 250, 225, 3),
                                          fontSize: 14)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(item.values.first.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 17))
                                ],
                              ),
                              VerticalDivider(
                                color: Colors.transparent,
                              )
                            ],
                          ))
                      .toList()),
            ],
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: parseColor(map["Rpt_ColorId"])
            // gradient: LinearGradient(
            //   begin: Alignment.topRight,
            //   end: Alignment.bottomLeft,
            //   colors: [
            //     Color.fromARGB(255, 233, 62, 167),
            //     const Color.fromARGB(255, 1, 138, 250),
            //   ],

            // ),
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

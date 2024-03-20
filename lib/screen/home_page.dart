import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:trafiqpro/components/popups/dashboard_popup.dart';
import 'package:trafiqpro/controller/registration_controller.dart';
import 'package:trafiqpro/screen/daybook_report.dart';
import 'package:trafiqpro/screen/report_tabs.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../controller/controller.dart';
import 'dahsboard_report_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selected;
  String? todaydate;
  DateTime now = DateTime.now();
  ScrollController _scrollController = ScrollController();
  CustomPopup popup = CustomPopup();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todaydate = DateFormat('dd-MMM-yyyy').format(now);
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    Provider.of<Controller>(context, listen: false).onRefresh(context);
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // backgroundColor: Colors.white70,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: Colors.blue[600],
        backgroundColor: parseColor("#46bdc6"),
        elevation: 0,
        centerTitle: false,
        title: Consumer<Controller>(
          builder: (context, value, child) => Text(
            value.cName.toString(),
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Consumer<Controller>(
                builder: (context, value, child) => InkWell(
                      onTap: value.db_list.length == 1
                          ? null
                          : () {
                              Navigator.pop(context);
                              // Provider.of<RegistrationController>(context,
                              //         listen: false)
                              //     .initDb(context, "");
                            },
                      child: value.yr == null
                          ? Container()
                          : Text(
                              value.yr.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    )),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Consumer<Controller>(
            builder: (context, value, child) => Column(
              children: [
                Container(
                  // height: size.height * 0.05,
                  // color: Colors.grey[200],
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      value.branch_list.length == 0
                          ? Container()
                          : Container(
                              // width: size.width * 0.45,
                              // decoration: BoxDecoration(
                              //   border: Border.all(
                              //       color: Colors.white),
                              //   borderRadius: BorderRadius.circular(28),
                              // ),
                              // width: size.width * 0.4,
                              // height: size.height * 0.04,

                              child: ButtonTheme(
                                // alignedDropdown: true,
                                child: DropdownButton<String>(
                                  value: selected,
                                  // isDense: true,
                                  hint: Padding(
                                    padding: const EdgeInsets.only(left: 9.0),
                                    child: Text(
                                      value.selected.toString(),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                  isExpanded: false,
                                  autofocus: false,
                                  underline: SizedBox(),
                                  elevation: 0,
                                  items: value.branch_list
                                      .map((item) => DropdownMenuItem<String>(
                                          value: item["Br_ID"].toString(),
                                          child: Container(
                                            // width: size.width * 0.4,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 9.0),
                                              child: Text(
                                                item["Br_Name"].toString(),
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
                                          .setDropdowndata(item.toString(),
                                              date.toString(), context);
                                      print("clicked------$item");
                                    }
                                  },
                                ),
                              ),
                            ),
                      TextButton(
                        style: TextButton.styleFrom(
                            // backgroundColor: Color.fromARGB(255, 203, 232, 142),
                            // primary: Colors.blue,
                            ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  popup.buildPopupDialog(
                                    context,
                                    "Product",
                                    todaydate.toString(),
                                    todaydate.toString(),
                                  ));
                          // Navigator.of(context).pop();
                        },
                        child: value.isLoading
                            ? SpinKitChasingDots(
                                size: 12,
                                color: Colors.white,
                              )
                            : Text(
                                '...',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 203, 232, 142),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                      ),
                      // Text("...", style: TextStyle(color: Colors.white)),

                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: value.isLoading
                            ? SpinKitChasingDots(
                                size: 12,
                                color: Colors.white,
                              )
                            : Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Provider.of<Controller>(context,
                                              listen: false)
                                          .findDate(value.d, "prev", context);
                                    },
                                    child: Image.asset("assets/left.png",
                                        height: size.height * 0.021,
                                        color: Colors.yellow),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, right: 4),
                                    child: Text(
                                      // value.dashDate
                                      value.dashDate == null
                                          ? " "
                                          : value.dashDate.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Provider.of<Controller>(context,
                                              listen: false)
                                          .findDate(value.d, "after", context);
                                    },
                                    child: Image.asset("assets/right.png",
                                        height: size.height * 0.021,
                                        color: Colors.yellow),
                                  ),
                                ],
                              ),
                      )
                    ],
                  ),
                ),
                // Divider(
                //   thickness: 1,
                //   color: Colors.white,
                //   // height: 25,
                // ),
                imageContainer(size),
                value.isLoading
                    ? Center(
                        child: SpinKitCircle(
                        color: Colors.white,
                      ))
                    : value.dashboard_report.length > 0
                        ? DashboardReport(
                            scrollController: _scrollController,
                          )
                        : Container(),
                ReportTabs(),
                SizedBox(
                  height: size.height * 0.06,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageContainer(Size size) {
    // List list=["E Pilze","Trafiq Pro","Trafiq Xp"];
    List list = [
      {"image": "assets/001.png", "project": "E Pulze"},
      {"image": "assets/005.png", "project": "Trafiq Pro"},
      {"image": "assets/002.png", "project": "Trafiq Xp"},
      // {"image": "assets/004.png", "project": "Trafiq Xp"},
    ];
    //  List list = [
    //   {"image": "assets/a.jpg", "project": "E Pulze"},
    //   {"image": "assets/b.jpg", "project": "Trafiq Pro"},
    //   {"image": "assets/c.jpg", "project": "Trafiq Xp"},
    //   // {"image": "assets/004.png", "project": "Trafiq Xp"},
    // ];

    return CarouselSlider(
      options: CarouselOptions(
          // aspectRatio: 2.6,
          viewportFraction: 1,
          // height: size.height * 0.19,
          autoPlayInterval: Duration(seconds: 2),
          autoPlay: true),
      items: list.map((i) {
        // print("dshh----$i");
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              // decoration: BoxDecoration(color: Color.fromARGB(255, 224, 76, 49)),
              child: Image.asset(
                "${i['image']}",
                fit: BoxFit.cover,
                // width: size.width * 0.9,
                // height: size.height,
              ),
            );
          },
        );
      }).toList(),
    );
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/screen/customer_list.dart';
import 'package:trafiqpro/screen/daybook_report.dart';
import '../components/popups/level1_rp_detail.dart';
import '../controller/controller.dart';

class ReportTabs extends StatefulWidget {
  const ReportTabs({super.key});

  @override
  State<ReportTabs> createState() => _ReportTabsState();
}

class _ReportTabsState extends State<ReportTabs> {
  // List report_tabs = ["sale Report", "Purchase Reports", "Stock Repports"];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<Controller>(
      builder: (context, value, child) => ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: value.report_tile_val.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => Column(
          children: [
            SizedBox(height: size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text(
                  value.report_tile_val[index].keys.first,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            Container(
              height: size.height * 0.14,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: value
                    .report_tile_val[index]
                        [value.report_tile_val[index].keys.first]
                    .length,
                itemBuilder: (context, ind) {
                  List list = value.report_tile_val[index]
                      [value.report_tile_val[index].keys.first];
                  return InkWell(
                    onTap: () {
                      value.setIsSearch(false);
                      value.getSubReport(context, list[ind]["Rpt_ID"]);
                      print("jhjhdsbd------${list[ind]}");
                      value.setColor(list[ind]["Rpt_ColorId"].toString());
                      if (list[ind]["Stat_Key"] == "DB") {
                        value.fromDate = null;
                        value.todate = null;
                        value.listWidget.clear();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DaybookReports(
                                    map: list[ind],
                                  )),
                        );
                      } else if (list[ind]["Stat_Key"] == "LG") {
                        value.fromDate = null;
                        value.todate = null;
                        value.setIsSearch(false);
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
                        Provider.of<Controller>(context, listen: false)
                            .getCustomerList(
                          context,
                          value.fromDate.toString(),
                          value.todate.toString(),
                          list[ind]["Rpt_MultiDt"],
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerList(
                                    map: list[ind],
                                  )),
                        );
                      } else {
                        value.fromDate = null;
                        value.todate = null;
                        value.report_data.clear();
                        value.todate = null;
                        value.fromDate = null;
                        print("djbjhbjhdbg------${list[ind]["Rpt_Key"]}");
                        Level1ReportDetails popup = Level1ReportDetails();
                        popup.viewData(
                            context, list[ind], list[ind]["Rpt_Key"]);
                      }
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 4.0, left: 4, top: 8),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            // gradient: LinearGradient(
                            //   begin: Alignment.bottomLeft,
                            //   end: Alignment.topRight,
                            //   // colors: [
                            //   //   const Color.fromARGB(255, 1, 138, 250),
                            //   //   parseColor(list[ind]["Rpt_ColorId"].toString()),
                            //   //   Colors.white,
                            //   // ],
                            //   // colors: [
                            //   //   Color.fromARGB(255, 224, 124, 56),
                            //   //   Color.fromARGB(255, 2, 52, 92),
                            //   // ],
                            // ),
                            color: parseColor(
                                list[ind]["Rpt_ColorId"].toString())),
                        // height: size.height * 0.04,
                        width: size.width * 0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image.asset(
                            //   "assets/3.png",
                            //   height: size.height * 0.04,
                            // ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 8,
                                  left: list[ind]["Rpt_Type"] == 2 ? 8.0 : 0,
                                  right: list[ind]["Rpt_Type"] == 2 ? 8 : 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.04,
                                  ),

                                  Image.asset(
                                    "assets/${list[ind]["Rpt_ImgID"]}.png",
                                    height: size.height * 0.04,
                                  ),
                                  // Image.asset(
                                  //   "assets/1.png",
                                  //   height: size.height * 0.04,
                                  // ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Text(
                                      list[ind]["Rpt_Name"],
                                      // "sale summary janahanahanah hhhhaa anushaa ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: list[ind]["Rpt_Type"] == 2
                                              ? Colors.white
                                              : Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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

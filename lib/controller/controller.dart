import 'dart:convert';

import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:trafiqpro/components/custom_snackbar.dart';
import 'package:trafiqpro/components/external_dir.dart';
import 'package:trafiqpro/components/popups/level1_rp_detail.dart';
import 'package:trafiqpro/components/popups/level2_report_data.dart';
import 'package:trafiqpro/components/popups/level3_report.dart';
import 'package:trafiqpro/db_helper.dart';
import 'package:trafiqpro/model/registration_model.dart';
import 'package:trafiqpro/screen/authentication/login.dart';
import 'package:trafiqpro/screen/db_selection_page.dart';
import 'package:trafiqpro/screen/home_page.dart';
import '../components/network_connectivity.dart';

class Controller extends ChangeNotifier {
  String? fromDate;
  String? lastdate;
  double bal = 0.0;
  String? cname;
  String? colorString;
  List<CD> c_d = [];
  List<Map<String, dynamic>> db_list = [];
  bool isCusLoading = false;
  bool isProLoading = false;
  bool isProdetailLoading = false;
  bool isBatchLoading = false;
  DateTime? sdate;
  DateTime? ldate;
  String? cName;
  List<Widget> calendarWidget = [];
  var l3_sub_report_data_json;
  String? yr;
  String? branchid;
  bool isSearch = false;
  String? fp;
  String? cid;
  ExternalDir externalDir = ExternalDir();

  String? sof;
  String? branchname;
  String? selected;
  var jsonEncoded;
  String poptitle = "";
  bool isDbNameLoading = false;
  String? dashDate;
  DateTime d = DateTime.now();
  String? todate;
  List<TextEditingController> listEditor = [];
  Map<String, dynamic> levelCriteria = {};
  bool isLoading = false;
  bool isReportLoading = false;
  bool isdbConnctLoading = false;

  bool isSubReportLoading = false;
  bool isl3SubReportLoading = false;
  List<Map<String, dynamic>> dashboard_report = [];
  List<Map<String, dynamic>> productdetail_report = [];
  List<Map<String, dynamic>> batch_report = [];
  List<Map<String, dynamic>> ledger = [];
  List<Map<String, dynamic>> daybook = [];
  List<Map<String, dynamic>> ledger_list = [];
  String? dbn;
  List<Widget> listWidget = [];
  List<Widget> ledgerWidget = [];
  String? appType;
  bool isdbLoading = true;

  List<Map<String, dynamic>> filteredList = [];
  List<Map<String, dynamic>> searchProduct = [];
  var result1 = <String, List<Map<String, dynamic>>>{};
  var resultList = <String, List<Map<String, dynamic>>>{};

  List<Map<String, dynamic>> report_tile_val = [];
  List<Map<String, dynamic>> list = [];

  List<Map<String, dynamic>> result = [];
  List<Map<String, dynamic>> sub_report = [];
  List<Map<String, dynamic>> report_data = [];
  List<Map<String, dynamic>> sub_report_data = [];
  List<Map<String, dynamic>> accounts_report = [];

  List<Map<String, dynamic>> branch_list = [];
  List<Map<String, dynamic>> customer_list = [];
  List<Map<String, dynamic>> productname_list = [];

  String? userName;
  List<Map<String, dynamic>> l3_sub_report_data = [];

  List<String> tableColumn = [];
  List<dynamic> rowMap = [];
  List<Map<dynamic, dynamic>> newMp = [];
  List<Map<dynamic, dynamic>> filterList = [];

  var sub_report_json;
  var batch_report_json;

  var l3_sub_report_json;
  String param = "";

  bool isLoginLoading = false;
  /////////////////////////////////////////////
  Future<RegistrationData?> postRegistration(
      String companyCode,
      String? fingerprints,
      String phoneno,
      String deviceinfo,
      BuildContext context) async {
    NetConnection.networkConnection(context).then((value) async {
      print("Text fp...$fingerprints---$companyCode---$phoneno---$deviceinfo");
      // ignore: prefer_is_empty
      if (companyCode.length >= 0) {
        appType = companyCode.substring(10, 12);
      }
      if (value == true) {
        try {
          Uri url =
              Uri.parse("https://trafiqerp.in/order/fj/get_registration.php");
          Map body = {
            'company_code': companyCode,
            'fcode': fingerprints,
            'deviceinfo': deviceinfo,
            'phoneno': phoneno
          };
          // ignore: avoid_print
          print("register body----$body");
          isLoading = true;
          notifyListeners();
          http.Response response = await http.post(
            url,
            body: body,
          );
          // print("body $body");
          var map = jsonDecode(response.body);
          // ignore: avoid_print
          print("regsiter map----$map");
          RegistrationData regModel = RegistrationData.fromJson(map);

          sof = regModel.sof;
          fp = regModel.fp;
          String? msg = regModel.msg;

          if (sof == "1") {
            if (appType == 'TQ') {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              /////////////// insert into local db /////////////////////
              String? fp1 = regModel.fp;

              // ignore: avoid_print
              print("fingerprint......$fp1");
              prefs.setString("fp", fp!);

              cid = regModel.cid;
              prefs.setString("cid", cid!);

              cname = regModel.c_d![0].cnme;

              prefs.setString("cname", cname!);

              print("cid----cname-----$cid---$cname");
              notifyListeners();

              await externalDir.fileWrite(fp1!);

              // ignore: duplicate_ignore
              for (var item in regModel.c_d!) {
                print("ciddddddddd......$item");
                c_d.add(item);
              }
              // verifyRegistration(context, "");

              isLoading = false;
              notifyListeners();
              prefs.setString("user_type", appType!);
              prefs.setString("db_name", map["mssql_arr"][0]["db_name"]);
              prefs.setString("old_db_name", map["mssql_arr"][0]["db_name"]);
              prefs.setString("ip", map["mssql_arr"][0]["ip"]);
              prefs.setString("port", map["mssql_arr"][0]["port"]);
              prefs.setString("usern", map["mssql_arr"][0]["username"]);
              prefs.setString("pass_w", map["mssql_arr"][0]["password"]);
              prefs.setString("multi_db", map["mssql_arr"][0]["multi_db"]);

              String? user = prefs.getString("userType");
              await TrafiqProDB.instance
                  .deleteFromTableCommonQuery("companyRegistrationTable", "");
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            } else {
              CustomSnackbar snackbar = CustomSnackbar();
              // ignore: use_build_context_synchronously
              snackbar.showSnackbar(context, "Invalid Apk Key", "");
            }
          }
          /////////////////////////////////////////////////////
          if (sof == "0") {
            CustomSnackbar snackbar = CustomSnackbar();
            // ignore: use_build_context_synchronously
            snackbar.showSnackbar(context, msg.toString(), "");
          }

          notifyListeners();
        } catch (e) {
          // ignore: avoid_print
          print(e);
          return null;
        }
      }
    });
    return null;
  }

  //////////////////////////////////////////////////////////
  getLogin(String user_name, String password, BuildContext context) async {
    try {
      isLoginLoading = true;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (user_name.toLowerCase() != "vega" ||
          password.toLowerCase() != "vega") {
        CustomSnackbar snackbar = CustomSnackbar();
        snackbar.showSnackbar(context, "Incorrect Username or Password", "");
        isLoginLoading = false;
        notifyListeners();
      } else {
        prefs.setString("st_uname", user_name);
        prefs.setString("st_pwd", password);
        initDb(context, "from login");
        // initYearsDb(context, "from login");
      }
      isLoginLoading = false;
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return null;
    }
  }

//////////////////////////////////////////////////////////
  initDb(BuildContext context, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? db = prefs.getString("old_db_name");
    String? ip = prefs.getString("ip");
    String? port = prefs.getString("port");
    String? un = prefs.getString("usern");
    String? pw = prefs.getString("pass_w");
    debugPrint("Connecting...");
    try {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Please wait",
                  style: TextStyle(fontSize: 13),
                ),
                SpinKitCircle(
                  color: Colors.green,
                )
              ],
            ),
          );
        },
      );
      await SqlConn.connect(
          ip: ip!, port: port!, databaseName: db!, username: un!, password: pw!
          // ip:"192.168.18.37",
          // port: "1433",
          // databaseName: "epulze",
          // username: "sa",
          // password: "1"

          );
      debugPrint("Connected!");
      getDatabasename(context, type);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      Navigator.pop(context);
    }
  }

//////////////////////////////////////////////////////////
  getUserData() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cname = prefs.getString("cname");
    userName = prefs.getString("name");
    print("haiii ----$cname");
    isLoading = false;
    notifyListeners();
  }

  ////////////////////////////////////
  setDate(String date1, String date2) {
    fromDate = date1;
    todate = date2;
    print("gtyy----$fromDate----$todate");
    notifyListeners();
  }

////////////////////////////////////////////////////////
  getHome(BuildContext context, String branch, String type) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          isLoading = true;
          notifyListeners();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? cid = await prefs.getString("cid");
          String? db = prefs.getString("db_name");
          print("home pram-----$cid-----$db");
          var res = await SqlConn.readData("Flt_Load_Home '$db','$cid'");
          print("response map--------$res");
          var valueMap = json.decode(res);
          // log(valueMap);
          debugPrint("response valueMap--------$valueMap");
          dashboard_report.clear();
          result.clear();
          sdate =
              new DateFormat("yyyy-MM-dd hh:mm:ss").parse(valueMap[0]["SDATE"]);
          ldate =
              new DateFormat("yyyy-MM-dd hh:mm:ss").parse(valueMap[0]["LDATE"]);
          print("last date--------$ldate");
          if (ldate!.isAfter(DateTime.now())) {
            lastdate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
            if (type == "init") {
              dashDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
              d = DateTime.now();
            }
          } else {
            lastdate = DateFormat('dd-MMM-yyyy').format(ldate!);
            if (type == "init") {
              dashDate = DateFormat('dd-MMM-yyyy').format(ldate!);
              d = ldate!;
            }
          }
          print("sdate------------ldate-----$sdate----$ldate");
          notifyListeners();
          accounts_report.clear();
          for (var item in valueMap) {
            if (item["Rpt_Type"] == 0) {
              getDashboardTileVal(context, item["Rpt_Script"], item,
                  dashDate.toString(), branch);
            } else {
              result.add(item);
              // getReportTileVal(context, item["Rpt_Script"], item);
            }
          }
          groupByName(result);
          isLoading = false;
          notifyListeners();
        } on PlatformException catch (e) {
          print("PlatformException occurredcttr: $e");
          // await SqlConn.disconnect();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Not Connected.! ",
                      style: TextStyle(fontSize: 18),
                    ),
                    SpinKitCircle(
                      color: Colors.green,
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Connect'),
                    onPressed: () async {
                      await initYearsDb(context, "");
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          print(e);
          return null;
        } catch (e) {
          print("An unexpected error occurred: $e");
          return [];

          // Handle other types of exceptions
        }
      }
    });
  }

  ////////////////////////////////////////////////////////////
  getDashboardTileVal(BuildContext context, String sp,
      Map<String, dynamic> item, String date, String branch) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          print("dashboard tile val-------$date ------$branch");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? cid = await prefs.getString("cid");
          String? db = prefs.getString("db_name");

          var res =
              await SqlConn.readData("$sp '$db','$cid','$branch','$date'");
          var valueMap = json.decode(res);
          if (valueMap != null) {
            item["values"] = valueMap;
          }
          dashboard_report.add(item);
          notifyListeners();
          print("dashboard reports------$dashboard_report");
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }
///////////////////////////////////////////////////////////

  void groupByName(var data) {
    report_tile_val.clear();
    result1 = <String, List<Map<String, dynamic>>>{};
    for (var d in data) {
      print(d);
      var e = {
        "Rpt_ID": d["Rpt_ID"]!,
        "Rpt_Order": d["Rpt_Order"]!,
        "Rpt_Type": d["Rpt_Type"]!,
        "Rpt_Group": d["Rpt_Group"]!,
        "Rpt_Name": d["Rpt_Name"]!,
        "Rpt_Script": d["Rpt_Script"]!,
        "Rpt_Key": d["Rpt_Key"]!,
        "Rpt_MultiDt": d["Rpt_MultiDt"]!,
        "Rpt_ColorId": d["Rpt_ColorId"]!,
        "Rpt_ImgID": d["Rpt_ImgID"]!,
        "Stat_Key": d["Stat_Key"]
      };
      var key = d["Rpt_Group"]!;
      if (result1.containsKey(key)) {
        result1[key]!.add(e);
      } else {
        result1[key] = [e];
      }
    }
    result1.entries.forEach((e) => report_tile_val.add({e.key: e.value}));
    print("result---${report_tile_val}");
    print(result);
  }

  ////////////////////////////////////////////////////////
  getReportTabledata(BuildContext context, String sp, String date1,
      String date2, int multidate) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          isReportLoading = true;
          notifyListeners();
          if (multidate == 0) {
            param = "'$date1','$date1'";
          } else {
            param = "'$date1','$date2'";
          }
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? brId = await prefs.getString("br_id");
          print("parameters--------------$sp-----$param");
          String? cid = await prefs.getString("cid");
          String? db = prefs.getString("db_name");

          var res = await SqlConn.readData("$sp  '$db', '$cid','$brId',$param");
          print("report table----$res");
          var valueMap = json.decode(res);
          print("value map----$valueMap");
          report_data.clear();
          for (var item in valueMap) {
            report_data.add(item);
          }
          jsonEncoded = jsonEncode(report_data);
          isReportLoading = false;
          notifyListeners();
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }

/////////////////////////////////////////////////////////////////
  getdaybookReportTabledata(BuildContext context, String sp, String date1,
      String date2, int multidate, int rpt_key) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          String dtstr = "";
          isReportLoading = true;
          notifyListeners();
          if (multidate == 0) {
            param = "'$date1','$date1'";
          } else {
            param = "'$date1','$date2'";
          }
          Map<String, dynamic> map = {};
          List<Map<String, dynamic>> list = [];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? brId = await prefs.getString("br_id");
          print("parameters--------------$sp-----$param--$brId");
          String? cid = await prefs.getString("cid");
          String? db = prefs.getString("db_name");
          var res = await SqlConn.readData("$sp  '$db', '$cid','$brId',$param");
          print("daybook---$res");
          var valueMap = json.decode(res);
          print("value map----$valueMap");
          bal = 0.0;
          dtstr = "";
          listWidget.clear();
          for (var item in valueMap) {
            print("balance--------$bal");
            if (dtstr == "") {
              dtstr = item["TDate"];
              listWidget.add(Container(
                // height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 248, 247, 247),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 8, bottom: 8),
                  child: Text(
                    dtstr,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ));
              print("dtstr-----$dtstr");
            } else {
              if (dtstr != item["TDate"]) {
                print("bal--$dtstr--$bal");
                listWidget.add(Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: bal < 0
                          ? const Color.fromARGB(255, 245, 194, 190)
                          : Color.fromARGB(255, 181, 235, 183),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Balance",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                bal < 0
                                    ? (bal * -1).toStringAsFixed(2)
                                    : bal.toStringAsFixed(2),
                                style: TextStyle(
                                    // color: bal < 0 ? Colors.red : Colors.green,
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                bal < 0 ? "Cr" : "Db",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    // color: item["Amount"] < 0 ? Colors.red : Colors.green,
                                    fontSize: 13),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
                dtstr = item["TDate"];
                listWidget.add(Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 248, 247, 247),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                      child: Text(
                        dtstr,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ));

                print("dtstr-----$dtstr");
              }
            }
            listWidget.add(Container(
                // decoration:
                //     BoxDecoration(

                //       border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 238, 236, 236)))),
                child: ListTile(
              onTap: () {
                print("jhfjdf-----${item["ID"]}");
                if (item["ID"] != 0) {
                  findLevelCriteria(context, 1, item["ID"].toString(), "");
                }
                // Level1ReportDetails popup = Level1ReportDetails();
                // popup.viewData(context, item, rpt_key);
              },
              contentPadding: EdgeInsets.only(left: 8.0, right: 8),
              // dense:true,
              visualDensity: VisualDensity(horizontal: 0, vertical: -2),
              // shape: Border(
              //   bottom: BorderSide(color: Color.fromARGB(255, 194, 57, 57)),
              // ),
              title: Text(
                item["Head"],
                style: TextStyle(fontSize: 14),
              ),
              subtitle: Text(
                item["Narraion"].toString(),
                style: TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Wrap(
                spacing: 7,
                children: [
                  Text(
                    item["Amount"] != null
                        ? item["Amount"] < 0
                            ? (item["Amount"] * -1).toStringAsFixed(2)
                            : item["Amount"].toStringAsFixed(2)
                        : "0.00",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: item["Amount"] != null
                            ? item["Amount"] < 0
                                ? Colors.red
                                : Colors.green
                            : Colors.green,
                        fontSize: 14),
                  ),
                  Text(
                    item["Amount"] != null
                        ? item["Amount"] < 0
                            ? "Cr"
                            : "Db"
                        : "",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        // color: item["Amount"] < 0 ? Colors.red : Colors.green,
                        fontSize: 13),
                  )
                ],
              ),
            )));
            if (item["Amount"] != null) {
              bal = bal + item["Amount"];
            } else {
              bal = bal + 0;
            }
          }
          listWidget.add(Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 0,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: bal < 0
                    ? const Color.fromARGB(255, 245, 194, 190)
                    : Color.fromARGB(255, 181, 235, 183),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Balance",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          bal < 0
                              ? (bal * -1).toStringAsFixed(2)
                              : bal.toStringAsFixed(2),
                          style: TextStyle(
                              // color: bal < 0 ? Colors.red : Colors.green,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          bal < 0 ? "Cr" : "Db",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              // color: item["Amount"] < 0 ? Colors.red : Colors.green,
                              fontSize: 13),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ));
          print("bal--$dtstr--$bal");
          // groupByDateDaybook(list);
          isReportLoading = false;
          notifyListeners();
        } catch (e) {
          print(e);
          SqlConn.disconnect();
          // return null;
          return [];
        } 
        finally {
          if (!SqlConn.isConnected) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Not Connected.!",
                        style: TextStyle(fontSize: 13),
                      ),
                      SpinKitCircle(
                        color: Colors.green,
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        // await initYearsDb(context, ""); // place your db connection here...
                        Navigator.of(context).pop();
                      },
                      child: Text('Connect'),
                    ),
                  ],
                );
              },
            );
            debugPrint("Database not connected, popping context.");
          }
        }
      }
    });
  }

/////////////////////////////////////////////////////////////////
  getSubReport(BuildContext context, int rptId) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          print("rprttt-Id----$rptId");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? brId = await prefs.getString("br_id");
          String? cid = await prefs.getString("cid");
          String? db = prefs.getString("db_name");

          var res = await SqlConn.readData(
              "Flt_SubReport '$db','$cid','$brId', $rptId");
          var map = jsonDecode(res);
          sub_report.clear();
          for (var item in map) {
            sub_report.add(item);
          }
          print("sub report----$sub_report");
          notifyListeners();
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }

  /////////////////////////////////////////////////////////////
  findLevelCriteria(
      BuildContext context, int level, String val, String tit) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // pre
    print("sub_report-----$sub_report---$level--$val");
    levelCriteria = {};
    if (sub_report.isNotEmpty) {
      for (var item in sub_report) {
        if (item["Sub_Order"] == level) {
          levelCriteria = item;
        }
      }

      print("levelcriteria--------$levelCriteria");

      if (level == 1) {
        param = "$param,'$val'";
        print("l2 param-----$param");
        poptitle = tit;
        getL2SubreportData(context, levelCriteria["Sub_Script"],
            fromDate.toString(), todate.toString(), param);
        // if (sub_report_data.length > 0) {
        //   Level2ReportDetails popup = Level2ReportDetails();
        //   popup.viewData(context, levelCriteria, poptitle,
        //       levelCriteria["Sub_Key"].toString());
        // }
      } else if (level == 2) {
        poptitle = '$poptitle' + '/' + '$tit';
        param = "$param,'$val'";
        getL3SubreportData(context, levelCriteria["Sub_Script"],
            fromDate.toString(), todate.toString(), param);
        // if (l3_sub_report_data.length > 0) {
        //   Level3ReportDetails popup = Level3ReportDetails();
        //   popup.viewData(context, levelCriteria, poptitle,
        //       levelCriteria["Sub_Key"].toString());
        // }
      }
    }
    notifyListeners();
  }

  ///////////////////////////////////////////////////////////////////////
  getL2SubreportData(
    BuildContext context,
    String sp,
    String date1,
    String date2,
    String val,
  ) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          isSubReportLoading = true;
          notifyListeners();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? brId = await prefs.getString("br_id");
          String? cid = await prefs.getString("cid");
          String? db = prefs.getString("db_name");
          print("sub parameters------------$sp----'$db','$cid','$brId',$val");
          var res = await SqlConn.readData("$sp '$db','$cid','$brId',$val");
          print("sub report table----$res");
          var valueMap = json.decode(res);
          isSubReportLoading = false;
          notifyListeners();
          print("sub report value map----$valueMap");
          sub_report_data.clear();
          for (var item in valueMap) {
            sub_report_data.add(item);
          }
          sub_report_json = jsonEncode(sub_report_data);
          print("subreport json----$sub_report_json");
          if (sub_report_data.length > 0) {
            Level2ReportDetails popup = Level2ReportDetails();
            popup.viewData(context, levelCriteria, poptitle,
                levelCriteria["Sub_Key"].toString());
          }

          print("sub_report_data---$sub_report_data");
          notifyListeners();
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }

  /////////////////////////////////////////////////////////////////////
  getL3SubreportData(
      BuildContext context, String sp, String date1, String date2, String val) {
    NetConnection.networkConnection(context).then((value) async {
      print("sub l3 parameters----------------$sp,'0','1',$val");
      if (value == true) {
        try {
          isl3SubReportLoading = true;
          notifyListeners();
          print("param-------$val");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? brId = await prefs.getString("br_id");
          String? cid = await prefs.getString("cid");
          String? db = prefs.getString("db_name");

          var res = await SqlConn.readData("$sp '$db','$cid','$brId',$val");
          print("sub l3 report table----$res");
          var valueMap = json.decode(res);
          l3_sub_report_data.clear();
          for (var item in valueMap) {
            l3_sub_report_data.add(item);
          }
          isl3SubReportLoading = false;
          notifyListeners();
          l3_sub_report_data_json = jsonEncode(l3_sub_report_data);
          print("l3 subreport json----$l3_sub_report_data_json");

          if (l3_sub_report_data.length > 0) {
            Level3ReportDetails popup = Level3ReportDetails();
            popup.viewData(context, levelCriteria, poptitle,
                levelCriteria["Sub_Key"].toString());
          }
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }

  ///////////////////////////////////////////////////////////////////
  splitParametr(String level) {
    List listParam = param.split(',');
    List listpop = poptitle.split('/');

    if (level == "2") {
      param = "${listParam[0]},${listParam[1]}";
      print("listparam1--------$param");
    } else if (level == "3") {
      param = "${listParam[0]},${listParam[1]},${listParam[2]}";
      poptitle = listpop[0];
    }

    print("param----------$param");
    notifyListeners();
  }

  ///////////////////////////////////////////////////////////////////
  findDate(DateTime date, String type, BuildContext context) async {
    print("new d----------------$date---$type-");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? brId = await prefs.getString("br_id");
    if (type == "prev") {
      // print("new d----------------$date----");

      if (DateTime(sdate!.year, sdate!.month, sdate!.day) !=
          DateTime(date.year, date.month, date.day)) {
        d = DateTime(date.year, date.month, date.day - 1);
        dashDate = DateFormat('dd-MMM-yyyy').format(d);
        getHome(context, brId.toString(), "");
        notifyListeners();
      }
    } else {
      if (DateTime(ldate!.year, ldate!.month, ldate!.day) !=
          DateTime(date.year, date.month, date.day)) {
        d = DateTime(date.year, date.month, date.day + 1);
        dashDate = DateFormat('dd-MMM-yyyy').format(d);
        print("new d----------------$d--$dashDate--$date");

        getHome(context, brId.toString(), "");
        notifyListeners();
      }

      // if (DateTime(
      //         DateTime.now().year, DateTime.now().month, DateTime.now().day) !=
      //     DateTime(date.year, date.month, date.day)) {
      //   d = DateTime(date.year, date.month, date.day + 1);
      //   dashDate = DateFormat('dd-MMM-yyyy').format(d);
      //   getHome(context, dashDate.toString(), brId.toString());
      // }
    }
    notifyListeners();
  }

  /////////////////////////////////////////////////////////////////
  getBranches(
    BuildContext context,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cid = await prefs.getString("cid");
    String? db = prefs.getString("db_name");

    var res = await SqlConn.readData("Flt_Load_Branches '$db','$cid'");
    print("barnch res--------$db ----- $res");

    var valueMap = json.decode(res);
    branch_list.clear();

    if (valueMap != null) {
      for (var item in valueMap) {
        branch_list.add(item);
      }
      selected = branch_list[0]['Br_Name'];
      branchid = branch_list[0]['Br_ID'].toString();
      prefs.setString("br_id", branchid.toString());
      getHome(context, branchid.toString(), "init");
    } else {
      prefs.setString("br_id", "0");
      getHome(context, "0", "init");
    }

    notifyListeners();
  }

//////////////////////////////////////////////////////////////////////////////////////////
  setDropdowndata(String s, String date, BuildContext context) async {
    // branchid = s;
    for (int i = 0; i < branch_list.length; i++) {
      if (branch_list[i]["Br_ID"].toString() == s.toString()) {
        selected = branch_list[i]["Br_Name"];
        branchid = branch_list[i]["Br_ID"].toString();
        print("s------$s---$selected");

        notifyListeners();
      }
    }
    getHome(context, branchid.toString(), "");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("br_id", branchid.toString());
    notifyListeners();
  }

  /////////////////////////////////////////////////////////////////////////////
  initYearsDb(
    BuildContext context,
    String type,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ip = prefs.getString("ip");
    String? port = prefs.getString("port");
    String? un = prefs.getString("usern");
    String? pw = prefs.getString("pass_w");
    String? db = prefs.getString("db_name");
    String? multi_db = prefs.getString("multi_db");

    debugPrint("Connecting...$db----");
    try {
      // await SqlConn.disconnect();
      showDialog(
        context: context,
        builder: (mycontxt) {
          // Navigator.push(
          //   context,
          //   new MaterialPageRoute(builder: (context) => HomePage()),
          // );
          // Future.delayed(Duration(seconds: 5), () {
          //   Navigator.of(mycontxt).pop(true);
          // });
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Please wait",
                  style: TextStyle(fontSize: 13),
                ),
                SpinKitCircle(
                  color: Colors.green,
                )
              ],
            ),
          );
        },
      );
      if (multi_db == "1") {
        await SqlConn.connect(
            ip: ip!,
            port: port!,
            databaseName: db!,
            username: un!,
            password: pw!);
      }
      debugPrint("Connected!----$ip------$db");
      // getDatabasename(context, type);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      yr = prefs.getString("yr_name");
      dbn = prefs.getString("db_name");
      cName = prefs.getString("cname");
      // prefs.setString("db_name", dbn.toString());
      // prefs.setString("yr_name", yrnam.toString());
      // getDbName();
      getBranches(context);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      Navigator.pop(context);
    }
  }

  /////////////////////////////////////////////////////////////////
  // getDbName() async {
  //   isDbNameLoading = true;
  //   notifyListeners();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   yr = prefs.getString("yr_name");
  //   dbn = prefs.getString("db_name");
  //   cName = prefs.getString("cname");
  //   isDbNameLoading = false;
  //   notifyListeners();
  // }

//////////////////////////////////////////////////////////////////////
  getCustomerList(
      BuildContext context, String dte1, String dt2, int multidate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cid = await prefs.getString("cid");
    String? db = prefs.getString("db_name");
    String? brId = await prefs.getString("br_id");
    param = "";
    isCusLoading = true;
    notifyListeners();
    if (multidate == 0) {
      param = "'$dte1','$dt2'";
    } else {
      param = "'$dte1','$dt2'";
    }

    print("customer body---$brId---$dte1---$dt2-----$param");

    var res =
        await SqlConn.readData("Flt_AccHeads '$db','$cid','$brId',$param");
    var valueMap = json.decode(res);
    customer_list.clear();
    if (valueMap != null) {
      for (var item in valueMap) {
        // double d = item["Balance"];

        // print("haii---${item["Balance"].runtimeType}");
        // if (d != 0.0) {
        //   String bal = d.toStringAsFixed(2);
        // }
        // Map<String, dynamic> map = {
        //   "Acc_ID": item["Acc_ID"],
        //   "Head": item["Head"],
        //   "Group": item["Group"],
        //   "Balance": bal
        // };
        customer_list.add(item);
      }
    }

    isCusLoading = false;
    print("customer list-------------$customer_list");
    notifyListeners();
  }

//////////////////////////////////////////////////////////////////////
  getProductNameList(BuildContext context, String dte1, String dt2) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cid = await prefs.getString("cid");
    String? db = prefs.getString("db_name");
    String? brId = await prefs.getString("br_id");
    int multidate = 0;
    param = "";
    isProLoading = true;
    notifyListeners();
    if (multidate == 0) {
      param = "'$dte1','$dt2'";
    } else {
      param = "'$dte1','$dt2'";
    }

    print("productname body----$cid--$db--branch:$brId--$param");
    print("parameter----$param");

    var res = await SqlConn.readData("Flt_items_list '','$cid','$brId',$param");
    print("productnamelist $res");

    var valueMap = json.decode(res);

    productname_list.clear();
    if (valueMap != null) {
      for (var item in valueMap) {
        productname_list.add(item);
      }
    }

    isProLoading = false;
    print("productname list-------------$productname_list");
    notifyListeners();
  }

//////////////////////////////////////////////////////////////////////
  getProductDetailsList(BuildContext context, int? pid) async {
    print("product id...........$pid");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cid = await prefs.getString("cid");
    String? db = prefs.getString("db_name");
    String? brId = await prefs.getString("br_id");
    param = "";
    isProdetailLoading = true;
    notifyListeners();

    var res = await SqlConn.readData("Flt_items_Det $pid");
    print("productdetailslist................ $res");

    var valueMap = json.decode(res);

    productdetail_report.clear();
    if (valueMap != null) {
      for (var item in valueMap) {
        productdetail_report.add(item);
      }
    }

    isProdetailLoading = false;
    print(
        "product details list-----$valueMap-------${productdetail_report[0]}");
    notifyListeners();
  }

//////////////////////////////////////////////////////////////
  getProductBatchList(BuildContext context, int? pid) async {
    print("product id...........$pid");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cid = await prefs.getString("cid");
    String? db = prefs.getString("db_name");
    String? brId = await prefs.getString("br_id");
    param = "";
    isBatchLoading = true;

    notifyListeners();

    var res = await SqlConn.readData("Flt_Batch_List $pid");
    print("batch details................ $res");

    var valueMap = json.decode(res);
    rowMap = valueMap.toList();
    print("result....$valueMap.....$rowMap");

    batch_report.clear();
    if (valueMap != null) {
      for (var item in valueMap) {
        batch_report.add(item);
      }
    }
    batch_report_json = jsonEncode(batch_report);

    // tableColumn=batch_report[""]
    tableColumn = batch_report[0].keys.toList();
    // newMp.clear();
    print("batch report.....$batch_report");

    rowMap.forEach((element) {
      print("element-----$element");
      newMp.add(element);
      filterList.add(element);
    });
    print("newMpcontroller---${newMp}");
    // tableColumn = batch_report.first[0];
    isBatchLoading = false;
    print("table columns-----------${tableColumn}");
    notifyListeners();
  }

//////////////////////////////////////////////////////////////////////
  getLedger(BuildContext context, String dte1, String dt2, String sp, String id,
      int multidate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cid = await prefs.getString("cid");
    String? db = prefs.getString("db_name");
    String? brId = await prefs.getString("br_id");
    String dtstr = "";

    isLoading = true;
    notifyListeners();

    if (multidate == 0) {
      param = "'$dte1','$dt2'";
    } else {
      param = "'$dte1','$dt2'";
    }
    print("ledger body--------------$sp----$id----$param");

    var res = await SqlConn.readData("$sp '$db','$cid','$brId',$param,'$id'");
    var valueMap = json.decode(res);

    print("ledger-----------$valueMap");
    bal = 0.0;
    dtstr = "";
    ledgerWidget.clear();
    for (var item in valueMap) {
      print("balance--------$bal");
      if (dtstr == "") {
        dtstr = item["TDate"];
        ledgerWidget.add(Container(
          // height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 248, 247, 247),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 8, bottom: 8),
            child: Text(
              dtstr,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
        print("dtstr-----$dtstr");
      } else {
        if (dtstr != item["TDate"]) {
          print("bal--$dtstr--$bal");
          // ledgerWidget.add(Padding(
          //   padding: const EdgeInsets.only(
          //     left: 8.0,
          //     right: 8,
          //   ),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       color: bal < 0
          //           ? const Color.fromARGB(255, 245, 194, 190)
          //           : Color.fromARGB(255, 181, 235, 183),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             "Balance",
          //             style: TextStyle(
          //               color: Colors.black,
          //               fontWeight: FontWeight.bold,
          //               fontSize: 17,
          //             ),
          //           ),
          //           Row(
          //             children: [
          //               Text(
          //                 bal < 0
          //                     ? (bal * -1).toStringAsFixed(2)
          //                     : bal.toStringAsFixed(2),
          //                 style: TextStyle(
          //                     // color: bal < 0 ? Colors.red : Colors.green,
          //                     color: Colors.black,
          //                     fontSize: 17,
          //                     fontWeight: FontWeight.bold),
          //               ),
          //               SizedBox(
          //                 width: 10,
          //               ),
          //               Text(
          //                 bal < 0 ? "Cr" : "Db",
          //                 style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     color: Colors.blue,
          //                     // color: item["Amount"] < 0 ? Colors.red : Colors.green,
          //                     fontSize: 15),
          //               )
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ));
          dtstr = item["TDate"];
          ledgerWidget.add(Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 248, 247, 247),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                child: Text(
                  dtstr,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ));

          print("dtstr-----$dtstr");
        }
      }
      ledgerWidget.add(Container(
          // decoration:
          //     BoxDecoration(

          //       border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 238, 236, 236)))),
          child: ListTile(
        onTap: () {
          if (item["ID"] != 0) {
            findLevelCriteria(context, 1, item["ID"].toString(), "");
          }
        },
        contentPadding: EdgeInsets.only(left: 8.0, right: 8),

        visualDensity: VisualDensity(horizontal: 0, vertical: -2),
        // shape: Border(
        //   bottom: BorderSide(color: Color.fromARGB(255, 194, 57, 57)),
        // ),
        title: Text(
          item["Head"],
          style: TextStyle(fontSize: 13),
        ),
        subtitle: Text(
          item["Narraion"].toString(),
          // "sdbfjdf dfjdbfd fbjhdfbhdf hdbfhbdfd fhjdfbhdbfhd",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13),
        ),
        trailing: Wrap(
          spacing: 7,
          children: [
            Text(
              item["Amount"] != null
                  ? item["Amount"] < 0
                      ? (item["Amount"] * -1).toStringAsFixed(2)
                      : item["Amount"].toStringAsFixed(2)
                  : "0.00",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: item["Amount"] != null
                      ? item["Amount"] < 0
                          ? Colors.red
                          : Colors.green
                      : Colors.green,
                  fontSize: 15),
            ),
            Text(
              item["Amount"] != null
                  ? item["Amount"] < 0
                      ? "Cr"
                      : "Db"
                  : "",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  // color: item["Amount"] < 0 ? Colors.red : Colors.green,
                  fontSize: 13),
            )
          ],
        ),
      )));
      if (item["Amount"] != null) {
        bal = bal + item["Amount"];
      } else {
        bal = bal + 0;
      }
    }
    ledgerWidget.add(Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: bal < 0
              ? const Color.fromARGB(255, 245, 194, 190)
              : Color.fromARGB(255, 181, 235, 183),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Balance",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  Text(
                    bal < 0
                        ? (bal * -1).toStringAsFixed(2)
                        : bal.toStringAsFixed(2),
                    style: TextStyle(
                        // color: bal < 0 ? Colors.red : Colors.green,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    bal < 0 ? "Cr" : "Db",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        // color: item["Amount"] < 0 ? Colors.red : Colors.green,
                        fontSize: 13),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ));
    isLoading = false;
    print("legder list-------------$ledger_list");
    notifyListeners();
  }

  ///////////////////////////////////////
  searchCustomerList(String val) {
    if (val.isNotEmpty) {
      isSearch = true;
      notifyListeners();
      filteredList = customer_list
          .where((e) =>
              e["Head"].toLowerCase().contains(val.toLowerCase()) &&
              e["Head"].toLowerCase().startsWith(val.toLowerCase()))
          .toList();
    } else {
      filteredList = customer_list;
    }

    print("filterd list------------${filteredList}");

    notifyListeners();
  }

  ///////////////////////////////////////////////////////////////////////
  searchProductNameList(String val) {
    print("Searach val.....$val.........${productname_list.length}");
    if (val.isNotEmpty) {
      isSearch = true;
      notifyListeners();
      searchProduct = productname_list
          .where((e) =>
              e["P_NAME"].toLowerCase().contains(val.toLowerCase()) ||
              e["P_NAME"].toLowerCase().startsWith(val.toLowerCase()))
          .toList();
    } else {
      searchProduct = productname_list;
    }

    print("search list------------${searchProduct}");

    notifyListeners();
  }

  ///////////////////////////////////////////////////////////////////////
  setIsSearch(bool val) {
    print("value..........$val");
    isSearch = val;
    notifyListeners();
  }

  ///////////////////////////////////////////////////////////////

  getDatabasename(BuildContext context, String type) async {
    isdbLoading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? db = prefs.getString("db_name");
    String? cid = await prefs.getString("cid");
    print("cid dbname---------$cid---$db");
    var res = await SqlConn.readData("Flt_LoadYears '$db','$cid'");
    var map = jsonDecode(res);
    db_list.clear();
    if (map != null) {
      for (var item in map) {
        db_list.add(item);
      }
    }
    print("years res-$res");

    isdbLoading = false;
    notifyListeners();
    if (db_list.length > 0) {
      if (type == "from login") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DbSelection()),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

//////////////////////////////////////////////////////////
  setColor(String col) {
    colorString = col;
    notifyListeners();
  }

////////////////////////////////////////////////////////////////////////////////
  listItem() async {
    Uri url = Uri.parse(
        "http://192.168.18.37:10000/api/fetch_daily_production_report");
    Map body = {"to_date": "18-11-2023", "company_id": "1"};
    http.Response response = await http.post(
      url,
      body: body,
    );

    var map = jsonDecode(response.body);
    double grandtot = 0.0;
    print("listt   hhhh----$map");
    for (var item in map["data"]) {
      if (item["flg"] == "2") {
        grandtot = grandtot + double.parse(item["tot"]);
      }
    }

    print("granbdtott-----$grandtot");
    list.clear();
    resultList = <String, List<Map<String, dynamic>>>{};
    for (var d in map["data"]) {
      print(d);
      var e = {
        "employee_id": d["employee_id"].toString(),
        "exp_nos": d["exp_nos"].toString(),
        "flg": d["flg"].toString(),
        "c_name": d["c_name"].toString(),
        "p_name": d["p_name"].toString(),
        "nos": d["nos"].toString(),
        "s_rate_1": d["s_rate_1"].toString(),
        "tot": d["tot"].toString(),
      };
      var key = d["employee_id"].toString();
      if (resultList.containsKey(key)) {
        resultList[key]!.add(e);
      } else {
        resultList[key] = [e];
      }
    }
    resultList.entries.forEach((e) => list.add({e.key: e.value}));
    print("resultList---${list}");
    notifyListeners();
  }

  onRefresh(BuildContext context) {
    getHome(context, branchid.toString(), "");
  }
}

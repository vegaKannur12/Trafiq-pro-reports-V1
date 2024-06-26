import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controller/controller.dart';

class TableData extends StatefulWidget {
  var decodd;
  String keyVal;
  double popuWidth;
  int level;
  String title;
  String? rpt_key;

  TableData({
    required this.decodd,
    required this.keyVal,
    required this.popuWidth,
    required this.level,
    required this.title,
    this.rpt_key,
  });

  @override
  State<TableData> createState() => _TableDataState();
}

class _TableDataState extends State<TableData> {
  TextEditingController seacrh = TextEditingController();
  String? key;
  // int _currentSortColumn = 0;
  // bool _isSortAsc = true;
  List li = [];
  List<dynamic> mapTabledata = [];
  List<String> tableColumn = [];
  Map<String, dynamic> valueMap = {};
  List<Map<dynamic, dynamic>> newMp = [];
  List<Map<dynamic, dynamic>> filteredList = [];
  List<dynamic> rowMap = [];
  double? datatbleWidth;
  // final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    print(
        "shrinked   mapTabledata-....${widget.level}.....${widget.keyVal}-.......${widget.title}.........${widget.rpt_key}-${widget.decodd}");

    super.initState();
    if (widget.decodd != null) {
      mapTabledata = json.decode(widget.decodd);
    } else {
      print("null");
    }
    rowMap = mapTabledata;
    mapTabledata[0].forEach((key, value) {
      tableColumn.add(key);
    });

    print("tablecolumn-----$tableColumn");
    newMp.clear();
    filteredList.clear();
    calculateSum(mapTabledata, tableColumn);
    rowMap.forEach((element) {
      print("element-----$element");
      newMp.add(element);
      filteredList.add(element);
    });

    if (widget.keyVal != "2") {
      if (widget.rpt_key.toString().isNotEmpty) {
        int index = int.parse(widget.rpt_key!);
        key = newMp[0].keys.elementAt(index);
        print("key key----------$key");
      }
    }

    print("filteredList---${filteredList}");
    print("newMp---${newMp}");

    // if (widget.keyVal != "0") {
    //   int ele = int.parse(widget.keyVal) - 1;
    //   key = newMp[0].keys.elementAt(ele);
    // }
  }

//////////////////////////////////////////////////////////////////////////////
  Widget build(BuildContext context) {
    // FocusScope.of(context).requestFocus(FocusNode());

    Size size = MediaQuery.of(context).size;
    datatbleWidth = widget.popuWidth - 20;
    print(
        "screen width-----${size.width}------datatble width-----$datatbleWidth");
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: Colors.transparent,
          width: datatbleWidth,
          child: Column(
            children: [
              widget.keyVal == "0"
                  ? Container()
                  : Container(
                      height: size.height * 0.05,
                      // width: 200,
                      // margin: EdgeInsets.only(left: 3, right:3),
                      child: TextFormField(
                        controller: seacrh,
                        //   decoration: const InputDecoration(,
                        onChanged: (value) {
                          print("ggggg----$value");
                          setState(() {
                            // String key = newMp[0].keys.toList().first;
                            // print("msnmdli----${li[0]}");
                            filteredList = value.isEmpty || value == " "
                                ? newMp
                                : newMp
                                    .where((item) => item[key]
                                        .toString()
                                        .toLowerCase()
                                        .startsWith(
                                            value.toString().toLowerCase()))
                                    .toList();
                            print("after filter-------$newMp");
                          });
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.blue,
                            ),
                            suffixIcon: IconButton(
                              icon: new Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  filteredList = newMp;
                                });
                                seacrh.text = " ";
                                seacrh.clear();
                              },
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 0),
                            border: OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 128, 125, 125),
                                  width: 0.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 128, 125, 125),
                                  width: 0.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 128, 125, 125),
                                  width: 0.0),
                            ),
                            filled: true,
                            hintStyle:
                                TextStyle(color: Colors.blue, fontSize: 13),
                            hintText: "Search here.. ",
                            fillColor: Colors.grey[100]),
                      ),
                    ),
              SizedBox(
                height: size.height * 0.001,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Consumer<Controller>(
                  builder:
                      (BuildContext context, Controller value, Widget? child) =>
                          DataTable(
                    showCheckboxColumn: false,
                    columnSpacing: 0,
                    headingRowHeight: 45,
                    dataRowHeight: 38,
                    horizontalMargin: 5,
                    headingRowColor: MaterialStateProperty.all(
                        parseColor(value.colorString!)),
                    columns: getColumns(tableColumn),
                    rows: getRowss(filteredList, seacrh, value.colorString!),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  ///////////////////////////////////////////////////
  List<DataColumn> getColumns(
    List<String> columns,
  ) {
    List<String> columnSplit = [];
    List<DataColumn> datacolumnList = [];
    print("columns --------${columns}");
    String wid = "";
    for (int i = 0; i < columns.length; i++) {
      double colwidth = 0.0;

      columnSplit = columns[i].split('_');
      wid = columns[i].substring(3, 5);
      print("columnsplitdash-------${wid}");
      if (columns.length == 0) {
        colwidth = (datatbleWidth! / columns.length);
      } else {
        if (wid == '00') {
          // print("hhhh");
          colwidth = 0.0;
          colwidth = colwidth * 0.94;
        } else {
          colwidth = (datatbleWidth! * double.parse(wid) / 100);
          colwidth = colwidth * 0.94;
        }
        print("columnwdthdash-----$i--$datatbleWidth ----${double.parse(wid)}");
      }
      datacolumnList.add(DataColumn(
        label: SizedBox(
          width: colwidth,
          child: Text(columnSplit[1].toString(),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: columnSplit[0][1] == "L"
                  ? TextAlign.left
                  : columnSplit[0][1] == "C"
                      ? TextAlign.center
                      : TextAlign.right),
        ),
      ));
    }
    return datacolumnList;
    // return columns.map((String column) {
    //   return DataColumn(
    //     label: ConstrainedBox(
    //       constraints: BoxConstraints(minWidth: 90, maxWidth: 90),
    //       child: Padding(
    //         padding: EdgeInsets.all(0.0),
    //         child: Text(column.toUpperCase(),
    //             style: TextStyle(fontSize: 12), textAlign: TextAlign.right),
    //       ),
    //     ),
    //   );
    // }).toList();
  }

  ////////////////////////////////////////////////////////////////
  List<DataRow> getRowss(List<Map<dynamic, dynamic>> row,
      TextEditingController controller, String colorString) {
    print("rowjsjfkd-----$row");
    List<DataRow> items = [];

    var itemList = filteredList;
    print("nnsdnsd---------------$itemList");
    for (var r = 0; r < itemList.length; r++) {
      items.add(DataRow(
          onSelectChanged: (selected) {
            // String val=
            if (selected!) {
              if (widget.level != 3) {
                print("selected------${itemList[r]}");
                String val = itemList[r].values.toList().first.toString();

                int index = int.parse(widget.rpt_key!);
                print("val----$val---$index");

                String tit = itemList[r].values.elementAt(index).toString();
                Provider.of<Controller>(context, listen: false)
                    .findLevelCriteria(context, widget.level, val, tit);
              }
            }
          },
          color: r == itemList.length - 1
              ? controller.text == ""
                  ? MaterialStateProperty.all(parseColor("#46bdc6"))
                  : MaterialStateProperty.all(Colors.transparent)
              : MaterialStateProperty.all(Colors.transparent), //  r % 2 == 0
          //     ? MaterialStateProperty.all(
          //         Color.fromARGB(255, 194, 229, 238))
          //     : MaterialStateProperty.all(
          //         Color.fromARGB(255, 240, 173, 229)),
          cells: getCelle(itemList[r])));
    }
    return items;

    // return newMp.map((row) {
    //   return DataRow(
    //     cells: getCelle(row),
    //   );
    // }).toList();
  }

  //////////////////////////////////////////////////////////////
  List<DataCell> getCelle(
    Map<dynamic, dynamic> data,
  ) {
    print("data--$data");
    List<DataCell> datacell = [];
    List<String> columnSplit = [];
    String wid = "";

    print("data-------$data");
    // String text = data.values.elementAt(0);
    for (var i = 0; i < tableColumn.length; i++) {
      double colwidth = 0.0;

      data.forEach((key, value) {
        if (tableColumn[i] == key) {
          columnSplit = tableColumn[i].split('_');
          wid = tableColumn[i].substring(3, 5);
          if (tableColumn.length == 0) {
            colwidth = (datatbleWidth! / tableColumn.length);
          } else {
            if (wid == '00') {
              print("hhhh");
              colwidth = 0.0;
              colwidth = colwidth * 0.94;
            } else {
              colwidth = (datatbleWidth! * double.parse(wid) / 100);
              colwidth = colwidth * 0.94;
            }
          }
          print("key from datacell----$key");
          String text = "";
          if (columnSplit[0][0] == "C") {
            if (value != " ") {
              text = value.toStringAsFixed(2);
              print("frtyuui------$text");
            }
          } else if (columnSplit[0][0] == "I") {
            if (value != " ") {
              text = value.toString();
            }
          } else if (columnSplit[0][0] == "T") {
            if (value != " ") {
              text = value.toString();
            }
            print("testtt----${text.runtimeType}");
          } else if (columnSplit[0][0] == "D") {
            if (value != " ") {
              text = value.toString();
            }
          }
          datacell.add(
            DataCell(
              SizedBox(
                width: colwidth,
                child: Text(text.toString(),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: columnSplit[0][1] == "L"
                        ? TextAlign.left
                        : columnSplit[0][1] == "C"
                            ? TextAlign.center
                            : TextAlign.right),
              ),
            ),
          );
        }
      });
    }
    print(datacell.length);
    return datacell;
  }

  /////////////////////////////////////////////////////////////////////
  calculateSum(List<dynamic> element, List tableColumn) {
    Map map = {};
    final oCcy = new NumberFormat("#,##0.00", "en_US");

    print("dynamic elemnt------$element");
    double sum = 0.0;
    int intsum = 0;

    for (int i = 0; i < element.length; i++) {
      element[i].forEach((k, value) {
        List key = k.split("_");
        print("hhh-------$key----$value");
        if (key[0][2] == "Y") {
          if (key[0][0] == "C") {
            if (map[k] == null) {
              sum = 0.0;
              sum = sum + value;
            } else {
              sum = map[k] + value;
            }
            print("sum-----$sum");
            map[k] = sum;
            // sum=0.0;
          } else if (key[0][0] == "I") {
            print("value runtyme-${value.runtimeType}");
            // int d = value;
            // intsum = intsum + d;
            // map[k] = intsum;
            int d = value;
            if (map[k] == null) {
              intsum = 0;
              intsum = intsum + d;
            } else {
              intsum = map[k] + d;
            }
            map[k] = intsum;
          }
        } else {
          print("map-ggg----${key}");
          map[k] = " ";
        }
      });
    }
    element.add(map);
    print("final clculate map------$map");
  }

////////////////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////
}

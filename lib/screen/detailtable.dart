import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/controller/controller.dart';
import 'package:trafiqpro/screen/tabledata.dart';

class DetaildDataTable extends StatefulWidget {
  // var decodd;
  DetaildDataTable();

  @override
  State<DetaildDataTable> createState() => _DetaildDataTableState();
}

class _DetaildDataTableState extends State<DetaildDataTable> {
  // DetailedInfoSheet info = DetailedInfoSheet();
  // Map<String, dynamic> mapTabledata = {};
  // List<String> tableColumn = [];
  // Map<String, dynamic> valueMap = {};
  // List<Map<dynamic, dynamic>> newMp = [];
  // List<dynamic> rowMap = [];
  double? datatbleWidth;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

//////////////////////////////////////////////////////////////////////////////
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //  var width=60,40;
    datatbleWidth = size.width * 0.5;
    print(
        "screen width-----${size.width}------datatble width-----$datatbleWidth");
    return Container(
      height: 900,
      // alignment: Alignment.center,
      width: datatbleWidth,
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Consumer<Controller>(
            builder: (context, value, child) => DataTable(
              showCheckboxColumn: false,
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
              dataRowMaxHeight: double.infinity, // Code to be changed.
              dataRowMinHeight: 60,
              dataRowColor: MaterialStateColor.resolveWith(
                  (states) => Color.fromARGB(255, 135, 227, 248)),
              columnSpacing: 7,
              headingRowHeight: 40,
              horizontalMargin: 5,
              columns: getColumns(value.tableColumn),
              rows: getRowss(value.newMp, value.tableColumn, value.filterList),
            ),
          ),
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////
  List<DataColumn> getColumns(List<String> columns) {
    String behv;
    String colsName;
    double colwidth = 2.0;
    List<DataColumn> datacolumnList = [];
    print("columns --------${columns.length}");
    // List<String> ws = width.split(',');

    for (int i = 0; i < columns.length; i++) {
      // if (ws.length == 0) {
      //   colwidth = (datatbleWidth! / columns.length);
      // } else {
      //   colwidth = (datatbleWidth! * double.parse(ws[i]) / 100);
      // }
      colwidth = colwidth * 0.94;

      datacolumnList.add(DataColumn(
        label: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 250, maxWidth: 250),
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Text(
              // "hello",
              columns[i].toUpperCase(),
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              // textAlign:368320
              // alignment[i] == "L" ? TextAlign.left : TextAlign.right
            ),
          ),
        ),
      ));
    }
    return datacolumnList;
  }

  ////////////////////////////////////////////////////////////////
  List<DataRow> getRowss(List<Map<dynamic, dynamic>> row,
      List<String> tableColumn, List<Map<dynamic, dynamic>> filterList) {
    print("row.............$filterList=================$tableColumn");
    List<DataRow> items = [];

    var itemList = filterList;
    for (var r = 0; r < itemList.length; r++) {
      items.add(DataRow(
          // onSelectChanged: (selected) {
          //   if (selected!) {

          //   }
          // },
          // color: r == itemList.length - 1
          //     ? MaterialStateProperty.all(P_Settings.sumColor)
          //     : MaterialStateProperty.all(P_Settings.rowColor),
          cells: getCelle(itemList[r], tableColumn)));
    }
    return items;
  }

  //////////////////////////////////////////////////////////////
  List<DataCell> getCelle(
      Map<dynamic, dynamic> data, List<String> tableColumn) {
    String behv;
    String colsName;

    String? dval;
    double colwidth = 4.0;
    print("data--$data");
    List<DataCell> datacell = [];
    // List<String> ws = width.split(',');

    // List<String> ws = width.split(',');

    print("table data-------$data");

    for (var i = 0; i < tableColumn.length; i++) {
      print("table column length........${tableColumn.length}");
      //  if (ws.length == 0) {
      //   colwidth = (datatbleWidth! / tableColumn.length);
      // } else {
      //   colwidth = (datatbleWidth! * double.parse(ws[i]) / 100);
      // }
      // colwidth = colwidth * 0.94;
      colwidth = colwidth * 4;

      data.forEach((key, value) {
        if (tableColumn[i] == key) {
          dval = value.toString();

          datacell.add(
            DataCell(
              onTap: () {
                // info.showInfoSheet(context, "text");
              },
              Container(
                constraints:
                    BoxConstraints(minWidth: colwidth, maxWidth: colwidth),
                // width: 70,
                alignment: Alignment.centerRight,
                // alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                  // padding: behv[1] == "L"? EdgeInsets.only(left:0.3):EdgeInsets.only(right:0.3),
                  child: Text(
                    dval.toString(),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          );
        }
      });
    }
    print(datacell.length);
    return datacell;
  }
}

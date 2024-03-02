import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/controller/controller.dart';

class LisTest extends StatefulWidget {
  const LisTest({super.key});

  @override
  State<LisTest> createState() => _LisTestState();
}

class _LisTestState extends State<LisTest> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Controller>(context, listen: false).listItem();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: Consumer<Controller>(
        builder: (context, value, child) => ListView.builder(
            // physics: NeverScrollableScrollPhysics(),
            itemCount: value.list.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              List list = value.list[index].values.first;
              List datatblerow = [];
              for (var item in list) {
                if (item["p_name"].isNotEmpty) {
                  datatblerow.add(item);
                }
              }
              print("valuess  hhh---$list");
              return Column(
                children: [
                  SizedBox(height: size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        value.list[index].keys.first.toString(),
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Text(
                            'p_name',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'exp_nos',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'nos',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'S_rate',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Total',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black),
                          ),
                        ),
                      ],
                      rows: datatblerow
                          .map((e) => DataRow(cells: [
                                DataCell(
                                  Text(e["p_name"].toString()),
                                ),
                                DataCell(
                                  Text(e["exp_nos"].toString()),
                                ),
                                DataCell(
                                  Text(e["nos"].toString()),
                                ),
                                DataCell(
                                  Text(e["s_rate_1"].toString()),
                                ),
                                DataCell(
                                  Text(e["tot"].toString()),
                                ),
                              ]))
                          .toList(),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

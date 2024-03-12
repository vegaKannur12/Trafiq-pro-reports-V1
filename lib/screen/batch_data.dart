import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/controller/controller.dart';

class Batch_data extends StatefulWidget {
  BuildContext context;
  int id;

  Batch_data({super.key, required this.context, required this.id});

  @override
  State<Batch_data> createState() => _Batch_dataState();
}

class _Batch_dataState extends State<Batch_data> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.blue[300],
          title: Text(
            "Batch List",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(ctx);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) =>
              Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
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
                        searchController.clear();
                        value.setIsSearch(false);
                      },
                      child: Icon(
                        Icons.close,
                        size: 19,
                      ),
                    ),
                  ),
                  controller: searchController,
                  onChanged: (v) => value.searchCustomerList(v),
                ),
              ),
              Divider(),
              value.isLoading
                  ? SpinKitCircle(
                      color: Colors.black,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                  child: Card(
                                semanticContainer: true,
                                elevation: 3,
                                child: ListTile(
                                  tileColor: index.isEven
                                      ? Colors.white
                                      : const Color.fromARGB(
                                          255, 188, 223, 240),
                                  title: Text(
                                    "Batch id:",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Batch Number:",
                                        style: TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                      Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 100,
                                            ),
                                            child: Text(
                                              "Exp:",
                                              style: TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Purchase Rate: 200",
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 100,
                                            ),
                                            child: Text(
                                              "Cost:",
                                              style: TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Srate:",
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Supplier name:",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        "Total stock",
                                        style: TextStyle(
                                          color: Colors.pink,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                            }),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

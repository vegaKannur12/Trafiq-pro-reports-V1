import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/components/date_find.dart';
import 'package:trafiqpro/controller/controller.dart';

class Detail_list extends StatefulWidget {
  const Detail_list({super.key});

  @override
  State<Detail_list> createState() => _Detail_listState();
}

class _Detail_listState extends State<Detail_list> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateFind dateFind = DateFind();
    String? todaydate;
    DateTime now = DateTime.now();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.blue[300],
          title: Text(
            "Product list",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
      body: SingleChildScrollView(
        child: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) =>
              Column(
            children: [
              // Divider(),
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
                            itemCount: value.customer_list.length,
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
                                    "${value.customer_list[index]["Head"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 76, 31, 173)),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${value.customer_list[index]["Group"]}",
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
                                              "hsn: 123",
                                              style: TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Tax: 20%",
                                            style: TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Generic:  abc,def",
                                        style: TextStyle(
                                          color: Colors.red,
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

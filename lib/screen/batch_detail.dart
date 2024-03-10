import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/controller/controller.dart';

class BatchDataList extends StatefulWidget {
  ScrollController scrollController;
  int id;
  BuildContext context;
  BatchDataList(
      {super.key,
      required this.scrollController,
      required this.id,
      required this.context});

  @override
  State<BatchDataList> createState() => _BatchDataListState();
}

class _BatchDataListState extends State<BatchDataList> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext ctx) {
    Size size = MediaQuery.of(ctx).size;

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
                // Navigator.pop(widget.context);
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
          builder: (context, value, child) => Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              value.isLoading
                  ? SpinKitCircle(
                      color: Colors.black,
                    )
                  : value.batch_report.length == 0 &&
                          value.batch_report.length == null
                      ? Container(
                          alignment: Alignment.center,
                          height: size.height * 0.7,
                          child: LottieBuilder.asset(
                            "assets/noData.json",
                            height: size.height * 0.23,
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: value.batch_report.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                // print("producttttttt.......${value.productdetail_report[index]}");
                                multipleValueContainer(
                                    size, value.batch_report[index]),
                                // Text(value.productdetail_report[index]["PRODUCT_NAME"]
                                //     .toString())
                              ],
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Widget multipleValueContainer(Size size, Map<String, dynamic> map) {
    List<Map<String, dynamic>> valueMap = [];
    map.entries.forEach((e) => valueMap.add({e.key: e.value}));
    print("batch values bar-------$map...........$valueMap");

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // width: (size.width * 0.8) * len,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: valueMap
                        .map((item) => Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                VerticalDivider(
                                  color: Colors.transparent,
                                ),
                                Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                        "${item.keys.first.toString().toUpperCase()} :",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black)),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(item.values.first.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                            fontSize: 15))
                                  ],
                                ),
                                VerticalDivider(
                                  color: Colors.transparent,
                                )
                              ],
                            ))
                        .toList()),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

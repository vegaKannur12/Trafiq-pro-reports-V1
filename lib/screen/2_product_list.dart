import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/components/date_find.dart';
import 'package:trafiqpro/controller/controller.dart';
import 'package:trafiqpro/screen/product_detail_table.dart';

class Detail_list extends StatefulWidget {
  Map<String, dynamic> map = {};
  int id;
  String title;
  BuildContext context;
  Detail_list(
      {required this.map,
      required this.id,
      required this.title,
      required this.context});

  @override
  State<Detail_list> createState() => _Detail_listState();
}

class _Detail_listState extends State<Detail_list> {
  ScrollController _scrollController = ScrollController();

  void initState() {
    super.initState();
    Provider.of<Controller>(context, listen: false)
        .getProductBatchList(context, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    // DetailedInfoSheet info = DetailedInfoSheet();

    Size size = MediaQuery.of(context).size;
    DateFind dateFind = DateFind();
    String? todaydate;
    DateTime now = DateTime.now();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) =>
              AppBar(
            backgroundColor: Color.fromARGB(255, 59, 77, 239),
            title: Text(
              "${widget.title}",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            leading: InkWell(
                onTap: () {
                  value.isBatchLoading = false;
                  Navigator.pop(context);
                  // value.isBatchLoading=false;
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
        ),
      ),
      // appBar: Consumer<Controller>(builder: (context, value, child) => ,
      //   AppBar(
      //     backgroundColor: Color.fromARGB(255, 59, 77, 239),
      //     title: Text(
      //       "${widget.title}",
      //       style: TextStyle(
      //           color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      //     ),
      //     leading: InkWell(
      //         onTap: () {
      //           Navigator.pop(context);
      //           value.isBatchLoading=false;
      //         },
      //         child: Icon(
      //           Icons.arrow_back,
      //           color: Colors.white,
      //         )),
      //   ),
      // ),
      body: Stack(
        children: [
          Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("assets/back.png"),
                    fit: BoxFit.fill)),
          ),
          SingleChildScrollView(
            child: Consumer<Controller>(
              builder:
                  (BuildContext context, Controller value, Widget? child) =>
                      Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  value.isLoading
                      ? SpinKitCircle(
                          color: Colors.black,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: size.height * 0.9,
                            child:
                                //  info.showInfoSheet(context, "hai")
                                REport_Table(
                                    scrollController: _scrollController,
                                    id: widget.id,
                                    context: widget.context),
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

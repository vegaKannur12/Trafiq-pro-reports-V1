import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/controller/controller.dart';
import 'package:trafiqpro/screen/dahsboard_report_tile.dart';
import 'package:trafiqpro/screen/db_selection_page.dart';
import 'package:trafiqpro/screen/ledger_report.dart';
import 'package:trafiqpro/screen/product_detail_table.dart';
import 'package:trafiqpro/screen/2_product_list.dart';

class Product_DetailList extends StatefulWidget {
  Map<String, dynamic> map = {};

  BuildContext context;
  // Product_DetailList({required this.map});
  Product_DetailList({super.key, required this.context});

  @override
  State<Product_DetailList> createState() => _Product_DetailListState();
}

class _Product_DetailListState extends State<Product_DetailList> {
  static final GlobalKey<FormState> _key = GlobalKey<FormState>();
  // ScrollController _scrollController = ScrollController();

  double? outstand;

  String? formattedDate;

  List<String> s = [];
  final formKey = GlobalKey<FormState>();
  TextEditingController searchProController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    Size size = MediaQuery.of(ctx).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.blue[300],
          title: Text(
            "Product Details",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              searchProController.clear();
              Provider.of<Controller>(context, listen: false).isSearch = false;
              // value.setIsSearch(false);
            },
            // onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      /////////////////////////////////////////////////////
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage("assets/back.png"),
                      fit: BoxFit.fill)),
            ),
            Consumer<Controller>(
              builder:
                  (BuildContext context, Controller value, Widget? child) =>
                      Column(
                children: [
                  // Text("hai"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      // autofocus: false,
                      style: TextStyle(color: Colors.white),
                      controller: searchProController,
                      onChanged: (v) => value.searchProductNameList(v),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 18),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Colors.yellow, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Colors.yellow, width: 1),
                        ),
                        hintText: 'search here',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.white),
                        suffixIcon: InkWell(
                          onTap: () {
                            searchProController.clear();
                            value.setIsSearch(false);
                          },
                          child: Icon(
                            Icons.close,
                            size: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ////////////////////////////////////
                  value.isProLoading
                      ? SpinKitCircle(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        )
                      : value.productname_list.length == 0
                          ? Container(
                              alignment: Alignment.center,
                              height: size.height * 0.7,
                              child: LottieBuilder.asset(
                                "assets/noData.json",
                                height: size.height * 0.23,
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: value.isSearch
                                      ? value.searchProduct.length
                                      : value.productname_list.length,
                                  itemBuilder: (context, int index) {
                                    return ListTile(
                                      title: Text(
                                        value.isSearch
                                            ? value.searchProduct[index]
                                                ["P_NAME"]
                                            : value.productname_list[index]
                                                ["P_NAME"],
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      leading: CircleAvatar(
                                        child: Icon(
                                          Icons.medical_services_outlined,
                                          color: Colors.white,
                                        ),
                                        backgroundColor: Colors.blue[300],
                                      ),
                                      onTap: () {
                                        int id;
                                        String title;

                                        if (value.isSearch) {
                                          id = value.searchProduct[index]
                                              ["P_ID"];
                                          print("djknjfnjf-----$id");
                                          title = value.searchProduct[index]
                                                  ["P_NAME"]
                                              .toString();
                                        } else {
                                          id = value.productname_list[index]
                                              ["P_ID"];
                                          title = value.productname_list[index]
                                                  ["P_NAME"]
                                              .toString();
                                        }
                                        print("product id..,,$id");
                                        Provider.of<Controller>(context,
                                                listen: false)
                                            .getProductDetailsList(context, id);
                                        Provider.of<Controller>(context,
                                                listen: false)
                                            .getProductBatchList(context, id);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Detail_list(
                                                  map: widget.map,
                                                  id: id,
                                                  title: title,
                                                  context: widget.context,
                                                  searchProController:
                                                      searchProController),
                                            )
                                            // LedgerReport(
                                            //       map: widget.map,
                                            //       id: id,
                                            //       title: title,
                                            // )
                                            // ),
                                            );
                                        print(
                                            "productsearchlist---------${value.searchProduct[index]}");
                                      },
                                    );
                                  }),
                            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

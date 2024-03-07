import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/controller/controller.dart';
import 'package:trafiqpro/screen/db_selection_page.dart';
import 'package:trafiqpro/screen/ledger_report.dart';
import 'package:trafiqpro/screen/product_list.dart';

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
  double? outstand;

  String? formattedDate;

  List<String> s = [];
  final formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();
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
              ////////////////////////////////////
              value.isCusLoading
                  ? SpinKitCircle(
                      color: Colors.black,
                    )
                  : Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: value.isSearch
                              ? value.filteredList.length
                              : value.customer_list.length,
                          itemBuilder: (context, int index) {
                            return ListTile(
                              title: Text(
                                value.isSearch
                                    ? value.filteredList[index]["Head"]
                                    : value.customer_list[index]["Head"],
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              leading: CircleAvatar(
                                child: Icon(
                                  Icons.medical_services_outlined,
                                  color: Colors.white,
                                ),
                                backgroundColor: Colors.blue[300],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Detail_list()
                                      // LedgerReport(
                                      //       map: widget.map,
                                      //       id: id,
                                      //       title: title,
                                      // )
                                      ),
                                );
                                print(
                                    "productlist---------${value.filteredList[index]}");
                              },
                            );
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

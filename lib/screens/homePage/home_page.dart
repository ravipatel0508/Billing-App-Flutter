import 'package:billing_application/data/data.dart';
import 'package:billing_application/provider/item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'pdfGenerator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      body: Consumer<ItemCount>(
        builder: (context, value, child) {
          return Builder(
            builder: (context) {
              return ListView(
                children: <Widget>[
                  createHeader(),
                  createSubTitle(),
                  createCartList(),
                  footer(context, value),
                ],
              );
            },
          );
        },
      ),
    );
  }

  footer(BuildContext context, ItemCount value) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Text(
                  "Total",
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Text(
                  '\$${value.totalCost}',
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          RaisedButton(
            onPressed: () async {
              await pdfGenerator(
                  value.itemName, value.itemPrice, value.itemCount, value.cost);
            },
            color: Colors.green,
            padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: Text(
              "Checkout",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  createHeader() {
    return Container(
      alignment: Alignment.topCenter,
      child: Text(
        "Not Zomato",
        style: GoogleFonts.sansita(fontSize: 40),
      ),
      margin: EdgeInsets.only(left: 12, top: 12),
    );
  }

  createSubTitle() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "Total(3) Items",
      ),
      margin: EdgeInsets.only(left: 12, top: 4),
    );
  }

  createCartList() {
    Data data = Data();

    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: data.itemImage.length,
      itemBuilder: (context, position) {
        return Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        color: Colors.white,
                        image: DecorationImage(
                            image: AssetImage(data.itemImage[position]))),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 8, top: 4),
                            child: Text(
                              context.watch<ItemCount>().itemName[position],
                              maxLines: 2,
                              softWrap: true,
                            ),
                          ),
                          SizedBox(height: 6),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '\$${context.watch<ItemCount>().itemPrice[position]}',
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () => context
                                            .read<ItemCount>()
                                            .decrement(position),
                                        child: Icon(
                                          Icons.remove,
                                          size: 24,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      Container(
                                        color: Colors.grey.shade200,
                                        padding: const EdgeInsets.only(
                                            bottom: 2, right: 12, left: 12),
                                        child: Text(
                                          '${context.watch<ItemCount>().itemCount[position]}',
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => context
                                            .read<ItemCount>()
                                            .increment(position),
                                        child: Icon(
                                          Icons.add,
                                          size: 24,
                                          color: Colors.grey.shade700,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    flex: 100,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 10, top: 8),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: Colors.green),
              ),
            )
          ],
        );
      },
    );
  }
}

import 'dart:developer';

import 'package:billing_application/data/data.dart';
import 'package:billing_application/provider/item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'pdf_generator.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final Data data = Data();

  Widget footer() {
    log('footer');
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Consumer<AppProvider>(builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  child: const Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 30),
                  child: Text(
                    '₹ ${value.totalCost}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                await pdfGenerator(value.itemName, value.itemPrice, value.itemCount, value.cost);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
              ),
              child: const Text(
                "Checkout",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      }),
    );
  }

  Widget createHeader() {
    log('createHeader');
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(left: 12, top: 12),
      child: Text(
        "Not Zomato",
        style: GoogleFonts.sansita(fontSize: 40),
      ),
    );
  }

  Widget createSubTitle() {
    log('createSubTitle');
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 12, top: 4),
      child: Text(
        "Total(${data.itemImage.length}) Items",
      ),
    );
  }

  Widget createCartList() {
    log('createCartList');
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: data.itemImage.length,
      itemBuilder: (context, index) {
        return Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, top: 26),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    data.itemImage[index],
                    height: 80,
                    width: 80,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<AppProvider>(builder: (context, value, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              context.read<AppProvider>().itemName[index],
                              style: const TextStyle(fontSize: 17),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '₹ ${value.itemPrice[index]}',
                                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        iconSize: 20,
                                        onPressed: () => value.decrement(index),
                                        icon: const Icon(Icons.remove),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                        color: Colors.grey.shade200,
                                        padding: const EdgeInsets.only(bottom: 2, right: 12, left: 12),
                                        child: Text(
                                          '${context.watch<AppProvider>().itemCount[index]}',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        iconSize: 20,
                                        onPressed: () => value.increment(index),
                                        icon: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
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
                margin: const EdgeInsets.only(right: 10, top: 15),
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: Colors.green),
                child: InkWell(
                  onTap: () => context.read<AppProvider>().resetItemCount(index),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    log('HomePage');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      body: ListView(
        children: <Widget>[
          createHeader(),
          createSubTitle(),
          createCartList(),
          footer(),
        ],
      ),
    );
  }
}

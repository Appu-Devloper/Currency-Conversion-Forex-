import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pocket_forex/models/ratesmodel.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../functions/fetchrates.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<RatesModel> result;
  late Future<Map> allcurrencies;
  final formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    setState(() {
      result = fetchrates();
      allcurrencies = fetchcurrencies();
      anydropdown.text = "INR";
      anytoany1.text = "USD";
      anytoany2.text = "INR";
    });
  }

  TextEditingController dollorcontroller = TextEditingController();
  TextEditingController anydropdown = TextEditingController();
  TextEditingController anytoany1 = TextEditingController();
  TextEditingController anytoany2 = TextEditingController();

  TextEditingController amountController = TextEditingController();
  String dropdownValue1 = 'USD',
      dropdownValue2 = 'INR',
      output1 = '',
      dropdownValue = 'INR',
      output = '';
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 2, 14, 24),
            title: Text(
              'Pocket Forex',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )),
        body: Container(
          height: h,
          width: w,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/global.png'), fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: FutureBuilder<RatesModel>(
                future: result,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  }
                  return Center(
                    child: FutureBuilder<Map>(
                        future: allcurrencies,
                        builder: (context, currencies) {
                          if (currencies.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: Colors.white,
                            ));
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                child: Container(
                                    constraints: BoxConstraints(maxWidth: 350),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'USD to Any Currency',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextFormField(
                                              key: ValueKey('usd'),
                                              controller: dollorcontroller,
                                              decoration: InputDecoration(
                                                  hintText: 'Enter USD'),
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (val) {
                                                setState(() {
                                                  output = (val.isNotEmpty
                                                          ? val
                                                          : "0") +
                                                      ' USD = ' +
                                                      convertusd(
                                                          snapshot.data!.rates,
                                                          (val.isNotEmpty
                                                              ? val
                                                              : "0"),
                                                          dropdownValue) +
                                                      ' ' +
                                                      dropdownValue;
                                                });
                                              }),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TypeAheadField<String>(
                                                  controller: anydropdown,
                                                  autoFlipMinHeight: 200,
                                                  suggestionsCallback:
                                                      (pattern) async {
                                                    return currencies.data!.keys
                                                        .where((currency) => currency
                                                            .toLowerCase()
                                                            .startsWith(pattern!
                                                                .toLowerCase()))
                                                        .map<String>((currency) =>
                                                            currency
                                                                .toString()) // Convert each element to String
                                                        .toList(); // Convert Iterable<String> to List<String>
                                                  },
                                                  itemBuilder:
                                                      (context, suggestion) {
                                                    return ListTile(
                                                      title: Text(suggestion!),
                                                    );
                                                  },
                                                  onSelected: (suggestion) {
                                                    setState(() {
                                                      anydropdown.text =
                                                          suggestion;
                                                      dropdownValue =
                                                          suggestion;
                                                      output = dollorcontroller
                                                              .text +
                                                          ' USD = ' +
                                                          convertusd(
                                                              snapshot
                                                                  .data!.rates,
                                                              dollorcontroller
                                                                  .text,
                                                              dropdownValue) +
                                                          ' ' +
                                                          dropdownValue;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          Center(child: Text(output))
                                        ])),
                              ),
                              Card(
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 350),
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Convert Any Currency',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextFormField(
                                        key: ValueKey('amount'),
                                        controller: amountController,
                                        decoration: InputDecoration(
                                            hintText: 'Enter Amount'),
                                        keyboardType: TextInputType.number,
                                        onChanged: (val) {
                                          setState(() {
                                            output1 =
                                                (val.isNotEmpty ? val : "0") +
                                                    ' ' +
                                                    dropdownValue1 +
                                                    ' ' +
                                                    convertany(
                                                        snapshot.data!.rates,
                                                        (val.isNotEmpty
                                                            ? val
                                                            : "0"),
                                                        dropdownValue1,
                                                        dropdownValue2) +
                                                    ' ' +
                                                    dropdownValue2;
                                          });
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TypeAheadField<String>(
                                              controller: anytoany1,
                                              autoFlipMinHeight: 200,
                                              suggestionsCallback:
                                                  (pattern) async {
                                                return currencies.data!.keys
                                                    .where((currency) =>
                                                        currency
                                                            .toLowerCase()
                                                            .startsWith(pattern!
                                                                .toLowerCase()))
                                                    .map<String>((currency) =>
                                                        currency
                                                            .toString()) // Convert each element to String
                                                    .toList(); // Convert Iterable<String> to List<String>
                                              },
                                              itemBuilder:
                                                  (context, suggestion) {
                                                return ListTile(
                                                  title: Text(suggestion!),
                                                );
                                              },
                                              onSelected: (suggestion) {
                                                setState(() {
                                                  anytoany1.text = suggestion;
                                                  dropdownValue1 = suggestion;
                                                  output1 = amountController
                                                          .text +
                                                      ' ' +
                                                      dropdownValue1 +
                                                      ' ' +
                                                      convertany(
                                                          snapshot.data!.rates,
                                                          amountController.text,
                                                          dropdownValue1,
                                                          dropdownValue2) +
                                                      ' ' +
                                                      dropdownValue2;
                                                });
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(child: Text('To')),
                                          ),
                                          Expanded(
                                            child: TypeAheadField<String>(
                                              controller: anytoany2,
                                              autoFlipMinHeight: 200,
                                              suggestionsCallback:
                                                  (pattern) async {
                                                return currencies.data!.keys
                                                    .where((currency) =>
                                                        currency
                                                            .toLowerCase()
                                                            .startsWith(pattern!
                                                                .toLowerCase()))
                                                    .map<String>((currency) =>
                                                        currency
                                                            .toString()) // Convert each element to String
                                                    .toList(); // Convert Iterable<String> to List<String>
                                              },
                                              itemBuilder:
                                                  (context, suggestion) {
                                                return ListTile(
                                                  title: Text(suggestion!),
                                                );
                                              },
                                              onSelected: (suggestion) {
                                                setState(() {
                                                  anytoany2.text = suggestion;
                                                  dropdownValue2 = suggestion!;

                                                  output1 = amountController
                                                          .text +
                                                      ' ' +
                                                      dropdownValue1 +
                                                      ' ' +
                                                      convertany(
                                                          snapshot.data!.rates,
                                                          amountController.text,
                                                          dropdownValue1,
                                                          dropdownValue2) +
                                                      ' ' +
                                                      dropdownValue2;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Center(child: Text(output1))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  );
                },
              ),
            ),
          ),
        ));
  }
}

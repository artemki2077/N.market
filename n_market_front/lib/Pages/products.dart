import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
import '../widgets/product.dart';

class Products extends StatefulWidget {
  final String title;
  final bool search;
  final String types;
  final String name;
  final String company;
  final String s;
  const Products(
      {Key? key,
      this.s = '',
      this.title = 'N Market',
      this.search = true,
      this.types = '',
      this.company = '',
      this.name = ''})
      : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  late List products = [];
  Map<String, TextEditingController?> filter_controlers = {
    'price_from': null,
    'price_to': null,
    'company': null,
  };
  Map<String, Icon?> filter_icons = {
    'price_from': const Icon(Icons.monetization_on),
    'price_to': const Icon(Icons.monetization_on_outlined),
    'company': const Icon(Icons.factory_outlined),
  };

  late TextEditingController _controller;
  bool loading = true;
  late String? search_text;
  Map filtering = {
    'price_from': null,
    'price_to': null,
    'company': null,
  };
  var nameSearch = '';
  Future<void> fut_search() async {
    var url = Uri.https('nmarket.artemki2077.repl.co', 'search', {
      'type': widget.types,
      'name': nameSearch,
      'price_from': filtering['price_from'],
      'price_to': filtering['price_to'],
      'company': filtering['company'],
    });
    var response = await http.get(url);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if (decodedResponse['result']) {
      products = decodedResponse['products'] ?? [];
      print(decodedResponse['result']);
      loading = false;
      setState(() {});
    } else {
      print(decodedResponse['answer']);
    }
  }

  void search() async {
    print(nameSearch);
    var url = Uri.https('nmarket.artemki2077.repl.co', 'search', {
      'type': widget.types,
      'name': nameSearch,
      'price_from': filtering['price_from'],
      'price_to': filtering['price_to'],
      'company': filtering['company'],
    });
    var response = await http.get(url);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if (decodedResponse['result']) {
      products = decodedResponse['products'] ?? [];
      print(decodedResponse['result']);
      loading = false;
      setState(() {});
    } else {
      print(decodedResponse['answer']);
    }
  }

  _launchURL(String link) async {
    if (await canLaunchUrlString(link)) {
      await launchUrlString(link);
    } else {
      print('pizdec');
    }
  }

  Widget inputer(context, name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height / 20,
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
        controller: filter_controlers[name],
        onSubmitted: (value) {
          if (value == '') {
            filtering[name] = null;
          } else {
            filtering[name] = value;
          }
          setState(() {});
        },
        keyboardType: ['price_from', 'price_to'].contains(name)
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 3.0),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          prefixIcon: filter_icons[name],
          hintText: name,
        ),
      ),
    );
  }

  String v_price(int s) {
    return s.toString().replaceAllMapped(
        RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => "${match.group(0)} ");
  }

  @override
  void initState() {
    nameSearch = widget.s;
    search();
    _controller = TextEditingController();
    filter_controlers.forEach((key, value) {
      filter_controlers[key] = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70, // Set this height
        flexibleSpace: Container(
          color: Colors.deepPurple,
          child: Column(
            children: const [
              Spacer(
                flex: 8,
              ),
              Text(
                'N Market',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TextField(
              controller: _controller,
              onSubmitted: (value) {
                loading = true;
                nameSearch = value;
                search();
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 3.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              height: MediaQuery.of(context).size.height / 15,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(filtering.length, (index) {
                  return inputer(context, filtering.keys.elementAt(index));
                }),
              )),
          Expanded(
              child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: loading
                  ? const CircularProgressIndicator()
                  : products.isEmpty
                      ? const Text('No data')
                      : RefreshIndicator(
                          onRefresh: () {
                            return fut_search();
                          },
                          child: GridView.builder(
                            itemCount: products.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              var prod = products[index];
                              return Product(
                                  company: prod['company'],
                                  name: prod['name'],
                                  price: prod['price'],
                                  src: prod['img_src'],
                                  link: prod['link']);
                              // return GestureDetector(
                              //   onTap: () {
                              //     _launchURL(prod['link']);
                              //   },
                              //   child: Container(
                              //     padding: const EdgeInsets.all(3),
                              //     decoration: BoxDecoration(
                              //       borderRadius: const BorderRadius.all(
                              //           Radius.circular(5)),
                              //       border: Border.all(
                              //         color: const Color.fromARGB(
                              //             255, 190, 190, 190),
                              //         width: 1,
                              //       ),
                              //     ),
                              //     margin: const EdgeInsets.all(10),
                              //     child: Column(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceAround,
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //         children: [
                              //           Container(
                              //               padding: const EdgeInsets.only(
                              //                   bottom: 5, top: 20),
                              //               height: 160,
                              //               child: Center(
                              //                   child: Image.network(
                              //                       prod['img_src']))),
                              //           Text(
                              //             '${prod['company']} ${prod['name']}',
                              //             style: const TextStyle(
                              //                 fontWeight: FontWeight.bold,
                              //                 fontSize: 12),
                              //           ),
                              //           Text('Цена ${v_price(prod['price'])} руб')
                              //         ]),
                              //   ),
                              // );
                            },
                          ),
                        ),
            ),
          ))
        ],
      ),
    );
  }
}

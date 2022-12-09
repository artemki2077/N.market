import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher_string.dart';


String v_price(int s) {
    return s.toString().replaceAllMapped(
        RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => "${match.group(0)} ");
  }

class Product extends StatelessWidget {
  final String company;
  final String name;
  final int price;
  final String src;
  final String link;
  const Product(
      {Key? key,
      this.company = 'Apple',
      this.name = 'Iphone 14',
      this.price = 1000,
      this.src = '',
      this.link = ''})
      : super(key: key);
  
  _launchURL(String link) async {
    if (await canLaunchUrlString(link)) {
      await launchUrlString(link);
    } else {
      print('pizdec');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchURL(link);
      },
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            color: const Color.fromARGB(255, 190, 190, 190),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.only(bottom: 5, top: 20),
                  height: 160,
                  child: Center(child: Image.network(src))),
              Text(
                '$company $name',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text('Цена ${v_price(price)} руб')
            ]),
      ),
    );
    ;
  }
}

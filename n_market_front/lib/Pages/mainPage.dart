// ignore: file_names
import 'dart:ui';
import 'package:flutter/material.dart';
import '../global.dart' as globals;
import 'products.dart';

class MainPage extends StatelessWidget {
  Map<String, List> structer = <String, List>{
    'main': [
      {
        'img_src': 'https://e-katalogru.ru/jpg/jpg_katalog/wide/447.jpg',
        'href': 'phones',
        'prod': false
      },
      {
        'img_src': 'https://e-katalogru.ru/jpg/jpg_katalog/wide/157.jpg',
        'href': 'monitory',
        'prod': false
      },
      {
        'img_src': 'https://e-katalogru.ru/jpg/jpg_katalog/wide/41.jpg',
        'href': 'audio',
        'prod': false
      },
      
    ],
    'Популярные модели': [
      {
        'img_src': 'https://wishmaster.me/upload/iblock/dbf/dbf905b206817c1f89f977cce2c2fb95.jpeg',
        'href': 'monitory',
        'prod': true
      },
      {
        'img_src': 'https://e-katalogru.ru/images/2110851.jpg',
        'href': 'monitory',
        'prod': true
      },
      {
        'img_src': 'https://wishmaster.me/upload/iblock/00d/00dbf67b836706b6899f1f3923a3ee29.png',
        'href': 'audio',
        'prod': true
      },
    ],
    'Новинки': [
      {
        'img_src': 'https://wishmaster.me/upload/iblock/53a/53a6028a07d62e1a0d2987d74071fea0.jpg',
        'href': 'monitory',
        'prod': true
      },
      {
        'img_src': 'https://wishmaster.me/upload/iblock/475/475183b64d02990c212034589b3b4006.jpeg',
        'href': 'portativnaya_akustika/',
        'prod': true
      },
      {
        'img_src': 'https://e-katalogru.ru/images/1809718.jpg',
        'href': 'portativnaya_akustika/',
        'prod': true
      }
    ],
    'История': globals.Lasts,
  };
  Widget getListBlock(context, name){
    return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: structer[name]!.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Products(
                          search: false,
                          types: structer[name]![index]['href'],
                          name: '',
                          company: ''),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width / 2,
                  child: Image.network(structer[name]!.elementAt(index)['img_src']),
                ),
              ),
            ),
          );
  }
  int index_1 = 0;
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);
  late final ScrollController _controller = ScrollController(initialScrollOffset: structer['main']!.length % 2 == 1 ? ((screenWidth / 2) * structer['main']!.length) - screenWidth / 2: (screenWidth / 2) * structer['main']!.length);
  List<Widget> bulderSmollReact() {
    List<Widget> rtr = [];
    for (var i = 0; i < structer['main']!.length; i++) {
      rtr.add(
        Container(
          color: i == index_1 ? Colors.deepPurple : Colors.black38,
          margin: const EdgeInsets.all(5),
          width: 15,
          height: 5,
        ),
      );
    }
    return rtr;
  }

  @override
  StatelessElement createElement() {
    index_1 = structer['main']!.length ~/ 2;
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 190,
            child: NotificationListener(
              onNotification: (notification) {
                if (notification is ScrollNotification) {
                  var block1Offset = (notification.metrics.pixels + (screenWidth ~/ 2))  ~/ screenWidth;
                  if (block1Offset != index_1) {
                    index_1 = block1Offset;
                    (context as Element).markNeedsBuild();
                  }

                }
                return true;
              },
              child: ListView.builder(
                controller: _controller,
                itemCount: structer['main']?.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Products(
                          search: false,
                          types: structer['main']![index]['href'],
                          name: '',
                          company: ''),
                    ),
                  );
                  },
                  child: Container(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * (structer['main']?.elementAt(index)['size'] ?? 1),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.5),
                      child: Image.network(
                        structer['main']?.elementAt(index)['img_src'],
                        width: MediaQuery.of(context).size.width * (structer['main']?.elementAt(index)['size'] ?? 1),
                        height: MediaQuery.of(context).size.height / 5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: bulderSmollReact()),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: const Text(
              'Популярные модели',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black38,
              ),
            ),
          ),
          getListBlock(context, 'Популярные модели'),
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: const Text(
              'Новинки',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black38,
              ),
            ),
          ),
          getListBlock(context, 'Новинки'),
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: const Text(
              'История',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black38,
              ),
            ),
          ),
          getListBlock(context, 'История'),
          
        ],
      ),
    );
  }
}

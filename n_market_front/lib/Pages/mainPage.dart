import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainPage extends StatelessWidget {


  List<String> srcs_1 = <String>[
    'https://e-katalogru.ru/jpg/jpg_katalog/wide/157.jpg',
    'https://e-katalogru.ru/jpg/jpg_katalog/wide/41.jpg',
    'https://e-katalogru.ru/jpg/jpg_katalog/wide/447.jpg'
  ];
  List<String> srcs_2 = <String>[
    'https://e-katalogru.ru/images/2110851.jpg',
    'https://e-katalogru.ru/images/2104766.jpg',
    'https://e-katalogru.ru/images/1809718.jpg'
  ];
  Map structer = {
    'main': [
      {
        'img_src': 'https://e-katalogru.ru/jpg/jpg_katalog/wide/157.jpg',
        'href': 'search/televizory/monitory'
      },
      {
        'img_src': 'https://e-katalogru.ru/jpg/jpg_katalog/wide/41.jpg',
        'href': 'search/audio/portativnaya_akustika/'
      },
      {
        'img_src': 'https://e-katalogru.ru/jpg/jpg_katalog/wide/447.jpg',
        'href': 'search/audio/portativnaya_akustika/'
      }
    ],
    'Популярные модели': [
      {
        'img_src': 'https://e-katalogru.ru/images/2110851.jpg',
        'href': 'search/televizory/monitory'
      },
      {
        'img_src': 'https://e-katalogru.ru/images/2104766.jpg',
        'href': 'search/audio/portativnaya_akustika/'
      },
      {
        'img_src': 'https://e-katalogru.ru/images/1809718.jpg',
        'href': 'search/audio/portativnaya_akustika/'
      }
    ],
  };
  int index_1 = 0;
  int block_1_offset = 0;
  var screenWidth =
      (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);
  late final ScrollController _controller = ScrollController(initialScrollOffset: srcs_1.length % 2 == 1 ? ((screenWidth / 2) * srcs_1.length) - screenWidth / 2: (screenWidth / 2) * srcs_1.length);
  List<Widget> bulderSmollReact() {
    List<Widget> rtr = [];
    for (var i = 0; i < srcs_1.length; i++) {
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
    index_1 = srcs_1.length ~/ 2;
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
                  block_1_offset = (notification.metrics.pixels + (screenWidth ~/ 2))  ~/ screenWidth;
                  if (block_1_offset != index_1) {
                    index_1 = block_1_offset;
                    (context as Element).markNeedsBuild();
                  }

                }
                return true;
              },
              child: ListView.builder(
                controller: _controller,
                itemCount: srcs_1.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    srcs_1.elementAt(index),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 5,
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
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: srcs_2.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width / 2,
                child: Image.network(srcs_2.elementAt(index)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

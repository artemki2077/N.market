import 'package:flutter/material.dart';
import 'products.dart';

class SearchPage extends StatelessWidget {
  var types = [
    {'title': 'Телефоны', 'type': 'phones'},
    {'title': 'Мониторы', 'type': 'monitory'},
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.separated(
          itemCount: types.length + 1,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: const TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 3.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                  ),
                ),
              );
            }
            return ListTile(
              onTap: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Products('',
                        search: false,
                        types: types[index - 1]['type']!.toString(),
                        name: '',
                        company: ''),
                  ),
                )
              },
              title: Text(
                types[index - 1]['title']!,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(
                Icons.arrow_right_sharp,
                color: Colors.black,
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return const Divider(
                color: Colors.white,
              );
            }
            return const Divider();
          }),
    );
  }
}

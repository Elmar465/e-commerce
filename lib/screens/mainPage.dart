import 'package:dio/dio.dart';
import 'package:e_commerce_flutter/models/products.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const routeName = '/';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final Future<List<Products>> _allProducts;
  @override
  void initState() {
    _allProducts = getProductData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _allProducts,
        // ignore: curly_braces_in_flow_control_structures
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List<Products> items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(children: [
                      Container(
                        height: 100.0,
                        width: 100,
                        child: Text(items[index].id.toString()),
                        // color: Colors.green,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.transparent,
                            image: DecorationImage(
                                image: NetworkImage(items[index].image,),
                                  fit: BoxFit.contain
                                )),
                      ),
                      Expanded(
                          child: ExpansionTile(
                              title: Text(items[index].title),
                              leading: Text(items[index].price.toString()
                              ),
                              subtitle: Text(items[index].description, maxLines: 3,),
                              )
                              )
                    ])
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return CircularProgressIndicator();
          }
        }),
      ),
    );
  }

  Future<List<Products>> getProductData() async {
    try {
      String baseUrl = 'https://fakestoreapi.com';
      var response = await Dio().get('$baseUrl/products');
      var user = (response.data as List);
      List<Products> products =
          user.map((product) => Products.fromJson(product)).toList();
      if (response.statusCode == 200) {
        return products;
      }
      return [];
    } on DioError catch (e) {
      return Future.error(e.message.toString());
    }
  }
}

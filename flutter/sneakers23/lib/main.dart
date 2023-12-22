import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:sneakers23/product.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sneakers23',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MyHomePage(title: 'Sneakers23'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Dio _dio;
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    final options = BaseOptions(
      baseUrl: 'http://localhost:4000/api/v1',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      responseType: ResponseType.plain,
    );
    _dio = Dio(options);
    _products = Future(_fetchProducts);
  }

  Future<List<Product>> _fetchProducts() async {
    try {
      final response = await _dio.get('/products');
      return Product.fromJsonArray(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final ps = snapshot.data!;
                return ListView(
                  children: ps.map(ProductItem.new).toList(),
                );
              } else {
                return const Center(child: Text('No products'));
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
          future: _products,
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            product.assetPath,
            height: 175,
            width: 250,
          ),
          Container(
            margin: const EdgeInsets.all(5),
            height: 175,
            width: 250,
            /*
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            */
            child: Column(
              children: [
                const SizedBox(height: 15),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(product.brand),
                Text(product.color),
                Text('\$${product.priceUsd}'),
                const SizedBox(height: 25),
                const Text(
                  'coming soon ...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

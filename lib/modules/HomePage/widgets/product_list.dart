import 'package:DentaCarts/constants/app_exports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/widgets/product_card.dart';
import '../../../controller/Auth/auth_cubit.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<dynamic> products = [];
  List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/products/'),
        headers: {'Authorization': 'Bearer ${authCubit.token}'},
      );

      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body)['products'];
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }
  }

  void addToCart(
      String productId, String title, dynamic price, String imageUrl) async {
    debugPrint("Adding product to cart: $productId");
    try {
      final authCubit = BlocProvider.of<AuthCubit>(context);
      final response = await http.post(
        Uri.parse('http://localhost:3000/cart/'),
        body: json.encode({
          'productId': productId,
          'qty': 1,
          'title': title,
          'price': price,
          'image': imageUrl
        }),
        headers: {
          'Authorization': 'Bearer ${authCubit.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added to cart successfully!')),
        );

        setState(() {
          cart.add({
            'productId': productId,
            'title': title,
            'price': price,
            'image': imageUrl,
            'qty': 1
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product to cart')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void updateCart(String productId, int qty) {
    setState(() {
      final existingProduct = cart.firstWhere(
        (item) => item['productId'] == productId,
        orElse: () => {},
      );

      if (existingProduct.isNotEmpty) {
        if (qty > 0) {
          existingProduct['qty'] = qty;
        } else {
          cart.remove(existingProduct);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          String prodId = products[index]['_id'] ?? '';
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ProductCard(
                prodId: prodId,
                cartDesign: false,
                name: products[index]['title'],
                price: products[index]['price'].toString(),
                imageUrl: products[index]['image'][0],
                qty: 1,
                onIncrement: () => addToCart(
                  prodId,
                  products[index]['title'],
                  products[index]['price'],
                  products[index]['image'][0],
                ),
                onDecrement: () => updateCart(prodId, 0),
                onRemove: () => updateCart(prodId, 0),
                addToCart: () => addToCart(
                  prodId,
                  products[index]['title'],
                  products[index]['price'],
                  products[index]['image'][0],
                ),
              ));
        },
      ),
    );
  }
}

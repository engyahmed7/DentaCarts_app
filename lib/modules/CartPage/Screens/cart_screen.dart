import 'dart:convert';
import 'package:DentaCarts/constants/app_exports.dart';
import 'package:DentaCarts/core/widgets/product_card.dart';
import 'package:DentaCarts/modules/PaymentGetway/payment_getway_screen.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/cart/'),
        headers: {'Authorization': 'Bearer ${authCubit.token}'},
      );

      if (response.statusCode == 200) {
        // debugPrint("Products fetched: ${response.body}");
        setState(() {
          products = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }
  }

  Future<void> removeFromCart(String productId) async {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/cart/'),
        body: json.encode({'productId': productId}),
        headers: {
          'Authorization': 'Bearer ${authCubit.token}',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          products.removeWhere((item) => item['productId'] == productId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item removed from cart')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove item: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing item: $e')),
      );
    }
  }

  double calculateTotalPrice() {
    double total = 0;
    for (var product in products) {
      total += product['price'] * product['qty'];
    }
    return total;
  }

  Future<void> increaseQuantity(String productId, int currentQty) async {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/cart/'),
        body: json.encode({'qty': currentQty + 1, 'productId': productId}),
        headers: {
          'Authorization': 'Bearer ${authCubit.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          final index =
              products.indexWhere((item) => item['productId'] == productId);
          if (index != -1) {
            products[index]['qty'] = currentQty + 1;
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to increase quantity')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating quantity: $e')),
      );
    }
  }

  Future<void> decreaseQuantity(String productId, int currentQty) async {
    if (currentQty <= 1) {
      removeFromCart(productId);
      return;
    }

    final authCubit = BlocProvider.of<AuthCubit>(context);
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/cart/'),
        body: json.encode({'qty': currentQty - 1, 'productId': productId}),
        headers: {
          'Authorization': 'Bearer ${authCubit.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          final index =
              products.indexWhere((item) => item['productId'] == productId);
          if (index != -1) {
            products[index]['qty'] = currentQty - 1;
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to decrease quantity')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating quantity: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Time to fill it with amazing products!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    double totalPrice = calculateTotalPrice();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ProductCard(
                    cartDesign: true,
                    name: products[index]['name'],
                    price: products[index]['price'].toString(),
                    imageUrl: products[index]['img'],
                    prodId: products[index]['productId'],
                    qty: products[index]['qty'],
                    isFavorite: false,
                    addToCart: () {},
                    onIncrement: () {
                      increaseQuantity(
                          products[index]['productId'], products[index]['qty']);
                    },
                    onDecrement: () {
                      decreaseQuantity(
                          products[index]['productId'], products[index]['qty']);
                    },
                    onRemove: () {
                      removeFromCart(products[index]['productId']);
                    },
                    onFavoritePress: () {},
                  ),
                );
              },
            ),
          ),
          const Divider(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 70),
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const PaymentGetawayScreen()));
            },
            child: Text(
              "CHECKOUT   \$${totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

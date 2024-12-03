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
  Set<String> favoriteProducts = {};

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/wishlist/'),
        headers: {
          'Authorization': 'Bearer ${authCubit.token}',
        },
      );

      debugPrint("Favorites fetched: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> favorites = json.decode(response.body);
        setState(() {
          favoriteProducts =
              favorites.map((f) => f['productId'].toString()).toSet();
        });
      }
    } catch (e) {
      debugPrint("Error fetching favorites: $e");
    }
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

  Future<void> toggleFavorite(String productId) async {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/wishlist/toggle/'),
        body: json.encode({'productId': productId}),
        headers: {
          'Authorization': 'Bearer ${authCubit.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          favoriteProducts.add(productId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to favorites!')),
        );
      } else if (response.statusCode == 204) {
        setState(() {
          favoriteProducts.remove(productId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed from favorites')),
        );
      }
      await fetchFavorites();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating favorites: $e')),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchFavorites();
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
              isFavorite: favoriteProducts.contains(prodId),
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
              onFavoritePress: () => toggleFavorite(prodId),
            ),
          );
        },
      ),
    );
  }
}

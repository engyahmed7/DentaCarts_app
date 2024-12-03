import 'package:DentaCarts/constants/app_exports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/widgets/product_card.dart';
import '../../controller/Auth/auth_cubit.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<dynamic> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/wishlist'),
        headers: {
          'Authorization': 'Bearer ${authCubit.token}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          favorites = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching favorites: $e')),
      );
    }
  }

  Future<void> removeFromFavorites(String productId) async {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/wishlist/toggle'),
        body: json.encode({'productId': productId}),
        headers: {
          'Authorization': 'Bearer ${authCubit.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        setState(() {
          favorites.removeWhere((item) => item['productId'] == productId);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing from favorites: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? const Center(
                  child: Text('No favorites yet'),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final item = favorites[index];
                    return ProductCard(
                      prodId: item['productId'],
                      name: item['name'],
                      price: item['price'].toString(),
                      imageUrl: item['img'][0],
                      cartDesign: false,
                      qty: 1,
                      isFavorite: true,
                      onFavoritePress: () =>
                          removeFromFavorites(item['productId']),
                      addToCart: () {},
                      onIncrement: () {},
                      onDecrement: () {},
                      onRemove: () {},
                    );
                  },
                ),
    );
  }
}

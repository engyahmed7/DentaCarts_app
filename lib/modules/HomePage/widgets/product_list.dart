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
        headers: {'Authorization': 'Bearer ${authCubit.token}'}
      );
      
      debugPrint('HomeScreen: ${json.decode(response.body)}');

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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ProductCard(
              cartDesign: false,
              name: products[index]['title'],
              price: products[index]['price'].toString(),
              imageUrl: products[index]['image'][0], 
            ),
          );
        },
      ),
    );
  }
}

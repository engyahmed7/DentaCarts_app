import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_state.dart';
import '../../../services/cart_api_service.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartLoading());

  Future<void> loadCart() async {
    try {
      final response = await CartApiService().fetchCart();
      final items = response
          .map<Map<String, dynamic>>((item) => {
                'productId': item['productId'] ?? '1',
                'name': item['name'] ?? 'Unknown',
                'price': (item['price'] ?? 0).toDouble(),
                'image': item['img'] ?? 'assets/images/medical.png',
                'rating': (item['rating'] ?? 5.0).toDouble(),
                'reviews': item['reviews']?.toString() ?? "0",
                'qty': (item['qty'] ?? 1),
              })
          .toList();
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void updateQuantity(int index, int change) {
    if (state is CartLoaded) {
      final items =
          List<Map<String, dynamic>>.from((state as CartLoaded).items);
      items[index]['qty'] = (items[index]['qty'] + change).clamp(1, 99);
      emit(CartLoaded(items));
    }
  }

  void addItem(Map<String, dynamic> item) {
    if (state is CartLoaded) {
      final items =
          List<Map<String, dynamic>>.from((state as CartLoaded).items);
      final index = items
          .indexWhere((element) => element['productId'] == item['productId']);
      if (index != -1) {
        items[index]['qty'] += 1;
      } else {
        items.add(item);
      }
      emit(CartLoaded(items));
    }
  }
}

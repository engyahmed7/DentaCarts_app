// wishlist_cubit.dart
import 'package:DentaCarts/admin/services/product_api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final ProductApiService productApiService;

  WishlistCubit(this.productApiService) : super(WishlistLoading());

  Future<void> loadWishlist() async {
    try {
      final wishlist = await productApiService.fetchWishlist();
      emit(WishlistLoaded(wishlist));
    } catch (e) {
      emit(WishlistError("Failed to load wishlist"));
    }
  }

  Future<void> toggleWishlist(String productId) async {
    try {
      final added = await productApiService.toggleWishlist(productId);
      if (state is WishlistLoaded) {
        final currentList = List.from((state as WishlistLoaded).wishlist);
        if (added) {
          await loadWishlist();
        } else {
          currentList.removeWhere((item) => item['productId'] == productId);
          emit(WishlistLoaded(currentList));
        }
      }
    } catch (e) {
      emit(WishlistError("Failed to toggle wishlist"));
    }
  }
}

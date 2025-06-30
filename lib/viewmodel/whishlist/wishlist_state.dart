// wishlist_state.dart
part of 'wishlist_cubit.dart';

@immutable
abstract class WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<dynamic> wishlist;

  WishlistLoaded(this.wishlist);
}

class WishlistError extends WishlistState {
  final String message;

  WishlistError(this.message);
}

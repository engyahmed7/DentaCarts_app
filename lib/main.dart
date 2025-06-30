import 'package:DentaCarts/blocs/whishlist/wishlist_cubit.dart';
import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/blocs/cart/cart_cubit.dart';
import 'package:DentaCarts/services/product_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screen/welcome_screen.dart';

void main() {
  final productApiService = ProductApiService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CartCubit()..loadCart()),
        BlocProvider(
            create: (_) => WishlistCubit(productApiService)..loadWishlist()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      home: WelcomeScreen(),
    );
  }
}

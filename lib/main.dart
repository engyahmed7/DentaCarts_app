import 'package:DentaCarts/admin/services/product_api_service.dart';
import 'package:DentaCarts/admin/view/add_product_screen_admin.dart';
import 'package:DentaCarts/admin/view/login_screen_admin.dart';
import 'package:DentaCarts/viewmodel/cart/cart_cubit.dart';
import 'package:DentaCarts/viewmodel/whishlist/wishlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/layout/layout_screen.dart';
import 'package:DentaCarts/view/login_screen.dart';

void main() {
  runApp(const MyApp());
}

Future<void> saveToken(String token) async {
  if (!kIsWeb) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
}

Future<String?> getSavedToken() async {
  if (!kIsWeb) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppStrings.token = prefs.getString('token');
    return prefs.getString('token');
  }
  return null;
}

Future<bool> hasToken() async {
  String? token = await getSavedToken();
  return token != null && token.isNotEmpty;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CartCubit()..loadCart()),
        BlocProvider(
            create: (_) => WishlistCubit(ProductApiService())..loadWishlist()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        home: kIsWeb
            ? const LoginScreenAdmin()
            : FutureBuilder<bool>(
                future: hasToken(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasData && snapshot.data == true) {
                    return const LayoutScreen();
                  } else {
                    return const LoginScreen();
                  }
                },
              ),
      ),
    );
  }
}

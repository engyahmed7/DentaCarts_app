import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/blocs/cart/cart_cubit.dart';
import 'package:DentaCarts/screen/admin/add_product_screen.dart';
import 'package:DentaCarts/screen/login_screen.dart';
import 'package:DentaCarts/screen/admin/register_screen.dart';
import 'package:DentaCarts/screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BlocProvider(
    create: (_) => CartCubit()..loadCart(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      home: LoginScreen(),
    );
  }
}

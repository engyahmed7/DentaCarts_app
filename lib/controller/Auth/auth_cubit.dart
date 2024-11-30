import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:DentaCarts/Layout/layout_modules.dart';
import 'package:http/http.dart' as http;
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  String token = "";

  Future<void> loginUser(loginEmailController, loginPasswordController, context) async {
    emit(AuthLoginLoadingState());
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": loginEmailController.text,
          "password": loginPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        token = responseData['token'];
        debugPrint(token);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logged in Successfully"), backgroundColor: Colors.green),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LayoutModules()),
        );
        emit(AuthLoginSuccessState());
      } else {
        emit(AuthLoginErrorState(error: response.body));
      }
    } catch (e) {
      emit(AuthLoginErrorState(error: e.toString()));
    }
  }

  Future<void> registerUser(registerPasswordController,confirmPasswordController,registerNameController,registerEmailController,context) async {
    if (registerPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }


    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/signup'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": registerNameController.text,
          "email": registerEmailController.text,
          "password": registerPasswordController.text,
          "gender": "male",
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Registered Successfully. Please login.",
              style: TextStyle(color: Colors.green),
            ),
          ),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration Failed: ${response.body}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Future<void> saveToken(String token) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('authToken', token);
  // }


  // Future<void> checkAuthentication()async{
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('authToken');
  //   if(token != null){
  //     this.token = token;
  //     emit(AuthLoginSuccessState());
  //   }else{
  //     emit(AuthInitial());
  //   }
  //
  // }

  // Future<void> logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove("authToken");
  //   emit(AuthInitial());
  // }

}

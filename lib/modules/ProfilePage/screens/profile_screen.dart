import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const FlutterLogo(
            size: 100,
          ),
          Text("Profile Screen",style: Theme.of(context).textTheme.headlineLarge,),
          const Icon(Icons.person,size: 100,),
        ],
      ),
    );
  }
}

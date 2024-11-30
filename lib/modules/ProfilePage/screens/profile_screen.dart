import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/userModel.dart';
import '../../../services/api_service.dart';
import '../../../controller/Auth/auth_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User?> userProfile;
  final ApiService apiService = ApiService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    userProfile = apiService.getUserProfile(authCubit.token);
  }

  void _showUpdateProfileDialog(User user) {
    usernameController.text = user.username;
    emailController.text = user.email;
    imageController.text = user.image;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                icon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                icon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
                icon: Icon(Icons.image),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await updateProfile();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> updateProfile() async {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    try {
      bool success = await apiService.updateUserProfile(authCubit.token, {
        'username': usernameController.text,
        'email': emailController.text,
        'image': imageController.text,
      });

      if (success) {
        setState(() {
          loadUserProfile();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<User?>(
        future: userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('User not found'));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(user.image),
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(height: 16),
                Text(user.username, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.teal)),
                const SizedBox(height: 8),
                Text(user.email, style: const TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _showUpdateProfileDialog(user),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                    child: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: const Icon(Icons.shopping_cart, color: Colors.teal),
                    title: const Text('Order History', style: TextStyle(fontSize: 18)),
                    subtitle: const Text('View your previous orders'),
                    onTap: () {
                    },
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.red),
                    title: const Text('Favorites', style: TextStyle(fontSize: 18)),
                    subtitle: const Text('View your favorite dental products'),
                    onTap: () {
                    },
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: const Icon(Icons.account_balance_wallet, color: Colors.teal),
                    title: const Text('Wallet', style: TextStyle(fontSize: 18)),
                    subtitle: const Text('Manage your payment methods'),
                    onTap: () {
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/modules/Login/Screens/login_screen.dart';
import '../../../models/userModel.dart';
import '../../../services/api_service.dart';

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
    String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MjFkOTUyOTcyMGNlZTM5OTQ5NWY0ZiIsImVtYWlsIjoiZW5nZ3k0QGdtYWlsLmNvbSIsInJvbGUiOiJ1c2VyIiwidXNlcm5hbWUiOiJlbmd5eTMiLCJ2ZXJpZmllZCI6dHJ1ZSwiaWF0IjoxNzMwMjgyMDA3LCJleHAiOjE3MzAzNjg0MDd9.J_2ksmDqYfBS15f055twUJt78Afvp0NlTofJs_NjU2U';
    userProfile = apiService.getUserProfile(token);
  }

  void _showUpdateProfileDialog(User user) {
    usernameController.text = user.username;
    emailController.text = user.email;
    imageController.text = user.image;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              updateProfile();
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> updateProfile() async {
    try {
      String token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MjFkOTUyOTcyMGNlZTM5OTQ5NWY0ZiIsImVtYWlsIjoiZW5nZ3k0QGdtYWlsLmNvbSIsInJvbGUiOiJ1c2VyIiwidXNlcm5hbWUiOiJlbmd5eTMiLCJ2ZXJpZmllZCI6dHJ1ZSwiaWF0IjoxNzMwMjgyMDA3LCJleHAiOjE3MzAzNjg0MDd9.J_2ksmDqYfBS15f055twUJt78Afvp0NlTofJs_NjU2U';
      bool success = await apiService.updateUserProfile(token, {
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

  void _handleLogout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  radius: 60,
                  backgroundImage: NetworkImage(user.image),
                ),
                const SizedBox(height: 16),
                Text(
                  user.username,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _showUpdateProfileDialog(user),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Update Profile"),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _handleLogout,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    imageController.dispose();
    super.dispose();
  }
}

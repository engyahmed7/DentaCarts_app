import 'dart:convert';
import 'dart:io';
import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/icons/my_flutter_app_icons.dart';
import 'package:DentaCarts/model/user_model.dart';
import 'package:DentaCarts/view/login_screen.dart';
import 'package:DentaCarts/view/order_history_screen.dart';
import 'package:DentaCarts/view/welcome_screen.dart';
import 'package:DentaCarts/view/wishlist/wishlist_screen.dart';
import 'package:DentaCarts/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;
  bool isLoading = true;
  // File? _imageFile;
  // bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    setState(() => isLoading = true);
    UserModel? fetchedUser = await getProfileData();
    setState(() {
      user = fetchedUser;
      isLoading = false;
    });
  }

  //
  // Future<void> pickImage() async {
  //   if (_isPickingImage) return;
  //
  //   setState(() {
  //     _isPickingImage = true;
  //   });
  //
  //   try {
  //     final pickedFile =
  //         await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       setState(() {
  //         _imageFile = File(pickedFile.path);
  //       });
  //     }
  //   } catch (e) {
  //     print("Error picking image: $e");
  //   } finally {
  //     setState(() {
  //       _isPickingImage = false;
  //     });
  //   }
  // }
  //
  // void showEditProfileDialog() {
  //   TextEditingController usernameController =
  //       TextEditingController(text: user?.username);
  //   TextEditingController emailController =
  //       TextEditingController(text: user?.email);
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("Edit Profile"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: usernameController,
  //               decoration: const InputDecoration(labelText: "Username"),
  //             ),
  //             TextField(
  //               controller: emailController,
  //               decoration: const InputDecoration(labelText: "Email"),
  //             ),
  //             const SizedBox(height: 10),
  //             ElevatedButton.icon(
  //               onPressed: _isPickingImage ? null : pickImage,
  //               icon: const Icon(Icons.image),
  //               label: const Text("Pick Profile Image"),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text("Cancel"),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               Navigator.of(context).pop();
  //               await updateUserProfile(
  //                 usernameController.text.trim(),
  //                 emailController.text.trim(),
  //                 _imageFile,
  //               );
  //             },
  //             child: const Text("Save"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  //
  // Future<void> updateUserProfile(
  //     String username, String email, File? imageFile) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   try {
  //     User? updatedUser =
  //         await ApiService().updateUserProfile(username, email, imageFile);
  //
  //     if (updatedUser != null) {
  //       setState(() {
  //         user = updatedUser;
  //         _imageFile = null;
  //       });
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Failed to update profile")),
  //       );
  //     }
  //   } catch (e) {
  //     print("Error updating profile: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content: Text("An error occurred while updating profile")),
  //     );
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -250,
          right: -250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE9E8).withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 650,
                height: 650,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFDE9E8).withOpacity(0.8),
                    width: 4,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 130,
                    width: 130,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.secondaryColor,
                        ],
                        center: Alignment.topCenter,
                        radius: 1.5,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primaryColor,
                    backgroundImage: (user?.image.isNotEmpty == true)
                        ? NetworkImage(user!.image)
                        : null,
                    child: (user?.image == null || user!.image.isEmpty)
                        ? Text(
                      user?.username.isNotEmpty == true
                          ? user!.username[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.poppins(
                        fontSize: 44,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : null,
                  ),

                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: GestureDetector(
                      onTap: (){},//showEditProfileDialog,
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.edit, color: Colors.black, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                user?.username.isNotEmpty == true ? user!.username : "Unknown",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                user?.email.isNotEmpty == true ? user!.email : "Unknown",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              ProfileOptionCard(
                icon: Icons.shopping_cart,
                title: "Order History",
                subtitle: "View your previous orders",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const OrderHistoryScreen()),
                  );
                },
              ),
              ProfileOptionCard(
                icon: Icons.favorite,
                title: "Wishlist",
                subtitle: "View your favourite products",
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const WishlistScreen()),
                    (route) => false,
                  );
                },
              ),
              FloatingActionButton(
                onPressed: () async {
                  const String phoneNumber = "+201114621092";
                  final Uri whatsappUri =
                      Uri.parse("https://wa.me/$phoneNumber");

                  if (await canLaunchUrl(whatsappUri)) {
                    await launchUrl(whatsappUri,
                        mode: LaunchMode.externalApplication);
                  } else {
                    debugPrint("Could not launch WhatsApp.");
                  }
                },
                backgroundColor: Colors.green,
                child: const Icon(
                  MyFlutterApp.noun_whatsapp_6843546,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          "Log Out",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        content: const Text(
                          "Are you sure you want to log out?",
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {


                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Logged out successfully"),
                                  backgroundColor: AppColors.primaryColor,
                                ),
                              );
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                                (route) => false,
                              );


                            },
                            child: const Text(
                              "Confirm",
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  "Log Out",
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ProfileOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: AppColors.secondaryColor,
          elevation: 1,
          child: ListTile(
            contentPadding: const EdgeInsets.all(20),
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              child: Icon(icon, color: Colors.white),
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black54),
          ),
        ),
      ),
    );
  }
}



Future<UserModel?> getProfileData() async {
  final response = await http.get(
    Uri.parse('${AppStrings.baseUrl}/api/profile'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppStrings.token}',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return UserModel.fromJson(data);
  } else {
    // Handle errors here (e.g. return null or throw)
    return null;
  }
}

import 'dart:convert';

import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/model/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<BannerModel?>(
      future: getBanner(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading banner'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No banner available'));
        } else {
          BannerModel? bannerModel = snapshot.data;
           return Column(
            children: [
              const SizedBox(height: 35),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE9E8),
                  borderRadius: BorderRadius.circular(16),
                  image:  DecorationImage(
                    image: NetworkImage(
                      "${bannerModel?.homeBanner}",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${bannerModel?.homeTitle}",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${bannerModel?.homeSubtitle}",
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: screenWidth * -0.07,
                      bottom: screenHeight * -0.02,
                      child: Image.asset(
                        'assets/images/banner.png',
                        height: 240,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}


Future<BannerModel?> getBanner() async {
  final response = await http.get(
    Uri.parse('${AppStrings.baseUrl}/api/settings/home'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return BannerModel.fromJson(data);
  } else {
    return null;
  }
}
import 'package:DentaCarts/admin/widgets/components/home_settings_content.dart';
import 'package:flutter/material.dart';
import 'package:DentaCarts/model/homeModel.dart';

class HomeScreenSettingsForm extends StatelessWidget {
  final Future<HomeSettings> Function() fetchHomeSettings;
  final String? token;

  const HomeScreenSettingsForm({
    super.key,
    required this.fetchHomeSettings,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomeSettings>(
      future: fetchHomeSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data found.'));
        }

        final settings = snapshot.data!;
        return HomeSettingsContent(
          settings: settings,
          token: token,
        );
      },
    );
  }
}

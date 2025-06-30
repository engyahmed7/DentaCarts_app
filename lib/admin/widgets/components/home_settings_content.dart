import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/model/homeModel.dart';

class HomeSettingsContent extends StatefulWidget {
  final HomeSettings settings;
  final String? token;

  const HomeSettingsContent({
    super.key,
    required this.settings,
    required this.token,
  });

  @override
  State<HomeSettingsContent> createState() => _HomeSettingsContentState();
}

class _HomeSettingsContentState extends State<HomeSettingsContent> {
  late TextEditingController titleController;
  late TextEditingController subtitleController;
  html.File? selectedBannerImage;
  String? currentBannerUrl;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.settings.homeTitle);
    subtitleController =
        TextEditingController(text: widget.settings.homeSubtitle);
    currentBannerUrl = widget.settings.homeBanner;
  }

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTitle(),
          const SizedBox(height: 24),
          _buildSettingCard("Home Title", titleController),
          const SizedBox(height: 20),
          _buildSettingCard("Home Subtitle", subtitleController),
          const SizedBox(height: 20),
          _buildBannerUploadCard(),
          const SizedBox(height: 30),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      "Manage Home Screen",
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSettingCard(String label, TextEditingController controller) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 6,
      shadowColor: AppColors.primaryColor.withOpacity(0.4),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: _labelTextStyle()),
            const SizedBox(height: 8),
            _styledTextField(controller: controller),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerUploadCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 6,
      shadowColor: AppColors.primaryColor.withOpacity(0.4),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBannerHeader(),
            const SizedBox(height: 12),
            _buildBannerUploader(),
            if (currentBannerUrl != null &&
                currentBannerUrl!.isNotEmpty &&
                selectedBannerImage == null) ...[
              const SizedBox(height: 16),
              Text(
                "Current Banner:",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              _buildCurrentBannerPreview(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBannerHeader() {
    return Row(
      children: [
        Text("Banner Image", style: _labelTextStyle()),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Text(
            "Max 2MB",
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerUploader() {
    return GestureDetector(
      onTap: isSaving ? null : _pickBannerImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.6),
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.secondaryColor.withOpacity(0.3),
        ),
        child: selectedBannerImage != null
            ? _buildSelectedImagePreview()
            : _buildUploadPlaceholder(),
      ),
    );
  }

  Widget _buildSelectedImagePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            html.Url.createObjectUrl(selectedBannerImage!),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              onPressed: isSaving
                  ? null
                  : () {
                      setState(() {
                        selectedBannerImage = null;
                      });
                    },
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  "New Banner Selected",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.cloud_upload_outlined,
          color: AppColors.primaryColor,
          size: 48,
        ),
        const SizedBox(height: 12),
        Text(
          "Upload Banner Image",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Click to select an image file\nRecommended: 1200x400px",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
          ),
          child: Text(
            "JPEG, PNG, JPG, GIF up to 2MB",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentBannerPreview() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              currentBannerUrl!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image,
                          color: Colors.grey.shade400, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        "Failed to load current banner",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey.shade100,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Current",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      shadowColor: AppColors.primaryColor.withOpacity(0.6),
      color: AppColors.primaryColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: isSaving ? null : _saveSettings,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          alignment: Alignment.center,
          child: isSaving
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Saving Settings...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : const Text(
                  "Save Settings",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
        ),
      ),
    );
  }

  TextStyle _labelTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Color(0xFF8B0000),
    );
  }

  Widget _styledTextField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: AppColors.secondaryColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppColors.primaryColor.withOpacity(0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
    );
  }

  Future<void> _pickBannerImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 400,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        if (bytes.length > 2 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image size should be less than 2MB'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        final fileName = pickedFile.name.toLowerCase();
        final allowedExtensions = ['jpeg', 'jpg', 'png', 'gif'];
        final isValidType =
            allowedExtensions.any((ext) => fileName.endsWith('.$ext'));

        if (!isValidType) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Please select a valid image file (JPEG, PNG, JPG, GIF)'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        final htmlFile = html.File([bytes], pickedFile.name);
        setState(() {
          selectedBannerImage = htmlFile;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveSettings() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Home title is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (subtitleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Home subtitle is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() {
        isSaving = true;
      });

      var request = http.MultipartRequest(
        'post',
        Uri.parse('http://127.0.0.1:8000/api/settings/home'),
      );

      if (widget.token != null) {
        request.headers['Authorization'] = 'Bearer ${widget.token}';
      }

      request.fields['home_title'] = titleController.text.trim();
      request.fields['home_subtitle'] = subtitleController.text.trim();

      if (selectedBannerImage != null) {
        final bytes = await _fileToBytes(selectedBannerImage!);
        request.files.add(
          http.MultipartFile.fromBytes(
            'home_banner',
            bytes,
            filename: selectedBannerImage!.name,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (selectedBannerImage != null) {
          await _refreshSettings();
        }

        setState(() {
          selectedBannerImage = null;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  responseData['message'] ?? 'Settings updated successfully!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update settings');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error saving settings: $e"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> _refreshSettings() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/settings/home'),
        headers: {
          if (widget.token != null) "Authorization": "Bearer ${widget.token}",
        },
      );

      if (response.statusCode == 200) {
        final settings = HomeSettings.fromJson(json.decode(response.body));
        setState(() {
          currentBannerUrl = settings.homeBanner;
          titleController.text = settings.homeTitle;
          subtitleController.text = settings.homeSubtitle;
        });
      }
    } catch (e) {
      print('Error refreshing settings: $e');
    }
  }

  Future<Uint8List> _fileToBytes(html.File file) async {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoad.first;
    return reader.result as Uint8List;
  }
}

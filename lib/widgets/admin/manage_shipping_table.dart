import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/services/shipping_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:country_picker/country_picker.dart';

class ManageShippingTable extends StatefulWidget {
  const ManageShippingTable({Key? key}) : super(key: key);

  @override
  _ManageShippingTableState createState() => _ManageShippingTableState();
}

class _ManageShippingTableState extends State<ManageShippingTable>
    with TickerProviderStateMixin {
  final _apiService = ShippingApiService();
  final TextEditingController _feeController = TextEditingController();
  final List<String> _selectedGovernorates = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<String> allGovernorates = [];
  String? _message;
  AlertType? _alertType;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _loadGovernorates();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  Future<void> _loadGovernorates() async {
    setState(() => _loading = true);
    try {
      final result = await _apiService.getGovernorates();
      setState(() {
        allGovernorates = result;
        _animationController.forward();
      });
    } catch (e) {
      _showAlert(
          "Failed to load governorates. Please try again.", AlertType.error);
    }
    setState(() => _loading = false);
  }

  void _showAlert(String message, AlertType type) {
    setState(() {
      _message = message;
      _alertType = type;
    });

    if (type == AlertType.success) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _message = null;
            _alertType = null;
          });
        }
      });
    }
  }

  Future<void> _submitShippingFee() async {
    setState(() {
      _message = null;
      _alertType = null;
    });

    if (_selectedGovernorates.isEmpty) {
      _showAlert("Please select at least one governorate.", AlertType.warning);
      return;
    }

    if (_feeController.text.trim().isEmpty) {
      _showAlert("Please enter the shipping fee.", AlertType.warning);
      return;
    }

    final fee = double.tryParse(_feeController.text.trim());
    if (fee == null || fee < 0) {
      _showAlert(
          "Please enter a valid shipping fee (must be a positive number).",
          AlertType.error);
      return;
    }

    setState(() => _loading = true);

    try {
      bool allSucceeded = true;
      List<String> failedGovernorates = [];

      for (final gov in _selectedGovernorates) {
        final success = await _apiService.submitShippingFee(
          governorate: gov,
          fee: fee,
        );
        if (!success) {
          allSucceeded = false;
          failedGovernorates.add(gov);
        }
      }

      if (allSucceeded) {
        _showAlert(
          "✅ Shipping fees updated successfully for ${_selectedGovernorates.length} governorate(s)!",
          AlertType.success,
        );
        setState(() {
          _selectedGovernorates.clear();
          _feeController.clear();
        });
      } else {
        _showAlert(
          "⚠️ Some fees failed to save for: ${failedGovernorates.join(', ')}. Please try again.",
          AlertType.error,
        );
      }
    } catch (e) {
      _showAlert(
        "❌ Failed to submit shipping fees. Please check your connection and try again.",
        AlertType.error,
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Manage Shipping Fees",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
      body: _loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Loading governorates...",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Colors.grey[50]!,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.local_shipping_rounded,
                                  color: AppColors.primaryColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Shipping Configuration",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Set shipping fees for different governorates",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_message != null && _alertType != null)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: _buildAlertCard(_message!, _alertType!),
                      ),
                    const Text(
                      "Select Governorates",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Choose the governorates where you want to apply the shipping fee",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (allGovernorates.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_selectedGovernorates.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color:
                                        AppColors.primaryColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.primaryColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "${_selectedGovernorates.length} governorate(s) selected",
                                        style: const TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            MultiSelectContainer(
                              items: allGovernorates
                                  .map((gov) => MultiSelectCard(
                                        value: gov,
                                        label: gov,
                                        decorations: MultiSelectItemDecorations(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey[300]!),
                                          ),
                                          selectedDecoration: BoxDecoration(
                                            color: AppColors.primaryColor
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: AppColors.primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChange: (List<String> selected, _) {
                                setState(() {
                                  _selectedGovernorates
                                    ..clear()
                                    ..addAll(selected);
                                });
                              },
                              highlightColor:
                                  AppColors.primaryColor.withOpacity(0.1),
                              textStyles: MultiSelectTextStyles(
                                textStyle: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                                selectedTextStyle: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                    const Text(
                      "Shipping Fee",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Enter the shipping fee amount in Egyptian Pounds (EGP)",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _feeController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Enter shipping fee',
                          hintText: '0.00',
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.attach_money_rounded,
                              color: AppColors.primaryColor,
                              size: 20,
                            ),
                          ),
                          suffixText: 'EGP',
                          suffixStyle: const TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primaryColor,
                            AppColors.primaryColor.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.save_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Update Shipping Fees',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: _loading ? null : _submitShippingFee,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAlertCard(String message, AlertType type) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData icon;

    switch (type) {
      case AlertType.success:
        backgroundColor = const Color(0xFFF0FDF4);
        borderColor = const Color(0xFF22C55E);
        textColor = const Color(0xFF15803D);
        icon = Icons.check_circle_rounded;
        break;
      case AlertType.warning:
        backgroundColor = const Color(0xFFFFFBEB);
        borderColor = const Color(0xFFF59E0B);
        textColor = const Color(0xFFD97706);
        icon = Icons.warning_rounded;
        break;
      case AlertType.error:
        backgroundColor = const Color(0xFFFEF2F2);
        borderColor = const Color(0xFFEF4444);
        textColor = const Color(0xFFDC2626);
        icon = Icons.error_rounded;
        break;
      case AlertType.info:
        backgroundColor = const Color(0xFFF0F9FF);
        borderColor = const Color(0xFF3B82F6);
        textColor = const Color(0xFF1D4ED8);
        icon = Icons.info_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: borderColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          if (type != AlertType.success)
            GestureDetector(
              onTap: () {
                setState(() {
                  _message = null;
                  _alertType = null;
                });
              },
              child: Icon(
                Icons.close_rounded,
                color: borderColor,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}

enum AlertType {
  success,
  warning,
  error,
  info,
}

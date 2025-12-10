import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_themes.dart';
import '../../routes/app_routes.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../models/user_model.dart';

class DeliveryProfileView extends StatefulWidget {
  const DeliveryProfileView({super.key});

  @override
  State<DeliveryProfileView> createState() => _DeliveryProfileViewState();
}

class _DeliveryProfileViewState extends State<DeliveryProfileView> {
  int _selectedNavIndex = 2;
  bool _isEditing = false;
  bool _hasLoadedUser = false;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _contactController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _contactController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserViewModel>().loadCurrentUser();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _fillControllers(UserModel user) {
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _contactController.text = user.phoneNumber ?? '';
    _emailController.text = user.email;
    _addressController.text = user.address;
    _hasLoadedUser = true;
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    if (picked == null) return;

    setState(() => _profileImage = File(picked.path));
    final viewModel = context.read<UserViewModel>();
    final ok = await viewModel.uploadProfileImage(_profileImage!);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Profile image updated successfully' : (viewModel.errorMessage ?? 'Failed to upload image')),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _saveProfile() async {
    final viewModel = context.read<UserViewModel>();
    final ok = await viewModel.updateProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phoneNumber: _contactController.text.trim(),
      address: _addressController.text.trim(),
    );

    if (!mounted) return;
    if (ok) {
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? 'Failed to update profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onNavItemTapped(int index) {
    if (_selectedNavIndex == index) return;
    setState(() => _selectedNavIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.deliveryHome);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.deliveryRides);
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.deliverySettings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (_, viewModel, __) {
        final user = viewModel.currentUser;
        if (user != null && !_hasLoadedUser) {
          _fillControllers(user);
        }

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            _buildAvatar(user),
                            const SizedBox(height: 32),
                            _buildForm(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.deliveryHome),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.primary),
                ),
              ),
              const Expanded(
                child: Text(
                  'Profile Information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(UserModel? user) {
    final imageUrl = user?.profileImageUrl;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[300],
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!)
                : (imageUrl != null ? NetworkImage(imageUrl) : null) as ImageProvider?,
            child: (_profileImage == null && imageUrl == null)
                ? Icon(Icons.person, size: 60, color: Colors.grey[600])
                : null,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6B8E23),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!_isEditing)
                TextButton.icon(
                  onPressed: () => setState(() => _isEditing = true),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(foregroundColor: const Color(0xFF6B8E23)),
                )
              else ...[
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                      _hasLoadedUser = false;
                    });
                    context.read<UserViewModel>().loadCurrentUser();
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B8E23),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          _field('First Name', _firstNameController, Icons.person_outline),
          const SizedBox(height: 16),
          _field('Last Name', _lastNameController, Icons.person_outline),
          const SizedBox(height: 16),
          _field(
            'Contact Number',
            _contactController,
            Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _field(
            'Email',
            _emailController,
            Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            enabled: false,
          ),
          const SizedBox(height: 16),
          _field('Address', _addressController, Icons.location_on_outlined),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            enabled: _isEditing && enabled,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
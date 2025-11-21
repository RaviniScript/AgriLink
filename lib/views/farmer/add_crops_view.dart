import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_themes.dart';
import '../../viewmodels/crop_viewmodel.dart';

class AddCropsView extends StatefulWidget {
  const AddCropsView({Key? key}) : super(key: key);

  @override
  State<AddCropsView> createState() => _AddCropsViewState();
}

class _AddCropsViewState extends State<AddCropsView> {
  File? _selectedImage;
  bool _isLoading = false;
  String _selectedCategory = 'Vegetable';
  String? _selectedCropName;
  final TextEditingController _quantityController = TextEditingController(text: '100');
  final TextEditingController _amountController = TextEditingController();

  final List<String> _categories = ['Vegetable', 'Fruit', 'Grain', 'Legume'];
  final Map<String, List<String>> _cropsByCategory = {
    'Vegetable': ['Carrot', 'Tomato', 'Potato', 'Onion', 'Cabbage'],
    'Fruit': ['Apple', 'Banana', 'Orange', 'Mango', 'Grapes'],
    'Grain': ['Rice', 'Wheat', 'Corn', 'Barley', 'Oats'],
    'Legume': ['Lentils', 'Chickpeas', 'Beans', 'Peas', 'Soybeans'],
  };

  Future<void> _pickImageFromCamera() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() => _selectedImage = File(image.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking photo: $e')),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() => _selectedImage = File(image.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Image Source',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleAdd() async {
    if (_selectedImage == null) {
      _showMessage('Please select an image');
      return;
    }

    if (_selectedCropName == null) {
      _showMessage('Please select a crop name');
      return;
    }

    if (_amountController.text.isEmpty) {
      _showMessage('Please enter amount');
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      final ownerId = FirebaseAuth.instance.currentUser?.uid ?? 'demo_farmer';

      final vm = Provider.of<CropViewModel>(context, listen: false);
      final qty = double.tryParse(_quantityController.text) ?? 0.0;
      final amt = double.tryParse(_amountController.text) ?? 0.0;
      await vm.addCrop(
        name: _selectedCropName ?? '',
        category: _selectedCategory,
        quantity: qty,
        amount: amt,
        imageFile: _selectedImage!,
        ownerId: ownerId,
      );

      _showMessage('Crop added successfully!', isSuccess: true);
      Navigator.pop(context);
    } catch (e) {
      _showMessage('Error adding crop: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String msg, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isSuccess ? AppColors.success : Colors.redAccent,
      ),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          // ---------------- APP BAR ----------------
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A000000),
                  offset: Offset(0, 2),
                  blurRadius: 8,
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
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Post New Item',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ---------------- IMAGE PICKER ----------------
          GestureDetector(
            onTap: _showImageSourceDialog,
            child: Stack(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: _selectedImage != null
                        ? Image.file(_selectedImage!, fit: BoxFit.cover)
                        : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey[100]!, Colors.grey[50]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.info,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),

          // ---------------- FORM CONTENT ----------------
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CATEGORY
                    const Text('Category',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    _buildDropdown<String>(
                      value: _selectedCategory,
                      items: _categories,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                          _selectedCropName = null;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // CROP NAME
                    const Text('Crop Name',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    _buildDropdown<String>(
                      value: _selectedCropName,
                      hint: 'Select crop name',
                      items: _cropsByCategory[_selectedCategory]!,
                      onChanged: (value) => setState(() => _selectedCropName = value),
                    ),
                    const SizedBox(height: 20),

                    // QUANTITY
                    const Text('Quantity',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_quantityController)),
                        const SizedBox(width: 12),
                        _unitBox('kg'),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // AMOUNT
                    const Text('Amount',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _unitBox('Rs'),
                        Expanded(child: _buildTextField(_amountController, hint: "Per 1kg")),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // ---------------- BUTTONS (UPDATED WITH AppThemes) ----------------
                    Row(
                      children: [
                        Expanded(
                          child: _mainButton(
                            'Cancel',
                            AppColors.primary,
                                () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _mainButton(
                            'Add',
                            AppColors.primaryDark,
                            _isLoading ? null : _handleAdd,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required List<T> items,
    required Function(T?) onChanged,
    String? hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        dropdownColor: Colors.white,
        hint: hint != null ? Text(hint) : null,
        items: items
            .map((item) => DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {String? hint}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _unitBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFD6D6D6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
    );
  }

  // ---------------- UPDATED BUTTON STYLE USING APP THEME ----------------
  Widget _mainButton(String text, Color color, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Text(
        text,
        style: AppTextStyles.button,
      ),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}

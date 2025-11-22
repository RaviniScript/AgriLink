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
  List<File> _selectedImages = []; // Changed to list for multiple images
  bool _isLoading = false;
  String _selectedCategory = 'vegetables'; // Match buyer categories (lowercase, plural)
  String _selectedUnit = 'kg'; // Default unit
  final TextEditingController _cropNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(text: '100');
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  final List<String> _categories = ['vegetables', 'fruits']; // Match buyer categories
  final List<String> _units = ['kg', 'g'];
  final int maxImages = 5; // Maximum 5 images allowed

  Future<void> _pickImageFromCamera() async {
    if (_selectedImages.length >= maxImages) {
      _showMessage('Maximum $maxImages images allowed');
      return;
    }
    
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() => _selectedImages.add(File(image.path)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking photo: $e')),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    if (_selectedImages.length >= maxImages) {
      _showMessage('Maximum $maxImages images allowed');
      return;
    }
    
    try {
      final picker = ImagePicker();
      final images = await picker.pickMultiImage(
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        setState(() {
          for (var image in images) {
            if (_selectedImages.length < maxImages) {
              _selectedImages.add(File(image.path));
            }
          }
        });
        
        if (images.length > maxImages - (_selectedImages.length - images.length)) {
          _showMessage('Added ${images.length} images. Maximum $maxImages images allowed');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
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
    if (_selectedImages.isEmpty) {
      _showMessage('Please select at least one image');
      return;
    }

    if (_selectedImages.length < 3) {
      _showMessage('Please add at least 3 images for better presentation');
      return;
    }

    if (_cropNameController.text.trim().isEmpty) {
      _showMessage('Please enter a crop name');
      return;
    }

    if (_amountController.text.isEmpty) {
      _showMessage('Please enter amount');
      return;
    }

    if (_cityController.text.trim().isEmpty) {
      _showMessage('Please enter city');
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
      
      // First image is the main image, rest are additional
      await vm.addCrop(
        name: _cropNameController.text.trim(),
        category: _selectedCategory,
        quantity: qty,
        unit: _selectedUnit,
        amount: amt,
        imageFile: _selectedImages.first,
        additionalImages: _selectedImages.length > 1 ? _selectedImages.sublist(1) : null,
        city: _cityController.text.trim(),
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

          // ---------------- MULTIPLE IMAGES PICKER ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Crop Images (${_selectedImages.length}/$maxImages)',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Min 3 images',
                      style: TextStyle(
                        fontSize: 12,
                        color: _selectedImages.length >= 3 ? AppColors.success : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _selectedImages.length) {
                        // Add image button
                        return GestureDetector(
                          onTap: _selectedImages.length < maxImages ? _showImageSourceDialog : null,
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: _selectedImages.length < maxImages 
                                  ? const Color(0xFFE8F5E9)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 40,
                                  color: _selectedImages.length < maxImages 
                                      ? AppColors.primary 
                                      : Colors.grey,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _selectedImages.length < maxImages 
                                      ? 'Add Photo' 
                                      : 'Max Reached',
                                  style: TextStyle(
                                    color: _selectedImages.length < maxImages 
                                        ? AppColors.primary 
                                        : Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      
                      // Display selected image
                      return Stack(
                        children: [
                          Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: index == 0 ? AppColors.primary : Colors.grey[300]!,
                                width: index == 0 ? 3 : 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _selectedImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (index == 0)
                            Positioned(
                              top: 4,
                              left: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Main',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            top: 4,
                            right: 16,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

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
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // CROP NAME
                    const Text('Crop Name',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    _buildTextFieldForName(_cropNameController, hint: 'Enter crop name'),
                    const SizedBox(height: 20),

                    // CITY
                    const Text('City',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    _buildTextFieldForName(_cityController, hint: 'Enter city name'),
                    const SizedBox(height: 20),

                    // QUANTITY
                    const Text('Quantity',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_quantityController)),
                        const SizedBox(width: 12),
                        _buildUnitDropdown(),
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
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField(_amountController, hint: "Per 1$_selectedUnit")),
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
          child: Text(
            // Capitalize first letter for display
            item.toString()[0].toUpperCase() + item.toString().substring(1)
          ),
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

  Widget _buildTextFieldForName(TextEditingController controller, {String? hint}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
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

  Widget _buildUnitDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: DropdownButton<String>(
        value: _selectedUnit,
        underline: const SizedBox(),
        dropdownColor: Colors.white,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        items: _units.map((unit) {
          return DropdownMenuItem<String>(
            value: unit,
            child: Text(unit),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedUnit = value!;
          });
        },
      ),
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
    _cropNameController.dispose();
    _quantityController.dispose();
    _amountController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}

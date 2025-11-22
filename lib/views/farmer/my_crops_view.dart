import 'package:flutter/material.dart';
import '../../core/constants/app_themes.dart';
import 'update_crops_view.dart'; // Import the UpdateCropsView
import 'package:provider/provider.dart';
import '../../viewmodels/crop_viewmodel.dart';
import '../../models/crop_model.dart';

class MyCropsView extends StatefulWidget {
  const MyCropsView({Key? key}) : super(key: key);

  @override
  State<MyCropsView> createState() => _MyCropsViewState();
}

class _MyCropsViewState extends State<MyCropsView> {
  @override
  void initState() {
    super.initState();
    // TODO: Call your backend API here to fetch crops
    // _loadCropsFromBackend();
  }

  // TODO: Implement this method to fetch data from your backend
  Future<void> _loadCropsFromBackend() async {
    // placeholder: this view now uses a StreamBuilder to load crops
    // keep this method for compatibility with earlier plans
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          // Header section
          _buildHeader(),
          // Content
          Expanded(
            child: Builder(builder: (context) {
              final vm = Provider.of<CropViewModel>(context, listen: false);
              return StreamBuilder<List<CropModel>>(
                stream: vm.streamMyCrops(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading crops'));
                  }
                  final crops = snapshot.data ?? [];
                  if (crops.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _buildCropsGrid(crops);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.agriculture_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No crops added yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding your crops to see them here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
                  'My Crops',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balance the back button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCropsGrid(List<CropModel> crops) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: crops.length,
        itemBuilder: (context, index) {
          final crop = crops[index];
          return CropCard(
            cropName: crop.name,
            imageUrl: crop.imageUrl,
            onEdit: () => _handleEdit(crop),
            onDelete: () => _handleDelete(crop),
          );
        },
      ),
    );
  }

  void _handleEdit(CropModel crop) async {
    // Navigate to UpdateCropsView with the crop data
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateCropsView(cropData: {
          'id': crop.id,
          'ownerId': crop.ownerId,
          'name': crop.name,
          'imageUrl': crop.imageUrl,
          'category': crop.category,
          'quantity': crop.quantity,
          'amount': crop.amount,
          'city': crop.city,
        }),
      ),
    );

    // If the update was successful, show a success message
    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Crop updated successfully'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleDelete(CropModel crop) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Crop',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to delete ${crop.name}?',
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () async {
                final vm = Provider.of<CropViewModel>(context, listen: false);
                await vm.deleteCrop(crop.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${crop.name} deleted'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CropCard extends StatelessWidget {
  final String cropName;
  final String imageUrl;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CropCard({
    Key? key,
    required this.cropName,
    required this.imageUrl,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image section
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: imageUrl.isEmpty
                  ? Container(
                width: double.infinity,
                color: const Color(0xFFE8E8E8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 50,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              )
                  : Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: const Color(0xFFE8E8E8),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFE8E8E8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Green footer with name and icons
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    cropName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildIconButton(
                  icon: Icons.edit_outlined,
                  onTap: onEdit,
                ),
                const SizedBox(width: 8),
                _buildIconButton(
                  icon: Icons.delete_outline,
                  onTap: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
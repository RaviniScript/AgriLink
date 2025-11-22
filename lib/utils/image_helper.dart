import 'package:flutter/material.dart';

class ImageHelper {
  /// Returns a placeholder image path based on product category
  static String getPlaceholderImage(String category) {
    switch (category.toLowerCase()) {
      case 'fruits':
        return 'assets/images/fruits/placeholder.png';
      case 'vegetables':
        return 'assets/images/vegetables/placeholder.png';
      default:
        return 'assets/images/buyer/placeholder.png';
    }
  }

  /// Builds an image widget with proper loading and error handling
  static Widget buildProductImage({
    required String imageUrl,
    required String category,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
  }) {
    // If no image URL, show placeholder
    if (imageUrl.isEmpty) {
      return _buildPlaceholder(category, width, height);
    }

    // Try to load network image
    return Image.network(
      imageUrl,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // If network image fails, show placeholder
        return _buildPlaceholder(category, width, height);
      },
    );
  }

  static Widget _buildPlaceholder(String category, double? width, double? height) {
    IconData icon;
    Color color;
    
    switch (category.toLowerCase()) {
      case 'fruits':
        icon = Icons.apple;
        color = Colors.red[300]!;
        break;
      case 'vegetables':
        icon = Icons.eco;
        color = Colors.green[300]!;
        break;
      default:
        icon = Icons.shopping_basket;
        color = Colors.orange[300]!;
    }

    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          icon,
          size: 48,
          color: color,
        ),
      ),
    );
  }

  /// Builds a farmer profile image with fallback
  static Widget buildFarmerImage({
    required String imageUrl,
    double radius = 40,
  }) {
    if (imageUrl.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[300],
        child: Icon(
          Icons.person,
          size: radius,
          color: Colors.grey[600],
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (error, stackTrace) {
        print('Error loading farmer image: $error');
      },
      child: Container(), // Placeholder while loading
    );
  }
}

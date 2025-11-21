import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/models/review_model.dart';
import 'package:agri_link/services/review_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddReviewDialog extends StatefulWidget {
  final String orderId;
  final String productId;
  final String buyerId;
  final String buyerName;
  final String productName;

  const AddReviewDialog({
    Key? key,
    required this.orderId,
    required this.productId,
    required this.buyerId,
    required this.buyerName,
    required this.productName,
  }) : super(key: key);

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  final ReviewService _reviewService = ReviewService();
  final TextEditingController _reviewController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  double _rating = 5.0;
  List<File> _images = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty && images.length <= 5) {
        setState(() {
          _images = images.map((xFile) => File(xFile.path)).toList();
        });
      } else if (images.length > 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum 5 images allowed')),
        );
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _submitReview() async {
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a review')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO: Upload images to Firebase Storage and get URLs
      List<String> imageUrls = [];
      // For now, we'll leave imageUrls empty
      // In production, upload _images to Firebase Storage here

      final review = ReviewModel(
        id: '', // Will be set by Firestore
        orderId: widget.orderId,
        productId: widget.productId,
        buyerId: widget.buyerId,
        buyerName: widget.buyerName,
        rating: _rating,
        reviewText: _reviewController.text.trim(),
        imageUrls: imageUrls,
        createdAt: DateTime.now(),
      );

      await _reviewService.addReview(review);

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review submitted successfully!'),
            backgroundColor: AppThemes.primaryGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting review: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Rate & Review',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.productName,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),

            // Star Rating
            Text(
              'Your Rating',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = (index + 1).toDouble();
                    });
                  },
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: const Color(0xFFFFB800),
                    size: 36,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Review Text
            Text(
              'Your Review',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _reviewController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Share your experience with this product...',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppThemes.primaryGreen,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    const SizedBox(height: 16),

                    // Add Photos Button
                    OutlinedButton.icon(
                      onPressed: _images.length < 5 ? _pickImages : null,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: Text(
                        'Add Photos (${_images.length}/5)',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppThemes.primaryGreen,
                        side: const BorderSide(color: AppThemes.primaryGreen),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    // Image Preview
                    if (_images.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(_images[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 12,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(index),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
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
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemes.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Submit Review',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

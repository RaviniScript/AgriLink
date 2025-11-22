import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for uploading images to imgBB
/// Using your personal API key - 5000 uploads/month free
class ImageUploadService {
  // Your imgBB API key
  static const String _apiKey = 'ca861eb3d56476e424df0c847662f8d2';
  static const String _uploadUrl = 'https://api.imgbb.com/1/upload';
  
  /// Upload an image file to imgBB
  /// Returns the image URL if successful, null if failed
  static Future<String?> uploadImage(File imageFile) async {
    try {
      print('📤 Starting image upload to imgBB...');
      
      // Read image file as bytes
      List<int> imageBytes = await imageFile.readAsBytes();
      
      // Convert to base64
      String base64Image = base64Encode(imageBytes);

      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
      
      // Add API key
      request.fields['key'] = _apiKey;
      
      // Add image data
      request.fields['image'] = base64Image;

      print('📤 Sending request to imgBB...');
      
      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        
        if (jsonResponse['success'] == true) {
          String imageUrl = jsonResponse['data']['url'];
          print('✅ Upload successful! URL: $imageUrl');
          return imageUrl;
        } else {
          print('❌ Upload failed: ${jsonResponse['error']['message']}');
          return null;
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Exception during image upload: $e');
      return null;
    }
  }
}

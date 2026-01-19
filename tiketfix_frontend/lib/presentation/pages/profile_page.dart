import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../core/constants/api_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authDataSource = AuthRemoteDataSource();
  final ImagePicker _picker = ImagePicker();
  
  String? _username;
  String? _profilePicUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      if (username != null) {
        setState(() => _username = username);
        final result = await _authDataSource.getUserProfile(username);
        if (result['success'] == true) {
          setState(() {
            _profilePicUrl = result['data']['profile_picture'];
          });
        }
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null && _username != null) {
        setState(() => _isLoading = true);
        final result = await _authDataSource.uploadProfilePicture(_username!, image.path);
        
        if (!mounted) return;

        if (result['success'] == true) {
           await _loadProfile();
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile picture updated!", style: TextStyle(color: Colors.white)), backgroundColor: AppColors.success));
        } else {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? "Upload failed", style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.error));
        }
      }
    } catch (e) {
       if (!mounted) return;
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to pick image: $e", style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.error));
    } finally {
       if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library, color: AppColors.textPrimary),
                  title: const Text('Photo Library', style: AppTextStyles.body),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: AppColors.textPrimary),
                title: const Text('Camera', style: AppTextStyles.body),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String? fullImageUrl;
    if (_profilePicUrl != null && _profilePicUrl!.isNotEmpty) {
      fullImageUrl = "${ApiConstants.baseUrl}/$_profilePicUrl";
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: _isLoading 
        ? const CircularProgressIndicator(color: AppColors.primary)
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _showPickerOptions,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ]
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: AppColors.surface,
                    backgroundImage: fullImageUrl != null 
                      ? NetworkImage(fullImageUrl) 
                      : null,
                    child: fullImageUrl == null 
                      ? const Icon(Icons.person, size: 70, color: Colors.grey)
                      : null,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _username ?? "Guest",
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: 8),
              Text(
                "Movie Enthusiast",
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: CustomButton(
                  text: "Change Profile Picture",
                  onPressed: _showPickerOptions,
                  isOutlined: true,
                ),
              ),
            ],
          ),
      ),
    );
  }
}

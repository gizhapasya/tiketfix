import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../core/constants/api_constants.dart';

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
      // Handle error gently
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024, // Resize to avoid huge uploads
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null && _username != null) {
        setState(() => _isLoading = true);
        final result = await _authDataSource.uploadProfilePicture(_username!, image.path);
        
        if (!mounted) return;

        if (result['success'] == true) {
           await _loadProfile(); // Await ensures state update before snackbar
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile picture updated!")));
        } else {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? "Upload failed")));
        }
      }
    } catch (e) {
       if (!mounted) return;
       // Often generic error implies permission or path issue
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to pick image: $e")));
    } finally {
       if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
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
      // If it's a relative path, prepend base url (remove 'ticketfix_api' part if needed, depends on how upload stores it)
      // Upload stored: "uploads/profiles/..."
      // BaseUrl: "http://10.10.10.211/ticketfix_api"
      // Result: "http://10.10.10.211/ticketfix_api/uploads/profiles/..."
      fullImageUrl = "${ApiConstants.baseUrl}/$_profilePicUrl";
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: _isLoading 
        ? const CircularProgressIndicator()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _showPickerOptions,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: fullImageUrl != null 
                    ? NetworkImage(fullImageUrl) 
                    : null,
                  child: fullImageUrl == null 
                    ? const Icon(Icons.person, size: 60, color: Colors.grey)
                    : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _username ?? "Guest",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _showPickerOptions,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Change Profile Picture"),
              ),
            ],
          ),
      ),
    );
  }
}

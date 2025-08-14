import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      _nameController.text = authProvider.user!.name;
      _emailController.text = authProvider.user!.email;
      _phoneController.text = authProvider.user!.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) {
                  _loadUserData(); // Reset data if canceling edit
                }
              });
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.user == null) {
            return Center(
              child: Text('No user data found'),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFF2E7D32),
                    child: authProvider.user!.profileImage != null
                        ? ClipOval(
                            child: Image.network(
                              authProvider.user!.profileImage!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                  ),
                  if (_isEditing) ...[
                    SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Implement image picker
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Image picker coming soon')),
                        );
                      },
                      icon: Icon(Icons.camera_alt),
                      label: Text('Change Photo'),
                    ),
                  ],
                  SizedBox(height: 32),

                  // Profile Form
                  _buildProfileField(
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.person,
                    enabled: _isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  
                  _buildProfileField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                    enabled: _isEditing,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  
                  _buildProfileField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone,
                    enabled: _isEditing,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32),

                  if (_isEditing) ...[
                    // Save Button
                    ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: authProvider.isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Save Changes',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                    SizedBox(height: 16),
                  ],

                  // Settings Section
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.notifications),
                          title: Text('Notifications'),
                          subtitle: Text('Manage notification preferences'),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Navigate to notification settings
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Notification settings coming soon')),
                            );
                          },
                        ),
                        Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.help),
                          title: Text('Help & Support'),
                          subtitle: Text('Get help or contact support'),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Navigate to help
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Help section coming soon')),
                            );
                          },
                        ),
                        Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.privacy_tip),
                          title: Text('Privacy Policy'),
                          subtitle: Text('Read our privacy policy'),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Navigate to privacy policy
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Privacy policy coming soon')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Logout Button
                  OutlinedButton(
                    onPressed: _logout,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: !enabled,
        fillColor: !enabled ? Colors.grey[100] : null,
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final updatedUser = authProvider.user!;
    // In a real app, you would create a new User object with updated data
    
    // Mock update
    await Future.delayed(Duration(seconds: 1));
    
    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

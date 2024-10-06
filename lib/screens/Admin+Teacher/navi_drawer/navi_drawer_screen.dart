import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NaviDrawer extends StatefulWidget {
  const NaviDrawer({super.key});

  @override
  _NaviDrawerState createState() => _NaviDrawerState();
}

class _NaviDrawerState extends State<NaviDrawer> {
  File? _profileImage;
  String userRole = ''; 
  final FlutterSecureStorage storage = FlutterSecureStorage();

  final Map<String, List<Map<String, dynamic>>> roleBasedItems = {
    'admin': [
      {'icon': Icons.home, 'title': 'Home', 'route': '/home'},
      {'icon': Icons.class_, 'title': 'Join Class', 'route': '/joinClass'},
      {'icon': Icons.group_remove, 'title': 'Leave Request', 'route': '/joinClass'},
      {'icon': Icons.settings, 'title': 'Settings', 'route': '/settings'},
      {'icon': Icons.info, 'title': 'Info', 'route': '/info'},
    ],
    'teacher': [
      {'icon': Icons.home, 'title': 'Home', 'route': '/home'},
      {'icon': Icons.class_, 'title': 'Class', 'route': '/classlist'},
      {'icon': Icons.settings, 'title': 'Settings', 'route': '/settings'},
      {'icon': Icons.info, 'title': 'Info', 'route': '/info'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadUserRole(); 
  }

  Future<void> _loadUserRole() async {
    String? storedRole = await storage.read(key: 'userRole');

    setState(() {
      userRole = storedRole ?? ''; 
      print('Loaded user role: $userRole');
    });
  }

  // Future<void> _pickImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     setState(() {
  //       _profileImage = File(image.path);
  //     });
  //   }
  // }

  void _signOut() async {
    await storage.delete(key: 'userToken');
    await storage.delete(key: 'userRole');
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(),
          ..._buildListTilesForRole(userRole),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: _signOut,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(color: Colors.grey),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            // onTap: _pickImage,
            child: CircleAvatar(
              radius: 40,
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : const AssetImage('assets/default_profile.png') as ImageProvider,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Profile',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildListTilesForRole(String role) {
    return roleBasedItems[role]?.map((item) {
      return ListTile(
        leading: Icon(item['icon']),
        title: Text(item['title']),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, item['route']);
        },
      );
    }).toList() ?? [];
  }
}

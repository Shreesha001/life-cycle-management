import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merge_app/features/password_manager/core/constants/app_constants.dart';
import 'package:merge_app/features/password_manager/core/theme/theme.dart';
import 'package:merge_app/features/password_manager/screens/add_new_password_screen.dart';
import 'package:share_plus/share_plus.dart';

class PasswordDetailsScreen extends StatefulWidget {
  const PasswordDetailsScreen({super.key});

  @override
  State<PasswordDetailsScreen> createState() => _PasswordDetailsScreenState();
}

class _PasswordDetailsScreenState extends State<PasswordDetailsScreen> {
  final ValueNotifier<String> _searchQuery = ValueNotifier<String>("");
  final ValueNotifier<String> _selectedCategory = ValueNotifier<String>(
    "Socials",
  );

  final List<String> tabs = ["Socials", "Media", "Design", "Games"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNewPasswordScreen()),
          );
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 8,
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: SearchBar(searchQueryNotifier: _searchQuery)),
                  const SizedBox(width: AppConstants.spacing4),
                  const Icon(Icons.settings, color: AppColors.secondaryColor),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: const [
                  Text(
                    "Passwords",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<String>(
                valueListenable: _selectedCategory,
                builder: (_, selected, __) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(tabs.length, (index) {
                        final isSelected = tabs[index] == selected;
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: GestureDetector(
                            onTap: () => _selectedCategory.value = tabs[index],
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                fontSize: 20,
                                color:
                                    isSelected
                                        ? AppColors.secondaryColor
                                        : AppColors.primaryColor,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                decoration:
                                    isSelected
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Expanded(
                child: PasswordList(
                  searchQueryNotifier: _searchQuery,
                  selectedCategoryNotifier: _selectedCategory,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Same SearchBar code
class SearchBar extends StatelessWidget {
  final ValueNotifier<String> searchQueryNotifier;

  const SearchBar({super.key, required this.searchQueryNotifier});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => searchQueryNotifier.value = value,
      style: const TextStyle(color: AppColors.primaryColor),
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: TextStyle(color: AppColors.primaryColor.withOpacity(0.5)),
        filled: true,
        fillColor: AppColors.backgroundColor,
        prefixIcon: const Icon(Icons.search, color: AppColors.secondaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.secondaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.secondaryColor),
        ),
      ),
    );
  }
}

class PasswordList extends StatefulWidget {
  final ValueNotifier<String> searchQueryNotifier;
  final ValueNotifier<String> selectedCategoryNotifier;

  const PasswordList({
    super.key,
    required this.searchQueryNotifier,
    required this.selectedCategoryNotifier,
  });

  @override
  State<PasswordList> createState() => _PasswordListState();
}

class _PasswordListState extends State<PasswordList> {
  late List<Map<String, dynamic>> passwords;
  late List<bool> _isVisible;

  @override
  void initState() {
    super.initState();
    passwords = [
      {
        "title": "Badoo",
        "email": "kilmanuwa",
        "password": "badoo123",
        "icon": Icons.favorite,
        "category": "Socials",
      },
      {
        "title": "Facebook",
        "email": "kil@vision.com",
        "password": "fbPass456",
        "icon": Icons.facebook,
        "category": "Socials",
      },
      {
        "title": "Instagram",
        "email": "kil@vision.com",
        "password": "insta789",
        "icon": Icons.camera_alt,
        "category": "Media",
      },
      {
        "title": "Linkedin",
        "email": "kilinked@vision.com",
        "password": "linked321",
        "icon": Icons.business,
        "category": "Design",
      },
      {
        "title": "Tinder",
        "email": "kilmanuwa",
        "password": "tinder999",
        "icon": Icons.whatshot,
        "category": "Games",
      },
    ];
    _isVisible = List.generate(passwords.length, (_) => false);
  }

  void _toggleVisibility(int index) {
    setState(() {
      _isVisible[index] = !_isVisible[index];
    });
  }

  void _copyPassword(String password) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password copied to clipboard')),
    );
  }

  void _editPassword(int index) {
    final controller = TextEditingController(
      text: passwords[index]['password'],
    );
    bool isPasswordVisible = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setState) => AlertDialog(
                title: Text('Edit Password for ${passwords[index]['title']}'),
                content: TextField(
                  controller: controller,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        passwords[index]['password'] = controller.text;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password updated')),
                      );
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
        );
      },
    );
  }

  void _sharePassword(String title, String password) {
    final shareText = 'Password for $title: $password';
    Share.share(shareText);
  }

  void _deletePassword(int index) {
    setState(() {
      passwords.removeAt(index);
      _isVisible.removeAt(index);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Password deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: widget.selectedCategoryNotifier,
      builder: (_, selectedCategory, __) {
        return ValueListenableBuilder<String>(
          valueListenable: widget.searchQueryNotifier,
          builder: (context, query, _) {
            final filteredPasswords =
                passwords
                    .where(
                      (item) =>
                          item['category'] == selectedCategory &&
                          item['title'].toLowerCase().contains(
                            query.toLowerCase(),
                          ),
                    )
                    .toList();

            return ListView.separated(
              itemCount: filteredPasswords.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = filteredPasswords[index];
                final originalIndex = passwords.indexOf(item);
                final passwordVisible = _isVisible[originalIndex];

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(item['icon'], color: Colors.white),
                    ),
                    title: Text(
                      item['title'],
                      style: const TextStyle(color: AppColors.primaryColor),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['email'],
                          style: const TextStyle(color: AppColors.primaryColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          passwordVisible ? item['password'] : '●●●●●●●●',
                          style: const TextStyle(color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.secondaryColor,
                          ),
                          onPressed: () => _toggleVisibility(originalIndex),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.copy,
                            color: AppColors.secondaryColor,
                          ),
                          onPressed: () => _copyPassword(item['password']),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: AppColors.secondaryColor,
                          ),
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                _editPassword(originalIndex);
                                break;
                              case 'share':
                                _sharePassword(item['title'], item['password']);
                                break;
                              case 'delete':
                                _deletePassword(originalIndex);
                                break;
                            }
                          },
                          itemBuilder:
                              (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'share',
                                  child: Text('Share'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

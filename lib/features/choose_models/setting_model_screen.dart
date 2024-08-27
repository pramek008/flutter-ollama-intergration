import 'package:flutter/material.dart';
import 'package:flutter_ollama_integration/clients/locator_injector.dart';
import 'package:go_router/go_router.dart';

import '../../services/secure_storage.dart';

class SettingModelScreen extends StatefulWidget {
  const SettingModelScreen({super.key});

  @override
  State<SettingModelScreen> createState() => _SettingModelScreenState();
}

class _SettingModelScreenState extends State<SettingModelScreen> {
  late TextEditingController? _nameController;

  late TextEditingController? _apiBaseUrlController;

  late TextEditingController? _apiPathController;

  late TextEditingController? _modelNameController;

  final storage = locator<SecureStorageImpl>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _apiBaseUrlController = TextEditingController();
    _apiPathController = TextEditingController();
    _modelNameController = TextEditingController();

    super.initState();
    _loadSetting();
  }

  Future<void> _loadSetting() async {
    _nameController?.text = await storage.readUser() ?? 'User';
    _apiBaseUrlController?.text = await storage.readBaseUrl();
    _apiPathController?.text = await storage.readCustomPath();
    _modelNameController?.text = await storage.readCustomModel();
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _apiBaseUrlController?.dispose();
    _apiPathController?.dispose();
    _modelNameController?.dispose();

    super.dispose();
  }

  Widget _buildTextField(String labelText, TextEditingController? controller) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Model Screen'),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _loadSetting(),
          builder: (context, snapshot) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Setting Model Screen'),
                  _buildTextField('Name', _nameController),
                  _buildTextField('API Base URL', _apiBaseUrlController),
                  _buildTextField('API Path', _apiPathController),
                  _buildTextField('Model Name', _modelNameController),
                  ElevatedButton(
                    onPressed: () async {
                      await storage.writeUser(_nameController?.text ?? 'User');
                      await storage
                          .writeBaseUrl(_apiBaseUrlController?.text ?? '');
                      await storage
                          .writeCustomPath(_apiPathController?.text ?? '');
                      await storage
                          .writeCustomModel(_modelNameController?.text ?? '');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Setting saved'),
                        ),
                      );
                    },
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.pushNamed('chat-room');
                    },
                    child: const Text('Go to Chat Room'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

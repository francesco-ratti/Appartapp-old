import 'dart:io';

import 'package:appartapp/model/user_handler.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditPassword extends StatefulWidget {
  final Color bgColor = Colors.white;

  const EditPassword({Key? key}) : super(key: key);

  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  bool _isLoading = false;
  String? _creditInfo;

  @override
  void initState() {
    super.initState();
    _loadCreditInfo();
  }

  Future<void> _loadCreditInfo() async {
    setState(() {
      _isLoading = true;
    });

    // Assuming UserHandler.getCreditInfo() returns a Future<String?>
    _creditInfo = await UserHandler.getCreditInfo();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _handleFileUpload(File file) async {
    setState(() {
      _isLoading = true;
    });

    // Assuming UserHandler.addCreditInfo(file) returns a Future<void>
    await UserHandler.addCreditInfo(file);

    // Reload credit info after uploading the file
    await _loadCreditInfo();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestisci il tuo credit scoring'),
        backgroundColor: Colors.brown,
      ),
      backgroundColor: widget.bgColor,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Center(
          child: _creditInfo != null
              ? Text(_creditInfo!)
              : Text('No credit info added, please add them'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Assuming you have a method to handle file picking
          // This can be achieved using plugins like file_picker
          // Once the file is picked, call _handleFileUpload method
          // and pass the picked file to it.
          // Example:
          // _handleFileUpload(pickedFile);
        },
        child: Icon(Icons.file_upload),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:android_external_storage/android_external_storage.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class FormImageScreen extends StatefulWidget {
  static const routeName = '/form-img';

  const FormImageScreen({Key key}) : super(key: key);

  @override
  State<FormImageScreen> createState() => _FormImageScreenState();
}

class _FormImageScreenState extends State<FormImageScreen> {
  bool isLoading = false;

  Future<void> _handleSave(var data) async {
    setState(() {
      isLoading = true;
    });
    try {
      // var res = await Permission.manageExternalStorage.isGranted;
      var status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        final response = await http.get(Uri.parse(data['url']));
        final imageName = path.basename(data['url']);
        log(imageName);
        String localpath = await AndroidExternalStorage.getExternalStoragePublicDirectory(DirType.downloadDirectory);
        final file = await File(localpath+'/Donations/'+ data['fileName']+'.jpg').create(recursive: true);
        await file.writeAsBytes(response.bodyBytes);
        Fluttertoast.showToast(msg: "Image Saved Successfully");
        // log(localpath);
      } else {
        Fluttertoast.showToast(msg: "Storage Permission needed");
      }
    } catch (ex) {
      log(ex.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndTop,
            floatingActionButton: FloatingActionButton(
              onPressed: () async => _handleSave(data),
              child: Icon(Icons.save_rounded),
              backgroundColor: Colors.black45,
            ),
            body: PhotoView(
              heroAttributes: PhotoViewHeroAttributes(tag: "formImage"),
              imageProvider: NetworkImage(data['url']),
            ),
          );
  }
}

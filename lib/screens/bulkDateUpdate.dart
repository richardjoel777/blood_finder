import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nss_blood_finder/services/blood.dart';

class BulkDateUpdate extends StatefulWidget {
  static const routeName = '/bulk-edit';
  @override
  _BulkDateUpdateState createState() => _BulkDateUpdateState();
}

class _BulkDateUpdateState extends State<BulkDateUpdate> {
  DateTime _selectedDate;
  FilePickerResult _file;
  var _isLoading = false;

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1930),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        appBar: AppBar(
          title: Text("Bulk Update"),
        ),
        body: _isLoading
            ? Container(
                padding: EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Updation in progress, Please don't leave the app"),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      var file = await FilePicker.platform.pickFiles();
                      setState(() {
                        _file = file;
                      });
                    },
                    icon: Icon(Icons.upload_file),
                    iconSize: 36,
                  ),
                  _file == null
                      ? Text("Select CSV File")
                      : Text("File Selected"),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _selectedDate == null
                            ? "Donated Date : "
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        onPressed: _presentDatePicker,
                        child: Text(
                          "Choose Date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                    ),
                    child: Container(
                      height: 50.0,
                      width: 250,
                      child: Center(
                        child: Text(
                          "Update",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (_file != null && _selectedDate != null) {
                        setState(() {
                          _isLoading = true;
                        });
                        PlatformFile file = _file.files.first;

                        final input = new File(file.path).openRead();
                        List data = await input
                            .transform(utf8.decoder)
                            .transform(new CsvToListConverter())
                            .toList();
                        List<String> rollnos = data
                            .map((e) => (e[0] as String).toUpperCase())
                            .toList();
                        // print(rollnos.toString());
                        await BloodService.bulkUpdate(rollnos, _selectedDate);
                        setState(() {
                          _isLoading = false;
                        });
                        Fluttertoast.showToast(
                            msg: "Date Updated Successfully");
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);
                      } else {
                        if (_file == null) {
                          Fluttertoast.showToast(msg: "Please Pick a file");
                        }
                        if (_selectedDate == null) {
                          Fluttertoast.showToast(msg: "Please Pick a Date");
                        }
                      }
                    },
                  ),
                ],
              ));
  }
}

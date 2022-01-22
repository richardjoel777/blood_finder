import 'package:flutter/material.dart';

import 'package:nss_blood_finder/services/blood.dart';
import 'package:provider/provider.dart';

// import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  Map<String, Object> currentFilters = {};
  List departments = [];
  List districts = [];
  bool isInit = true;

  Widget _buildSwitchTile(
    String title,
    String description,
    bool currentValue,
    Function updateValue,
  ) {
    return SwitchListTile(
        title: Text(title,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontSize: 14, color: Colors.black)),
        subtitle: Text(description),
        value: currentValue,
        onChanged: updateValue);
  }

  Widget _buildSelectTile(
    String title,
    String currentValue,
    List values,
    Function updateValue,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontSize: 14, color: Colors.black),
          ),
          SizedBox(
            width: 10,
          ),
          DropdownButton<String>(
            value: currentValue == null ? null : currentValue,
            items: values.map((dynamic v) {
              return new DropdownMenuItem<String>(
                value: v,
                child: Text(v),
              );
            }).toList(),
            onChanged: updateValue,
          ),
        ],
      ),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    if (isInit) {
      final bloodservice = Provider.of<BloodService>(context);
      Map<String, Object> fil = bloodservice.filters;
      List depts = await bloodservice.getDepartments();
      List dists = await bloodservice.getDistricts();
      // print(departments);
      setState(() {
        currentFilters = fil;
        dists.sort((a, b) {
          return a.compareTo(b);
        });
        print(dists);
        // print(currentFilters);
        districts = dists;
        departments = depts;
        isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bloodservice = Provider.of<BloodService>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Filters"),
          actions: [
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () async {
                  bloodservice.changeFilter(currentFilters);
                  Navigator.of(context).pop();
                })
          ],
        ),
        // drawer: MainDrawer(),
        body: isInit
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Add Filters ",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.black),
                    ),
                  ),
                  Expanded(
                      child: ListView(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(16.0),
                      //   child: TextField(
                      //     decoration: InputDecoration(
                      //             labelText: "Area",
                      //             labelStyle: TextStyle(
                      //                 fontSize: 14.0, fontFamily: 'RobotoCondensed'),
                      //             hintStyle: TextStyle(
                      //                 color: Colors.grey,
                      //                 fontWeight: FontWeight.bold,
                      //                 fontSize: 10.0)),
                      //     style: TextStyle(fontSize: 14.0),
                      //     controller: area,
                      //     onChanged: (value) {
                      //       if (area.text == null) {
                      //         return;
                      //       } else {
                      //         setState(() {
                      //           currentFilters['area'] = area.text;
                      //         });
                      //       }
                      //     },
                      //   ),
                      // ),
                      _buildSelectTile("Filter by District",
                          currentFilters['area'], districts, (newValue) {
                        setState(() {
                          currentFilters['area'] = newValue;
                        });
                      }),
                      _buildSwitchTile(
                          'Filter by Willingness',
                          'Show only Willing Students',
                          currentFilters['willing'], (newvalue) {
                        setState(() {
                          currentFilters['willing'] = newvalue;
                        });
                      }),
                      _buildSelectTile("Filter by Department",
                          currentFilters['dept'], departments, (newValue) {
                        setState(() {
                          currentFilters['dept'] = newValue;
                        });
                      }),
                      _buildSelectTile("Filter by Year", currentFilters['year'],
                          ["All", "1", "2", "3", "4", "FACULTY", "PASSED OUT"],
                          (newValue) {
                        setState(() {
                          currentFilters['year'] = newValue;
                        });
                      }),
                      _buildSwitchTile(
                          'Filter by Passed Out',
                          'Include Passed Out Students',
                          currentFilters['passedout'], (newvalue) {
                        setState(() {
                          currentFilters['passedout'] = newvalue;
                        });
                      }),
                      _buildSwitchTile('Filter by Faculty', 'Include Faculty',
                          currentFilters['faculty'], (newvalue) {
                        setState(() {
                          currentFilters['faculty'] = newvalue;
                        });
                      }),
                      _buildSwitchTile(
                          'Filter by Hostellers',
                          'Show only Hostel Students',
                          currentFilters['hostel'], (value) {
                        setState(() {
                          currentFilters['hostel'] = value;
                        });
                      })
                    ],
                  ))
                ],
              ));
  }
}

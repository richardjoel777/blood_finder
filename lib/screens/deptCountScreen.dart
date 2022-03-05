import 'package:flutter/material.dart';
import 'package:nss_blood_finder/services/blood.dart';
import 'package:nss_blood_finder/widgets/dept_item.dart';
import 'package:provider/provider.dart';

class DeptCountScreen extends StatefulWidget {
  static const routeName = '/dept-donations';
  const DeptCountScreen({Key key}) : super(key: key);

  @override
  State<DeptCountScreen> createState() => _DeptCountScreenState();
}

class _DeptCountScreenState extends State<DeptCountScreen> {
  bool isInit = true;

  @override
  void didChangeDependencies() async {
    if (isInit) {
      await Provider.of<BloodService>(context, listen: false).setDeptCount();
      setState(() {
        isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bloodService = Provider.of<BloodService>(context);
    var deptCount = bloodService.deptCount.entries.toList();
    deptCount.sort((e1, e2) => -(e1.value as int).compareTo(e2.value as int));
    var year = DateTime.now().year;
    return isInit
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Dept-wise Donations - $year'),
              leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
                    bloodService.resetDeptCount();
                    Navigator.pop(context, true);
                  }),
            ),
            body: GridView(
              padding: const EdgeInsets.all(25),
              children: deptCount
                    .map((dept) => DeptItem(dept.key, dept.value))
                    .toList(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
            ),
          );
  }
}

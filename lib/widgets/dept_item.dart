import 'dart:math';

import 'package:flutter/material.dart';

class DeptItem extends StatelessWidget {
  final String dept;
  final count;
  DeptItem(this.dept, this.count);

  @override
  Widget build(BuildContext context) {
    Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    return InkWell(
      onTap: (){},
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          '$dept - $count',
          style: Theme.of(context).textTheme.headline6,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

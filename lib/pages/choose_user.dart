import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/widgets/my_paper.dart';
import 'package:flutter/material.dart';

class ChooseUser extends StatelessWidget {
  const ChooseUser({Key? key, required this.allUsers}) : super(key: key);

  final List<Map<String, dynamic>> allUsers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Choose user"),
        ),
        body: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(15),
            child: MyPaper(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width*1,
              child: DataTable(
                showCheckboxColumn: false,
                  columns: const [
                    DataColumn(
                        label: Expanded(
                      child: Text("Name"),
                    )),
                    DataColumn(
                        label: Expanded(
                      child: Text("Energy points"),
                    ))
                  ],
                  rows: allUsers
                      .map((e) => DataRow(
                              onSelectChanged: (_) {
                              },
                              cells: [
                                DataCell(Text(e["name"])),
                                DataCell(Text(e["ep"].toString()))
                              ]))
                      .toList()),
            )));
  }
}

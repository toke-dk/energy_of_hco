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
          title: const Text("Choose user"),
        ),
        body: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(15),
            child: MyPaper(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              width: MediaQuery.of(context).size.width * 1,
              child: DataTable(
                  showCheckboxColumn: false,
                  columns: [
                    DataColumn(
                        label: Expanded(
                      child: Text(
                        "Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getAppColorScheme(context).primary),
                      ),
                    )),
                    DataColumn(
                        label: Expanded(
                      child: Text(
                        "Energy points",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getAppColorScheme(context).primary),
                      ),
                    ))
                  ],
                  rows: allUsers
                      .map((e) => DataRow(onSelectChanged: (_) {}, cells: [
                            DataCell(Text(e["name"])),
                            DataCell(Text(e["ep"].toString()))
                          ]))
                      .toList()),
            )));
  }
}

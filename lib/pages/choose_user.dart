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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyPaper(
                  padding: const EdgeInsets.all(10),
                  borderRadius: 30,
                  hasShadow: true,
                  onTap: () => _becomeAMemberDialog(context),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.person_add_alt_1,
                        color: getAppColorScheme(context).primary,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Become a member !",
                        style: getAppTextTheme(context).bodyText1,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 18),
                    child: Text(
                      "Already a member?",
                      style: getAppTextTheme(context).subtitle1,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                MyPaper(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                ),
              ],
            )));
  }
}

Future _becomeAMemberDialog(context) {
  Widget _dialogActionText(onPressed, text) => TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getAppColorScheme(context).primary),
      ));

  String firstName = "";
  String lastName = "";

  final _formKey = GlobalKey<FormState>();

  final InputBorder borderDecoration =
      OutlineInputBorder(borderRadius: BorderRadius.circular(9));

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Become a member",
                          style: getAppTextTheme(context).headline5,
                        ),
                        const SizedBox(
                          height: 29,
                        ),
                        Column(
                          children: [
                            TextFormField(
                              autofocus: true,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) =>
                                  value!.isEmpty ? "Write last name" : null,
                              onChanged: (value) {
                                setState(() {
                                  firstName = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: "First name",
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                hintText: "John",
                                border: borderDecoration,
                              ),
                            ),
                            const SizedBox(
                              height: 9,
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              onChanged: (value) {
                                setState(() {
                                  lastName = value;
                                });
                              },
                              validator: (value) =>
                                  value!.isEmpty ? "Write last name" : null,
                              decoration: InputDecoration(
                                labelText: "Last name",
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                hintText: "Doe",
                                border: borderDecoration,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 29,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _dialogActionText(() {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context);
                              }
                            }, "Cancel"),
                            _dialogActionText(() {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context);
                              }
                            }, "Add !"),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      });
}

import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/models/cart.dart';
import 'package:energy_of_hco/models/product.dart';
import 'package:energy_of_hco/models/user.dart';
import 'package:energy_of_hco/pages/add_items.dart';
import 'package:energy_of_hco/widgets/my_paper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseUser extends StatefulWidget {
  const ChooseUser({Key? key}) : super(key: key);

  @override
  State<ChooseUser> createState() => _ChooseUserState();
}

class _ChooseUserState extends State<ChooseUser> {

  void testUserInitializer(context){
    final User testUser = User(
        firstName: "Tester",
        lastName: "User",
        energyPoints: 100,
        favouriteProducts: []);
    if (!getAllUsers(context, listen: false).map((e) => e.firstName).contains("Tester")) {
      Provider.of<UsersProvider>(context, listen: false).addUser(testUser);
    }
  }

  List<User> getAllUsers(context, {bool? listen}) =>
      Provider.of<UsersProvider>(context, listen: listen ?? true).getUsers;

  @override
  void initState() {
    testUserInitializer(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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

                  ///Todo do something with this value
                  onTap: () => _becomeAMemberDialog(context).then((value) {
                    setState(() {
                      Provider.of<UsersProvider>(context, listen: false)
                          .addUser(User(
                              firstName: value[0],
                              lastName: value[1],
                              energyPoints: 0,
                              favouriteProducts: []));
                    });
                  }),
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
                      rows: getAllUsers(context).map((user) {
                        return DataRow(
                            onSelectChanged: (_) {
                              Provider.of<UserProvider>(context, listen: false)
                                  .setCurrentUser(user);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AddItems(),
                              ));
                            },
                            cells: [
                              DataCell(Text(user.generateFullName)),
                              DataCell(Text(user.energyPointsAsString))
                            ]);
                      }).toList()),
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
                              Navigator.pop(context);
                            }, "Cancel"),
                            _dialogActionText(() {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context, [firstName, lastName]);
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

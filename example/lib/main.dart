import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Filter list example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User>? selectedUserList = [];

  void openFilterDelegate() async {
    await FilterListDelegate.show<User>(
      context: context,
      list: userList,
      theme: FilterListDelegateThemeData(
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tileColor: Colors.white,
          selectedColor: Colors.red,
          selectedTileColor: Color(0xFF649BEC).withOpacity(.5),
          textColor: Colors.blue,
        ),
      ),
      // enableOnlySingleSelection: true,
      onItemSearch: (user, query) {
        return user.name!.toLowerCase().contains(query.toLowerCase());
      },
      tileLabel: (user) => user!.name,
      emptySearchChild: Center(child: Text('No user found')),
      // enableOnlySingleSelection: true,
      searchFieldHint: 'Search Here..',
      // suggestionBuilder: (context, user, isSelected) {
      //   return ListTile(
      //     title: Text(user.name!),
      //     leading: CircleAvatar(
      //       backgroundColor: Colors.blue,
      //     ),
      //     selected: isSelected,
      //   );
      // },
      onApplyButtonClick: (list) {
        setState(() {
          selectedUserList = list;
        });
      },
    );
  }

  void _openFilterDialog() async {
    await FilterListDialog.display<User>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData.light(context),
      headlineText: 'Select Users',
      height: 500,
      listData: userList,
      selectedListData: selectedUserList,
      choiceChipLabel: (item) => item!.name,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ContolButtonType.All, ContolButtonType.Reset],
      onItemSearch: (user, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return user.name!.toLowerCase().contains(query.toLowerCase());
      },

      onApplyButtonClick: (list) {
        setState(() {
          selectedUserList = List.from(list!);
        });
        Navigator.pop(context);
      },

      /// uncomment below code to create custom choice chip
      /*choiceChipBuilder: (context, item, isSelected) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(
            color: isSelected! ? Colors.blue[300]! : Colors.grey[300]!,
          )),
          child: Text(
            item.name,
            style: TextStyle(
                color: isSelected ? Colors.blue[300] : Colors.grey[300]),
          ),
        );
      },*/
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                var list = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilterPage(
                      allTextList: userList,
                      selectedUserList: selectedUserList,
                    ),
                  ),
                );
                if (list != null) {
                  setState(() {
                    selectedUserList = List.from(list);
                  });
                }
              },
              child: Text(
                "Filter Page",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
            ),
            TextButton(
              onPressed: _openFilterDialog,
              child: Text(
                "Filter Dialog",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              // color: Colors.blue,
            ),
            TextButton(
              onPressed: openFilterDelegate,
              child: Text(
                "Filter Delegate",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              // color: Colors.blue,
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          selectedUserList == null || selectedUserList!.length == 0
              ? Expanded(
                  child: Center(
                    child: Text('No text selected'),
                  ),
                )
              : Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(selectedUserList![index].name!),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: selectedUserList!.length),
                ),
        ],
      ),
    );
  }
}

class FilterPage extends StatelessWidget {
  const FilterPage({Key? key, this.allTextList, this.selectedUserList})
      : super(key: key);
  final List<User>? allTextList;
  final List<User>? selectedUserList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter list Page"),
      ),
      body: SafeArea(
        child: FilterListWidget<User>(
          themeData: FilterListThemeData.light(context),
          hideSelectedTextCount: true,
          listData: userList,
          controlButtons: [ContolButtonType.All, ContolButtonType.Reset],
          selectedListData: selectedUserList,
          onApplyButtonClick: (list) {
            Navigator.pop(context, list);
          },
          choiceChipLabel: (item) {
            /// Used to print text on chip
            return item!.name;
          },
          // choiceChipBuilder: (context, item, isSelected) {
          //   return Container(
          //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //     decoration: BoxDecoration(
          //         border: Border.all(
          //       color: isSelected! ? Colors.blue[300]! : Colors.grey[300]!,
          //     )),
          //     child: Text(item.name),
          //   );
          // },
          validateSelectedItem: (list, val) {
            ///  identify if item is selected or not
            return list!.contains(val);
          },
          onItemSearch: (user, query) {
            /// When search query change in search bar then this method will be called
            ///
            /// Check if items contains query
            return user.name!.toLowerCase().contains(query.toLowerCase());
          },
        ),
      ),
    );
  }
}

class User {
  final String? name;
  final String? avatar;
  User({this.name, this.avatar});
}

/// Creating a global list for example purpose.
/// Generally it should be within data class or where ever you want
List<User> userList = [
  User(name: "Abigail", avatar: "user.png"),
  User(name: "Audrey", avatar: "user.png"),
  User(name: "Ava", avatar: "user.png"),
  User(name: "Bella", avatar: "user.png"),
  User(name: "Bernadette", avatar: "user.png"),
  User(name: "Carol", avatar: "user.png"),
  User(name: "Claire", avatar: "user.png"),
  User(name: "Deirdre", avatar: "user.png"),
  User(name: "Donna", avatar: "user.png"),
  User(name: "Dorothy", avatar: "user.png"),
  User(name: "Faith", avatar: "user.png"),
  User(name: "Gabrielle", avatar: "user.png"),
  User(name: "Grace", avatar: "user.png"),
  User(name: "Hannah", avatar: "user.png"),
  User(name: "Heather", avatar: "user.png"),
  User(name: "Irene", avatar: "user.png"),
  User(name: "Jan", avatar: "user.png"),
  User(name: "Jane", avatar: "user.png"),
  User(name: "Julia", avatar: "user.png"),
  User(name: "Kylie", avatar: "user.png"),
  User(name: "Lauren", avatar: "user.png"),
  User(name: "Leah", avatar: "user.png"),
  User(name: "Lisa", avatar: "user.png"),
  User(name: "Melanie", avatar: "user.png"),
  User(name: "Natalie", avatar: "user.png"),
  User(name: "Olivia", avatar: "user.png"),
  User(name: "Penelope", avatar: "user.png"),
  User(name: "Rachel", avatar: "user.png"),
  User(name: "Ruth", avatar: "user.png"),
  User(name: "Sally", avatar: "user.png"),
  User(name: "Samantha", avatar: "user.png"),
  User(name: "Sarah", avatar: "user.png"),
  User(name: "Theresa", avatar: "user.png"),
  User(name: "Una", avatar: "user.png"),
  User(name: "Vanessa", avatar: "user.png"),
  User(name: "Victoria", avatar: "user.png"),
  User(name: "Wanda", avatar: "user.png"),
  User(name: "Wendy", avatar: "user.png"),
  User(name: "Yvonne", avatar: "user.png"),
  User(name: "Zoe", avatar: "user.png"),
];
/// Another exmaple of [FilterListWidget] to filter list of strings
///
/// FilterListWidget<String>(
///   listData: ["One", "Two", "Three", "Four","five","Six","Seven","Eight","Nine","Ten"],
///   selectedListData: ["One", "Three", "Four","Eight","Nine"],
///   hideHeaderText: true,
///   height: MediaQuery.of(context).size.height,
///   // hideHeaderText: true,
///   onApplyButtonClick: (list) {
///     Navigator.pop(context, list);
///   },
///   choiceChipLabel: (item) {
///     /// Used to print text on chip
///     return item;
///   },
///   validateSelectedItem: (list, val) {
///     ///  identify if item is selected or not
///     return list!.contains(val);
///   },
///   onItemSearch: (list, text) {
///     /// When text change in search text field then return list containing that text value
///     ///
///     ///Check if list has value which matchs to text
///     if (list!.any((element) =>
///         element.toLowerCase().contains(text.toLowerCase()))) {
///       /// return list which contains matches
///       return list
///           .where((element) =>
///               element.toLowerCase().contains(text.toLowerCase()))
///           .toList();
///     }
///     return [];
///   },
/// )

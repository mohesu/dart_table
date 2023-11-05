import 'package:dart_table/dart_table.dart';
import 'package:flutter/material.dart';

/// This is an example of how to use the package
void main() {
  /// run app with MyApp
  runApp(const MyApp());
}

/// MyApp is a root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Dart Table Demo'),
    );
  }
}

/// MyHomePage is a home widget of the app which contains [DartTable] widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool splitView = false;
  @override
  Widget build(BuildContext context) {
    /// Current Theme
    ///
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => setState(() {
              splitView = !splitView;
            }),
            color: splitView ? theme.primaryColor : null,
            icon: const Icon(Icons.vertical_split_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),

        /// DartTable is a widget that contains [SfDataGrid] and [SplitView]
        child: DartTable(
          columns: UserModel.columns,
          source: UserModelSource(users: UserModel.dummyData),
          columnWidthMode: ColumnWidthMode.fill,
          gridLinesVisibility: GridLinesVisibility.horizontal,
          headerGridLinesVisibility: GridLinesVisibility.none,
          allowFiltering: false,
          allowSorting: false,
          selectionMode: SelectionMode.single,
          showCheckboxColumn: false,

          /// Right side widget of [SplitView]
          child: splitView
              ? (split, controller) {
                  return UserView(
                    controller: controller,
                  );
                }
              : null,
        ),
      ),
    );
  }
}

/// User Model for example
///
/// This is not required for the package
///
///
class UserModel {
  UserModel({
    this.id,
    this.name,
    this.email,
    this.image,
    this.address,
    this.role,
    this.status,
    this.createdAt,
  });
  final int? id;
  final String? name;
  final String? email;
  final String? image;
  final String? address;
  final String? role;
  final String? status;
  final DateTime? createdAt;

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? image,
    String? address,
    String? role,
    String? status,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      image: image ?? this.image,
      address: address ?? this.address,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Dummy data for example
  static List<UserModel> get dummyData => List.generate(
        120,
        (index) => UserModel(
          id: index + 1,
          name: 'User ${index + 1}',
          image: "https://picsum.photos/200/300?random=$index",
          email: "example$index@gmail.com",
          address: "Seoul",
          role: index % 2 == 0 ? "Admin" : "User",
          status: index != 2 ? "Active" : "Inactive",
          createdAt: DateTime(2021, 1, 1).add(Duration(days: index)),
        ),
      ).toList();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return UserModel();
    return UserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      image: json["image"],
      address: json["address"],
      role: json["role"],
      status: json["status"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "image": image,
        "role": role,
        "status": status,
        "address": address,
        "createdAt": createdAt?.toIso8601String(),
      };

  static List<String> get attributes => [
        "name",
        "email",
        "role",
        "address",
        "status",
        "action",
      ];

  static List<GridColumn> get columns => attributes.map<GridColumn>(
        (attribute) {
          final index = attributes.indexOf(attribute);
          return GridColumn(
            columnName: attribute,
            autoFitPadding: EdgeInsets.zero,
            maximumWidth: attribute == "action" ? 150.0 : double.nan,
            label: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: index == 0
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        bottomLeft: Radius.circular(12.0),
                      )
                    : attributes.indexOf(attribute) == attributes.length - 1
                        ? const BorderRadius.only(
                            topRight: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                          )
                        : null,
              ),
              margin: index == 0
                  ? const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0)
                  : attributes.indexOf(attribute) == attributes.length - 1
                      ? const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0)
                      : const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                attribute.substring(0, 1).toUpperCase() +
                    attribute.substring(1),
              ),
            ),
          );
        },
      ).toList();
}

class UserModelSource extends DataGridSource {
  final List<UserModel> users;

  List<DataGridRow> dataGridRows = [];

  List<GridColumn> columns = [];
  UserModelSource({required this.users}) {
    dataGridRows = users
        .map<DataGridRow>(
          (user) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'name',
                value: user.name,
              ),
              DataGridCell<String>(
                columnName: 'email',
                value: user.email,
              ),
              DataGridCell<String>(
                columnName: 'role',
                value: user.role,
              ),
              DataGridCell<String>(
                columnName: 'address',
                value: user.address,
              ),
              DataGridCell<String>(
                columnName: 'status',
                value: user.status,
              ),
              const DataGridCell<String>(
                columnName: 'action',
                value: 'action',
              ),
            ],
          ),
        )
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (dataGridCell) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: child(dataGridCell),
          );
        },
      ).toList(),
    );
  }

  Widget child(DataGridCell<dynamic> cell) {
    switch (cell.columnName) {
      case "name":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.black12,
              child: FlutterLogo(),
            ),
            const SizedBox(width: 10.0),
            Text(
              cell.value.toString(),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        );
      case "email":
        return Text(
          cell.value.toString(),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        );
      case "role":
        return Chip(
          label: Text(
            cell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
          side: const BorderSide(
            color: Colors.black12,
          ),
          shape: const StadiumBorder(),
        );
      case "status":
        return Switch.adaptive(
          value: cell.value.toString() == "Active",
          onChanged: (value) => print(value),
        );
      case "action":
        return PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          tooltip: "",
          onSelected: (value) {
            switch (value) {
              case "view":
                break;
              case "edit":
                break;
              case "delete":
                break;
              default:
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: "view",
                child: Text("View"),
              ),
              const PopupMenuItem(
                value: "edit",
                child: Text("Edit"),
              ),
              const PopupMenuItem(
                value: "delete",
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ];
          },
        );
      default:
        return Text(
          cell.value.toString(),
          overflow: TextOverflow.ellipsis,
        );
    }
  }

  refreshDataGrid() {
    notifyListeners();
  }
}

class UserView extends StatelessWidget {
  final DataGridController? controller;
  const UserView({
    super.key,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.black38,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          title: const Text("User"),
        ),
        body: ListView(
          children: const [],
        ),
      ),
    );
  }
}

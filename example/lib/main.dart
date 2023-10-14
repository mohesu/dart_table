import 'package:admin_table/admin_table.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Admin Table Demo'),
    );
  }
}

/// MyHomePage is a home widget of the app which contains [AdminTable] widget
class MyHomePage extends StatelessWidget {
  MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  late PlutoGridStateManager? stateManager;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),

        /// AdminTable is a widget that contains [PlutoGrid] and [SplitView]
        child: AdminTable(
          gridColumns: UserModel.gridColumns,
          gridRows: UserModel.gridRows,

          /// Right side widget of [SplitView]
          child: (state, controller, cell) {
            stateManager = state;
            return UserView(
              cell: cell,
              stateManager: stateManager,
              formKey: GlobalKey<FormState>(),
            );
          },
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
    this.name,
    this.age,
    this.height,
    this.weight,
    this.birthday,
    this.email,
    this.address,
    this.createdAt,
  });

  final String? name;
  final int? age;
  final double? height;
  final double? weight;
  final DateTime? birthday;
  final String? email;
  final String? address;
  final DateTime? createdAt;

  UserModel copyWith({
    String? name,
    int? age,
    double? height,
    double? weight,
    DateTime? birthday,
    String? email,
    String? address,
    DateTime? createdAt,
  }) {
    return UserModel(
      name: name ?? this.name,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      birthday: birthday ?? this.birthday,
      email: email ?? this.email,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Dummy data for example
  static List<UserModel> get dummyData => List.generate(
        120,
        (index) => UserModel(
          name: 'User ${index + 1}',
          age: 20 + index,
          height: 160.0 + index,
          weight: 60.0 + index,
          birthday: DateTime(2000, 1, 1).add(Duration(days: index)),
          email: "example$index@gmail.com",
          address: "Seoul",
          createdAt: DateTime(2021, 1, 1).add(Duration(days: index)),
        ),
      ).toList();

  /// Grid Columns for example
  static List<PlutoColumn> get gridColumns => [
        PlutoColumn(
          title: 'Serial Number',
          field: 'Sr. No.',
          type: PlutoColumnType.number(),
          enableEditingMode: false,
          enableColumnDrag: false,
          enableRowChecked: true,
        ),
        PlutoColumn(
          title: 'Name',
          field: 'name',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: 'Birthday',
          field: 'birthday',
          type: PlutoColumnType.date(),
        ),
        PlutoColumn(
          title: 'Email',
          field: 'email',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: 'Created At',
          field: 'createdAt',
          type: PlutoColumnType.date(),
        ),
        PlutoColumn(
          title: 'Age',
          field: 'age',
          type: PlutoColumnType.number(),
        ),
        PlutoColumn(
          title: 'Height',
          field: 'height',
          type: PlutoColumnType.number(),
        ),
        PlutoColumn(
          title: 'Weight',
          field: 'weight',
          type: PlutoColumnType.number(),
        ),
        PlutoColumn(
          title: 'Address',
          field: 'address',
          type: PlutoColumnType.text(),
        ),
      ];

  /// Grid Rows for example
  static List<PlutoRow> get gridRows => dummyData
      .map((model) => PlutoRow(
            cells: {
              'Sr. No.': PlutoCell(
                value: model.name?.split(' ')[1].toString(),
              ),
              'name': PlutoCell(value: model.name),
              'age': PlutoCell(value: model.age),
              'height': PlutoCell(value: model.height),
              'weight': PlutoCell(value: model.weight),
              'birthday': PlutoCell(value: model.birthday),
              'email': PlutoCell(value: model.email),
              'address': PlutoCell(value: model.address),
              'createdAt': PlutoCell(value: model.createdAt),
            },
          ))
      .toList();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return UserModel();
    return UserModel(
      name: json["name"],
      age: json["age"],
      height: json["height"],
      weight: json["weight"],
      birthday: DateTime.parse(json["birthday"]),
      email: json["email"],
      address: json["address"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "age": age,
        "height": height,
        "weight": weight,
        "birthday": birthday?.toIso8601String(),
        "email": email,
        "address": address,
        "createdAt": createdAt?.toIso8601String(),
      };
}

class UserView extends StatefulWidget {
  final PlutoCell? cell;
  final PlutoGridStateManager? stateManager;
  final GlobalKey<FormState> formKey;
  const UserView({
    super.key,
    required this.cell,
    required this.formKey,
    this.stateManager,
  });

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  String buttonText = "Edit";
  Icon buttonIcon = const Icon(Icons.edit_note);

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
          title: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: (value) => setState(() {
              buttonText = value == 0 ? "Edit" : "Save";
              buttonIcon = value == 0
                  ? const Icon(Icons.edit_note)
                  : const Icon(Icons.playlist_add);
            }),
            tabs: const [
              Tab(text: 'Edit'),
              Tab(text: 'Add'),
            ],
          ),
        ),
        body: Form(
          key: widget.formKey,
          child: TabBarView(
            controller: _tabController,
            children: [
              FormView(
                user: UserModel.fromJson(
                  widget.cell?.row.toJson() ?? {},
                ),
                formKey: widget.formKey,
              ),
              FormView(
                user: UserModel(),
                formKey: widget.formKey,
              ),
            ],
          ),
        ),
        bottomNavigationBar: ButtonBar(
          alignment: MainAxisAlignment.end,
          children: [
            FilledButton.icon(
              onPressed: () {
                try {
                  widget.formKey.currentState!.save();
                  switch (buttonText) {
                    case "Edit":
                      final cell = PlutoCell(
                        value: UserModel.fromJson(
                          widget.cell?.row.toJson() ?? {},
                        ),
                      );

                      widget.stateManager
                          ?.setCurrentCell(cell, widget.cell?.row.sortIdx ?? 0);
                      break;
                    case "Save":
                      final newRows = widget.stateManager?.getNewRows() ?? [];
                      for (var e in newRows) {
                        e.cells['name']!.value = 'created';
                      }
                      widget.stateManager?.appendRows(newRows);
                      widget.stateManager?.setCurrentCell(
                        newRows.first.cells.entries.first.value,
                        (widget.stateManager?.refRows.length ?? 1) - 1,
                      );
                      widget.stateManager?.moveScrollByRow(
                        PlutoMoveDirection.down,
                        (widget.stateManager?.refRows.length ?? 2) - 2,
                      );
                      widget.stateManager?.setKeepFocus(true);
                      break;
                    default:
                  }
                } catch (e) {
                  print(e);
                }
              },
              icon: buttonIcon,
              label: Text(buttonText),
            ),
            if (_tabController!.index == 0)
              FilledButton.icon(
                onPressed: () {
                  try {
                    widget.formKey.currentState!.save();
                    widget.stateManager!.removeCurrentRow();
                  } catch (e) {
                    print(e);
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.red.shade400),
                ),
                icon: const Icon(Icons.delete_forever),
                label: const Text("Delete"),
              ),
          ],
        ),
      ),
    );
  }
}

class FormView extends StatelessWidget {
  final UserModel user;
  final GlobalKey<FormState> formKey;
  const FormView({
    super.key,
    required this.user,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      children: [
        TextFormField(
          initialValue: user.name,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          initialValue: "${user.age ?? ""}",
          decoration: const InputDecoration(
            labelText: 'Age',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          initialValue: "${user.height ?? ""}",
          decoration: const InputDecoration(
            labelText: 'Height',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          initialValue: "${user.weight ?? ""}",
          decoration: const InputDecoration(
            labelText: 'Weight',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          initialValue: user.birthday?.toIso8601String(),
          decoration: const InputDecoration(
            labelText: 'Birthday',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          initialValue: user.email,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          initialValue: user.address,
          decoration: const InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          initialValue: user.createdAt?.toIso8601String(),
          decoration: const InputDecoration(
            labelText: 'Created At',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

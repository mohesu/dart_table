# dart_table

[![Pub Version](https://img.shields.io/pub/v/dart_table?color=blue&style=plastic)](https://pub.dev/packages/dart_table)
[![GitHub Repo stars](https://img.shields.io/github/stars/mohesu/dart_table?color=gold&style=plastic)](https://github.com/mohesu/dart_table/stargazers)
[![GitHub Repo forks](https://img.shields.io/github/forks/mohesu/dart_table?color=slateblue&style=plastic)](https://github.com/mohesu/dart_table/fork)
[![GitHub Repo issues](https://img.shields.io/github/issues/mohesu/dart_table?color=coral&style=plastic)](https://github.com/mohesu/dart_table/issues)
[![GitHub Repo contributors](https://img.shields.io/github/contributors/mohesu/dart_table?color=green&style=plastic)](https://github.com/mohesu/dart_table/graphs/contributors)

#### Flutter data table with selection, sorting, filtering, and pagination. Also supports split view.

## 📸 Screenshots

- Table

<img src="https://raw.githubusercontent.com/mohesu/dart_table/beta/assets/IMG_1.png" width=580 height=320 alt="">

<img src="https://raw.githubusercontent.com/mohesu/dart_table/beta/assets/IMG_2.png" width=580 height=320 alt="">

- Table with Split view

<img src="https://raw.githubusercontent.com/mohesu/dart_table/beta/assets/IMG_0.png" width=580 height=320 alt="">

## Setup

Pubspec changes:

```
      dependencies:
        dart_table: latest
```

## Getting Started

```dart
import 'package:dart_table/dart_table.dart';
```

## Set up your data model

```dart
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
}
```

## Set up your data source

```dart
class UserModelSource extends DataGridSource {

    /// Dummy data for example
  static List<UserModel> get dummyData => List.generate(
        120,
        (index) => UserModel(
          id: index + 1,
          name: 'User ${index + 1}',
          image: "https://mohesu.com/200/300?random=$index",
          email: "example$index@gmail.com",
          address: "Address $index",
          role: index % 2 == 0 ? "Admin" : "User",
          status: index != 2 ? "Active" : "Inactive",
          createdAt: DateTime(2021, 1, 1).add(Duration(days: index)),
        ),
      ).toList();


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
            columnName: attribute,double.nan,
            label:  Text(
                attribute.substring(0, 1).toUpperCase() +
                    attribute.substring(1),
              ),
          );
        },
      ).toList();

  List<DataGridRow> dataGridRows =  dummyData
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
            child: Text(
              dataGridCell.value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ).toList(),
    );
  }
}
```

## Usage of [DartTable]

```dart
DartTable(
  columns: UserModelSource.columns,
  source: UserModelSource.dummyData,

  /// Right side widget of [SplitView] (optional)
  child: Container(
    color: Colors.white,
    child: Center(
      child: Text('Right side'),
    ),
  ),
);
```

- For more details, please refer to the [example](https://github.com/mohesu/dart_table/beta/example) folder.

## 💰You can help me by Donating

[![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/rvndsngwn) [![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/rvndsngwn?country.x=IN&locale.x=en_GB) [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/rvndsngwn)

## 👨🏻‍💻Contribute to the project

All contributions are welcome.

[![GitHub](https://img.shields.io/badge/GitHub-0f0f0f?style=for-the-badge&logo=github&logoColor=white)](https://github.com/mohesu/dart_table)

## 👨🏻‍💻Contributors

<a href="https://github.com/mohesu/dart_table/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=mohesu/dart_table" />
</a>

Made with [contrib.rocks](https://contrib.rocks).

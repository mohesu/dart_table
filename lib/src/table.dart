import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:split_view/split_view.dart';

import 'copy_action.dart';

class AdminTable extends StatelessWidget {
  /// Controls the views being splitted.
  final SplitViewController? splitController;

  /// The [viewMode] specifies how to arrange views.
  final SplitViewMode viewMode;

  /// The grip size.
  final double gripSize;

  /// Grip color.
  final Color gripColor;

  /// Active grip color.
  final Color gripColorActive;

  /// Called when the user moves the grip.
  final ValueChanged<UnmodifiableListView<double?>>? onWeightChanged;

  /// Grip indicator.
  final Widget? indicator;

  /// Grip indicator for active state.
  final Widget? activeIndicator;

  /// {@template pluto_grid_property_columns}
  /// The [PlutoColumn] column is delivered as a list and can be added or deleted after grid creation.
  ///
  /// Columns can be added or deleted
  /// with [PlutoGridStateManager.insertColumns] and [PlutoGridStateManager.removeColumns].
  ///
  /// Each [PlutoColumn.field] value in [List] must be unique.
  /// [PlutoColumn.field] must be provided to match the map key in [PlutoRow.cells].
  /// should also be provided to match in [PlutoColumnGroup.fields] as well.
  /// {@endtemplate}
  final List<PlutoColumn> gridColumns;

  /// {@template pluto_grid_property_rows}
  /// [rows] contains a call to the [PlutoGridStateManager.initializeRows] method
  /// that handles necessary settings when creating a grid or when a new row is added.
  ///
  /// CPU operation is required as much as [rows.length] multiplied by the number of [PlutoRow.cells].
  /// No problem under normal circumstances, but if there are many rows and columns,
  /// the UI may freeze at the start of the grid.
  /// In this case, the grid is started by passing an empty list to rows
  /// and after the [PlutoGrid.onLoaded] callback is called
  /// Rows initialization can be done asynchronously with [PlutoGridStateManager.initializeRowsAsync] .
  ///
  /// ```dart
  /// stateManager.setShowLoading(true);
  ///
  /// PlutoGridStateManager.initializeRowsAsync(
  ///   columns,
  ///   fetchedRows,
  /// ).then((value) {
  ///   stateManager.refRows.addAll(value);
  ///
  ///   /// In this example,
  ///   /// the loading screen is activated in the onLoaded callback when the grid is created.
  ///   /// If the loading screen is not activated
  ///   /// You must update the grid state by calling the stateManager.notifyListeners() method.
  ///   /// Because calling setShowLoading updates the grid state
  ///   /// No need to call stateManager.notifyListeners.
  ///   stateManager.setShowLoading(false);
  /// });
  /// ```
  /// {@endtemplate}
  final List<PlutoRow> gridRows;

  /// {@template pluto_grid_property_columnGroups}
  /// [columnGroups] can be expressed in UI by grouping columns.
  /// {@endtemplate}
  final List<PlutoColumnGroup>? gridColumnGroups;

  /// {@template pluto_grid_property_onLoaded}
  /// [PlutoGrid] completes setting and passes [PlutoGridStateManager] to [event].
  ///
  /// When the [PlutoGrid] starts,
  /// the desired setting can be made through [PlutoGridStateManager].
  ///
  /// ex) Change the selection mode to cell selection.
  /// ```dart
  /// onLoaded: (PlutoGridOnLoadedEvent event) {
  ///   event.stateManager.setSelectingMode(PlutoGridSelectingMode.cell);
  /// },
  /// ```
  /// {@endtemplate}
  final PlutoOnLoadedEventCallback? onGridLoaded;

  /// {@template pluto_grid_property_onChanged}
  /// [onChanged] is called when the cell value changes.
  ///
  /// When changing the cell value directly programmatically
  /// with the [PlutoGridStateManager.changeCellValue] method
  /// When changing the value by calling [callOnChangedEvent]
  /// as false as the parameter of [PlutoGridStateManager.changeCellValue]
  /// The [onChanged] callback is not called.
  /// {@endtemplate}
  final PlutoOnChangedEventCallback? onGridChanged;

  /// {@template pluto_grid_property_onSelected}
  /// [onSelected] can receive a response only if [PlutoGrid.mode] is set to [PlutoGridMode.select] .
  ///
  /// When a row is tapped or the Enter key is pressed, the row information can be returned.
  /// When [PlutoGrid] is used for row selection, you can use [PlutoGridMode.select] .
  /// Basically, in [PlutoGridMode.select], the [onLoaded] callback works
  /// when the current selected row is tapped or the Enter key is pressed.
  /// This will require a double tap if no row is selected.
  /// In [PlutoGridMode.selectWithOneTap], the [onLoaded] callback works when the unselected row is tapped once.
  /// {@endtemplate}
  final PlutoOnSelectedEventCallback? onGridSelected;

  /// {@template pluto_grid_property_onSorted}
  /// [onSorted] is a callback that is called when column sorting is changed.
  /// {@endtemplate}
  final PlutoOnSortedEventCallback? onGridSorted;

  /// {@template pluto_grid_property_onRowChecked}
  /// [onRowChecked] can receive the check status change of the checkbox
  /// when [PlutoColumn.enableRowChecked] is enabled.
  /// {@endtemplate}
  final PlutoOnRowCheckedEventCallback? onGridRowChecked;

  /// {@template pluto_grid_property_onRowDoubleTap}
  /// [onRowDoubleTap] is called when a row is tapped twice in a row.
  /// {@endtemplate}
  final PlutoOnRowDoubleTapEventCallback? onGridRowDoubleTap;

  /// {@template pluto_grid_property_onRowSecondaryTap}
  /// [onRowSecondaryTap] is called when a mouse right-click event occurs.
  /// {@endtemplate}
  final PlutoOnRowSecondaryTapEventCallback? onGridRowSecondaryTap;

  /// {@template pluto_grid_property_onRowsMoved}
  /// [onRowsMoved] is called after the row is dragged and moved
  /// if [PlutoColumn.enableRowDrag] is enabled.
  /// {@endtemplate}
  final PlutoOnRowsMovedEventCallback? onGridRowsMoved;

  /// {@template pluto_grid_property_onColumnsMoved}
  /// Callback for receiving events
  /// when the column is moved by dragging the column
  /// or frozen it to the left or right.
  /// {@endtemplate}
  final PlutoOnColumnsMovedEventCallback? onGridColumnsMoved;

  /// {@template pluto_grid_property_createHeader}
  /// [createHeader] is a user-definable area located above the upper column area of [PlutoGrid].
  ///
  /// Just pass a callback that returns [Widget] .
  /// Assuming you created a widget called Header.
  /// ```dart
  /// createHeader: (stateManager) {
  ///   stateManager.headerHeight = 45;
  ///   return Header(
  ///     stateManager: stateManager,
  ///   );
  /// },
  /// ```
  ///
  /// If the widget returned to the callback detects the state and updates the UI,
  /// register the callback in [PlutoGridStateManager.addListener]
  /// and update the UI with [StatefulsetState], etc.
  /// The listener callback registered with [PlutoGridStateManager.addListener]
  /// must remove the listener callback with [PlutoGridStateManager.removeListener]
  /// when the widget returned by the callback is dispose.
  /// {@endtemplate}
  final CreateHeaderCallBack? gridCreateHeader;

  /// {@template pluto_grid_property_createFooter}
  /// [createFooter] is equivalent to [createHeader].
  /// However, it is located at the bottom of the grid.
  ///
  /// [CreateFooter] can also be passed an already provided widget for Pagination.
  /// Of course you can pass it to [createHeader] , but it's not a typical UI.
  /// ```dart
  /// createFooter: (stateManager) {
  ///   stateManager.setPageSize(100, notify: false); // default 40
  ///   return PlutoPagination(stateManager);
  /// },
  /// ```
  /// {@endtemplate}
  final CreateFooterCallBack? gridCreateFooter;

  /// {@template pluto_grid_property_noRowsWidget}
  /// Widget to be shown if there are no rows.
  ///
  /// Create a widget like the one below and pass it to [PlutoGrid.noRowsWidget].
  /// ```dart
  /// class _NoRows extends StatelessWidget {
  ///   const _NoRows({Key? key}) : super(key: key);
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return IgnorePointer(
  ///       child: Center(
  ///         child: DecoratedBox(
  ///           decoration: BoxDecoration(
  ///             color: Colors.white,
  ///             border: Border.all(),
  ///             borderRadius: const BorderRadius.all(Radius.circular(5)),
  ///           ),
  ///           child: Padding(
  ///             padding: const EdgeInsets.all(10),
  ///             child: Column(
  ///               mainAxisSize: MainAxisSize.min,
  ///               mainAxisAlignment: MainAxisAlignment.center,
  ///               children: const [
  ///                 Icon(Icons.info_outline),
  ///                 SizedBox(height: 5),
  ///                 Text('There are no records'),
  ///               ],
  ///             ),
  ///           ),
  ///         ),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  /// {@endtemplate}
  final Widget? gridNoRowsWidget;

  /// {@template pluto_grid_property_rowColorCallback}
  /// [rowColorCallback] can change the row background color dynamically according to the state.
  ///
  /// Implement a callback that returns a [Color] by referring to the value passed as a callback argument.
  /// An exception should be handled when a column is deleted.
  /// ```dart
  /// rowColorCallback = (PlutoRowColorContext rowColorContext) {
  ///   return rowColorContext.row.cells['column2']?.value == 'green'
  ///       ? const Color(0xFFE2F6DF)
  ///       : Colors.white;
  /// }
  /// ```
  /// {@endtemplate}
  final PlutoRowColorCallback? gridRowColorCallback;

  /// {@template pluto_grid_property_columnMenuDelegate}
  /// Column menu can be customized.
  ///
  /// See the demo example link below.
  /// https://github.com/bosskmk/pluto_grid/blob/master/demo/lib/screen/feature/column_menu_screen.dart
  /// {@endtemplate}
  final PlutoColumnMenuDelegate? gridColumnMenuDelegate;

  /// {@template pluto_grid_property_configuration}
  /// In [configuration], you can change the style and settings or text used in [PlutoGrid].
  /// {@endtemplate}
  final PlutoGridConfiguration? griConfiguration;

  final PlutoChangeNotifierFilterResolver? gridNotifierFilterResolver;

  /// Execution mode of [PlutoGrid].
  ///
  /// [PlutoGridMode.normal]
  /// {@macro pluto_grid_mode_normal}
  ///
  /// [PlutoGridMode.readOnly]
  /// {@macro pluto_grid_mode_readOnly}
  ///
  /// [PlutoGridMode.select], [PlutoGridMode.selectWithOneTap]
  /// {@macro pluto_grid_mode_select}
  ///
  /// [PlutoGridMode.multiSelect]
  /// {@macro pluto_grid_mode_multiSelect}
  ///
  /// [PlutoGridMode.popup]
  /// {@macro pluto_grid_mode_popup}
  final PlutoGridMode? gridMode;

  /// The right widget to be displayed in the split view.
  /// This widget is displayed on the right side of the split view.
  /// The left side is the [PlutoGrid].
  ///
  final Widget Function(
    PlutoGridStateManager? state,
    SplitViewController controller,
    PlutoCell? cell,
  ) child;

  const AdminTable({
    Key? key,
    this.splitController,
    this.viewMode = SplitViewMode.Horizontal,
    this.gripSize = 6.0,
    this.gripColor = Colors.transparent,
    this.gripColorActive = Colors.transparent,
    this.onWeightChanged,
    this.indicator = const SplitIndicator(
      viewMode: SplitViewMode.Horizontal,
      color: Colors.grey,
      isActive: true,
    ),
    this.activeIndicator,
    required this.gridColumns,
    required this.gridRows,
    required this.child,
    this.gridColumnGroups,
    this.onGridLoaded,
    this.onGridChanged,
    this.onGridSelected,
    this.onGridSorted,
    this.onGridRowChecked,
    this.onGridRowDoubleTap,
    this.onGridRowSecondaryTap,
    this.onGridRowsMoved,
    this.onGridColumnsMoved,
    this.gridCreateHeader,
    this.gridCreateFooter,
    this.gridNoRowsWidget,
    this.gridRowColorCallback,
    this.gridColumnMenuDelegate,
    this.griConfiguration,
    this.gridNotifierFilterResolver,
    this.gridMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// The default value of the right side of the split view is 0.7.
    /// If you want to change the default value, change the value of [weights].
    ///
    double weights = 0.7;

    /// If [splitController] is null, create a new one.
    ///
    SplitViewController controller = splitController ??
        SplitViewController(
          limits: [
            null,
            WeightLimit(max: 0.5, min: 0.2),
          ],
          weights: [weights],
        );

    /// The current cell is passed to the right side of the split view.
    /// The right side of the split view is the [child] widget.
    /// The [child] widget is a widget that can be customized by the user.
    /// The [child] widget can be used to display the form of the selected row.
    ///
    ValueNotifier<PlutoCell?> currentCell = ValueNotifier(null);
    ValueNotifier<PlutoGridStateManager?> stateManager = ValueNotifier(null);

    /// Current Theme
    ///
    final theme = Theme.of(context);
    return SplitView(
      activeIndicator: activeIndicator,
      onWeightChanged: (value) {
        weights = value.first ?? 0.7;
        onWeightChanged?.call(value);
      },
      indicator: indicator,
      gripColor: gripColor,
      gripSize: gripSize,
      gripColorActive: gripColorActive,
      viewMode: viewMode,
      controller: controller,
      children: [
        PlutoGrid(
          mode: gridMode ?? PlutoGridMode.selectWithOneTap,
          configuration: griConfiguration ??
              PlutoGridConfiguration(
                style: PlutoGridStyleConfig(
                  gridBorderRadius: const BorderRadius.all(Radius.circular(12)),
                  activatedColor: ElevationOverlay.applySurfaceTint(
                    theme.colorScheme.onPrimary,
                    theme.colorScheme.primary,
                    9,
                  ),
                  activatedBorderColor: theme.colorScheme.primary,
                  iconColor: theme.colorScheme.primary,
                  checkedColor: theme.colorScheme.primaryContainer,
                ),
                shortcut: PlutoGridShortcut(
                  actions: {
                    ...PlutoGridShortcut.defaultActions,
                    LogicalKeySet(
                      LogicalKeyboardKey.meta,
                      LogicalKeyboardKey.keyC,
                    ): CustomCopyAction(),
                  },
                ),
              ),
          createFooter: gridCreateFooter ??
              (stateManager) {
                stateManager.setPageSize(30, notify: false);
                return PlutoPagination(stateManager);
              },
          onChanged: onGridChanged,
          onLoaded: (event) {
            onGridLoaded?.call(event);
            stateManager.value = event.stateManager;
            Future.delayed(
              Duration.zero,
              () => currentCell.value = event.stateManager.currentCell,
            );
          },
          columns: gridColumns,
          rows: gridRows,
          columnGroups: gridColumnGroups,
          columnMenuDelegate: gridColumnMenuDelegate,
          createHeader: gridCreateHeader,
          noRowsWidget: gridNoRowsWidget,
          notifierFilterResolver: gridNotifierFilterResolver,
          onColumnsMoved: onGridColumnsMoved,
          onRowChecked: onGridRowChecked,
          onRowDoubleTap: onGridRowDoubleTap,
          onRowSecondaryTap: onGridRowSecondaryTap,
          onRowsMoved: onGridRowsMoved,
          onSelected: (event) {
            onGridSelected?.call(event);
            currentCell.value = event.cell;
          },
          onSorted: onGridSorted,
          rowColorCallback: gridRowColorCallback,
        ),
        ValueListenableBuilder<PlutoCell?>(
          valueListenable: currentCell,
          builder: (context, cell, widget) => child(
            stateManager.value,
            controller,
            cell,
          ),
        ),
      ],
    );
  }
}

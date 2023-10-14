import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';

class CustomCopyAction extends PlutoGridShortcutAction {
  @override
  void execute({
    required PlutoKeyManagerEvent keyEvent,
    required PlutoGridStateManager stateManager,
  }) {
    if (stateManager.currentCell == null) {
      return;
    }

    final PlutoCell? currentCell = stateManager.currentCell;

    if (currentCell!.value == null) {
      return;
    }

    Clipboard.setData(
      ClipboardData(
        text: currentCell.value.toString(),
      ),
    );
  }
}

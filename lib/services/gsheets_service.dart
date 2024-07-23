import 'package:file_picker/file_picker.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:rrc_tool/constants.dart';
import 'package:rrc_tool/models/asstec_model.dart';
import 'package:rrc_tool/models/item_model.dart';
import 'package:rrc_tool/utils/pdf_util.dart';

class GoogleSheetsService {
  final GSheets _gsheets;

  late Worksheet _asstecsSheet, _itemsSheet;

  GoogleSheetsService(String credentials) : _gsheets = GSheets(credentials);

  Future<void> initializeWorksheets(String spreadsheetId) async {
    final ss = await _gsheets.spreadsheet(spreadsheetId,
        render: ValueRenderOption.formattedValue);

    _asstecsSheet = ss.worksheetByTitle(asstecSheetName)!;
    _itemsSheet = ss.worksheetByTitle(itemsSheetName)!;
  }

  Future<int> findAsstec(String asstecId) async =>
      await _asstecsSheet.values.rowIndexOf(asstecId);

  Future<List<dynamic>> handleAsstecData(
      int asstecRowIndex, String asstecId) async {
    Map<String, String> asstecData =
        await _asstecsSheet.values.map.row(asstecRowIndex);
    List<String> keys = asstecData.keys.toList();
    var asstecItems = [];

    for (int i in [0, 1, 2, 3, 7]) {
      if (asstecData[keys[i]] == null || asstecData[keys[i]] == '') {
        return [false, 'O campo [ ${keys[i]} ] é obrigatório!'];
      }
    }

    List<String> items = await _itemsSheet.values.column(1, fromRow: 2);
    for (int i = 0; i < items.length; i++) {
      if (items[i] == asstecId) {
        asstecItems.add(await _itemsSheet.values.row(i + 2));
      }
    }

    Asstec asstec = Asstec(
        asstecId,
        asstecData[keys[1]]!,
        asstecData[keys[2]]!,
        asstecData[keys[3]]!,
        asstecData[keys[7]]!,
        DateFormat('dd/MM/yy').format(DateTime.now()),
        asstecItems
            .map(
                (e) => Item(asstecId, e[1], e[4], e[5], e[6], e[7], e[8], e[9]))
            .toList());

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      await generatePdf(asstec, selectedDirectory);
      return [true, ''];
    } else {
      return [false, 'Caminho inválido'];
    }
  }
}

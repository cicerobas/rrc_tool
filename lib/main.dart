import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rrc_tool/constants.dart';
import 'package:rrc_tool/home_page.dart';
import 'package:rrc_tool/services/gsheets_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(configBox);

  final box = Hive.box(configBox);
  final credentials = box.get(credentialsKey, defaultValue: '');
  final spreadsheetId = box.get(spreadSheetIdKey, defaultValue: '');

  GoogleSheetsService? gsService;
  if (credentials != '' && spreadsheetId != '') {
    gsService = GoogleSheetsService(credentials);
    await gsService.initializeWorksheets(spreadsheetId);
  }
  runApp(MainApp(
    gsService: gsService,
  ));
}

class MainApp extends StatelessWidget {
  final GoogleSheetsService? gsService;
  const MainApp({super.key, required this.gsService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(gsService: gsService),
    );
  }
}

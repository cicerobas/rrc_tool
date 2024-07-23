import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rrc_tool/constants.dart';

class ConfigPage extends StatelessWidget {
  ConfigPage({super.key});

  final box = Hive.box(configBox);

  saveConfigs(List<String> data) async {
    await box.put(credentialsKey, data[0]);
    await box.put(spreadSheetIdKey, data[1]);
  }

  @override
  Widget build(BuildContext context) {
    final credentials = box.get(credentialsKey);
    final spreadsheetId = box.get(spreadSheetIdKey);
    TextEditingController credentialsFieldController =
        TextEditingController(text: credentials);
    TextEditingController spreadsheetIdFieldController =
        TextEditingController(text: spreadsheetId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Credenciais Google Sheets API:'),
              TextField(
                controller: credentialsFieldController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text('ID da Planilha:'),
              TextField(
                controller: spreadsheetIdFieldController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        saveConfigs([
                          credentialsFieldController.text,
                          spreadsheetIdFieldController.text
                        ]);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Salvar')),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

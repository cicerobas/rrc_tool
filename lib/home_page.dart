import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rrc_tool/config_page.dart';
import 'package:rrc_tool/services/gsheets_service.dart';

class HomePage extends StatefulWidget {
  final GoogleSheetsService? gsService;
  const HomePage({super.key, required this.gsService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool asstecFound = false, isLoading = false, isDone = false;
  late String currentAsstecId;
  late int rowIndex;
  TextEditingController searchFieldController = TextEditingController();

  void searchAsstec(String asstecId) async {
    setState(() {
      isLoading = !isLoading;
    });
    int row = await widget.gsService?.findAsstec(asstecId) ?? -1;
    if (row.isNegative) {
      asstecFound = false;
      showCustomMessage('Asstec [ $asstecId ] não encontrada...');
    } else {
      currentAsstecId = asstecId;
      rowIndex = row;
      asstecFound = true;
    }
    setState(() {
      isLoading = !isLoading;
    });
  }

  void showCustomMessage(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              alignment: Alignment.topRight,
              width: double.infinity,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ConfigPage(),
                    ));
                  },
                  icon: const Icon(Icons.settings))),
          Image.asset(
            'assets/logo.png',
            width: 200,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: TextField(
                      controller: searchFieldController,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Digite o Nº da Asstec'),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Visibility(
                        visible: isLoading,
                        child: const CircularProgressIndicator()),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (searchFieldController.text.isEmpty) {
                          showCustomMessage('Entrada Inválida');
                        } else {
                          setState(() {
                            isDone = false;
                          });
                          searchAsstec(searchFieldController.text);
                        }
                      },
                      label: const Text('Buscar'),
                      icon: const Icon(Icons.search),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Visibility(
                        visible: asstecFound && !isDone,
                        child: ElevatedButton.icon(
                            onPressed: () async {
                              setState(() {
                                isLoading = !isLoading;
                              });
                              var response = await widget.gsService
                                      ?.handleAsstecData(
                                          rowIndex, currentAsstecId) ??
                                  [false, ''];

                              if (response[0]) {
                                isDone = true;
                                searchFieldController.text = '';
                              } else {
                                showCustomMessage(response[1]);
                                isDone = false;
                              }
                              setState(() {
                                isLoading = !isLoading;
                              });
                            },
                            icon: const Icon(Icons.file_copy),
                            label: const Text('Gerar RRC'))),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

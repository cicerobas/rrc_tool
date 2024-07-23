import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/asstec_model.dart';
import 'strings.dart';

Future<void> generatePdf(Asstec asstec, String savePath) async {
  final pdf = pw.Document();
  final logo = pw.MemoryImage(File('assets/logo.png').readAsBytesSync());
  var openSansFont = await rootBundle.load("assets/OpenSans-Regular.ttf");

  String serialNumbers = '';
  String reportDescription = '';
  String itemsSituation = '';
  String rootCause = '';
  String immediateAction = '';
  String technicalAdvice = '';

  for (var item in asstec.items) {
    serialNumbers += ' ${item.serialNumber},';
    reportDescription += '${item.serialNumber}: ${item.reportedProblem}\n';
    itemsSituation += '${item.serialNumber}: ${item.situation}\n';
    rootCause += '${item.serialNumber}: ${item.cause}\n';
    immediateAction += '${item.serialNumber}: ${item.immediateAction}\n';
    technicalAdvice += '${item.serialNumber}: ${item.technicalAdvice}\n';
  }

  pw.Container customTextField(String fieldName, String fieldValue) =>
      pw.Container(
        decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 1, color: PdfColors.black)),
        child: pw.TextField(
          name: fieldName,
          value: fieldValue,
          textStyle: const pw.TextStyle(fontSize: 10),
        ),
      );

  pw.Container customHeaderContainer(String title, {String subtitle = ''}) =>
      pw.Container(
        width: double.infinity,
        decoration: pw.BoxDecoration(
          color: PdfColors.grey300,
          border: pw.Border.all(color: PdfColors.black, width: 1),
        ),
        child: pw.Column(children: [
          pw.Text(
            title,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
          ),
          pw.Text(
            subtitle,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
          ),
        ]),
      );
  pw.Container customGreyContainer(pw.Widget widget) => pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 3),
      decoration: pw.BoxDecoration(
          color: PdfColors.grey300,
          border: pw.Border.all(color: PdfColors.black, width: 1)),
      child: widget);

  pw.TableRow customTableRow({List<String> texts = const ['', '', '']}) {
    double defaultHeight = 16;
    return pw.TableRow(children: [
      pw.Expanded(
        flex: 3,
        child: pw.SizedBox(
          height: defaultHeight,
          child: pw.Center(
              child: pw.Text(texts[0],
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8))),
        ),
      ),
      pw.Expanded(
        flex: 1,
        child: pw.SizedBox(
          height: defaultHeight,
          child: pw.Center(
              child: pw.Text(texts[1],
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8))),
        ),
      ),
      pw.Expanded(
        flex: 1,
        child: pw.SizedBox(
          height: defaultHeight,
          child: pw.Center(
              child: pw.Text(texts[2],
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8))),
        ),
      ),
    ]);
  }

  pw.Text defaultTextSize(String text) => pw.Text(text,
      style:
          pw.TextStyle(fontSize: 8, fontFallback: [pw.Font.ttf(openSansFont)]));

  pdf.addPage(
    pw.MultiPage(
        build: (pw.Context context) => [
              pw.Row(children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                      height: 60,
                      padding: const pw.EdgeInsets.all(4),
                      decoration: pw.BoxDecoration(
                          border:
                              pw.Border.all(color: PdfColors.black, width: 1)),
                      child: pw.Image(logo, fit: pw.BoxFit.fill)),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Container(
                      height: 60,
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      decoration: pw.BoxDecoration(
                          border:
                              pw.Border.all(color: PdfColors.black, width: 1)),
                      child: pw.Center(
                          child: pw.Text(strTitulo,
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold)))),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    height: 60,
                    decoration: pw.BoxDecoration(
                        border:
                            pw.Border.all(color: PdfColors.black, width: 1)),
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          defaultTextSize(strNumero),
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 5),
                            child: customTextField('number', ''),
                          ),
                          defaultTextSize(strDataEmissao),
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 5),
                            child: customTextField('emDate', ''),
                          ),
                        ]),
                  ),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    height: 60,
                    padding: const pw.EdgeInsets.only(left: 5),
                    decoration: pw.BoxDecoration(
                        border:
                            pw.Border.all(color: PdfColors.black, width: 1)),
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Text(strInfo,
                              style: pw.TextStyle(
                                  fontSize: 7, fontWeight: pw.FontWeight.bold)),
                        ]),
                  ),
                ),
              ]),
              pw.Container(
                margin: const pw.EdgeInsets.symmetric(vertical: 6),
                child: pw.Column(children: [
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: [
                        pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 4),
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                      color: PdfColors.black, width: 1)),
                              child: pw.Row(children: [
                                defaultTextSize(strCliente),
                                pw.Expanded(
                                    child: customTextField(
                                        'customer', asstec.customer))
                              ]),
                            )),
                        pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 4),
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                      color: PdfColors.black, width: 1)),
                              child: pw.Row(children: [
                                defaultTextSize(strContato),
                                pw.Expanded(
                                    child: customTextField('contact', ''))
                              ]),
                            )),
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: [
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 2, vertical: 4),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 1)),
                            child: pw.Row(children: [
                              defaultTextSize(strProduto),
                              pw.Expanded(
                                  child:
                                      customTextField('product', asstec.group))
                            ]),
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 2, vertical: 4),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 1)),
                            child: pw.Row(children: [
                              defaultTextSize(strAsstec),
                              pw.Expanded(
                                child: customTextField('asstec_id', asstec.id),
                              ),
                            ]),
                          ),
                        ),
                        pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 4),
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                      color: PdfColors.black, width: 1)),
                              child: pw.Row(children: [
                                defaultTextSize(strNFe),
                                pw.Expanded(
                                    child: customTextField('nfe', asstec.nfe))
                              ]),
                            )),
                      ]),
                ]),
              ),
              pw.Container(
                width: double.infinity,
                decoration: const pw.BoxDecoration(
                    border: pw.Border.symmetric(
                        vertical:
                            pw.BorderSide(color: PdfColors.black, width: 1))),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      customHeaderContainer(strNumeroSerie),
                      pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          child: defaultTextSize(serialNumbers.substring(
                              0, serialNumbers.length - 1))),
                      customHeaderContainer(strDescricaoReclamacao),
                      pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          child: defaultTextSize(reportDescription)),
                      customHeaderContainer(strSituacaoFontes),
                      pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          child: defaultTextSize(itemsSituation)),
                      customHeaderContainer(strCausaFundamental),
                      pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Column(children: [
                            defaultTextSize(rootCause),
                          ])),
                      customHeaderContainer(strAcaoImediata),
                      pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          child: defaultTextSize(immediateAction)),
                      customHeaderContainer(strAvaliacaoCausa),
                      pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Column(children: [
                            defaultTextSize(technicalAdvice),
                          ])),
                      pw.Row(children: [
                        pw.Expanded(
                          flex: 2,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(2),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 1)),
                            child: pw.Row(children: [
                              defaultTextSize('NOME DO RESPONSÁVEL: '),
                              pw.Expanded(
                                  child: customTextField(
                                      'name', asstec.responsibleName))
                            ]),
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(2),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 1)),
                            child: pw.Row(children: [
                              defaultTextSize('DATA: '),
                              pw.Expanded(
                                child: customTextField('date', asstec.date),
                              )
                            ]),
                          ),
                        ),
                      ]),
                      customGreyContainer(pw.Column(children: [
                        pw.Row(children: [
                          defaultTextSize(strReclamacaoProcedente),
                          pw.SizedBox(width: 50),
                          defaultTextSize('PORQUE? '),
                          pw.Expanded(
                            child: customTextField('report_ok', ''),
                          )
                        ]),
                        pw.SizedBox(height: 1),
                        pw.Row(children: [
                          defaultTextSize(strRNCF),
                          pw.SizedBox(width: 50),
                          defaultTextSize('QUAL? '),
                          pw.Expanded(
                            child: customTextField('rncf_exists', ''),
                          ),
                        ]),
                        pw.SizedBox(height: 1),
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              defaultTextSize(strAnaliseGarantia),
                              pw.Row(children: [
                                pw.SizedBox(width: 200),
                                defaultTextSize(strNumRelatorio),
                                pw.Expanded(
                                  child: customTextField('report_number', ''),
                                ),
                              ]),
                            ]),
                      ])),
                      customGreyContainer(pw.Column(children: [
                        pw.Row(children: [
                          defaultTextSize(strAlteracaoSistemaGestaoQualidade),
                          pw.SizedBox(width: 50),
                          defaultTextSize('QUAL? '),
                          pw.Expanded(
                            child: customTextField('alter_sgq', ''),
                          ),
                        ]),
                        pw.SizedBox(height: 1),
                        pw.Row(children: [
                          defaultTextSize(strAtualizacaoRiscosOportunidades),
                          pw.SizedBox(width: 50),
                          defaultTextSize('QUAL? '),
                          pw.Expanded(
                            child: customTextField('alter_risk_oport', ''),
                          ),
                        ]),
                        pw.SizedBox(height: 1),
                        pw.Row(children: [
                          defaultTextSize(strOAC),
                          pw.SizedBox(width: 50),
                          defaultTextSize('OAC Nº: '),
                          pw.Expanded(
                            child: customTextField('oac_number', ''),
                          ),
                        ]),
                      ])),
                      pw.Row(children: [
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(2),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 1)),
                            child: pw.Row(children: [
                              defaultTextSize('ÁREA RESPONSÁVEL: '),
                              pw.Expanded(child: customTextField('area', ''))
                            ]),
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(2),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 1)),
                            child: pw.Row(children: [
                              defaultTextSize('RESPONSÁVEL: '),
                              pw.Expanded(
                                child: customTextField('responsible', ''),
                              )
                            ]),
                          ),
                        ),
                      ]),
                      customHeaderContainer('AÇÕES CORRETIVAS'),
                      pw.Table(
                          border: pw.TableBorder.all(
                              color: PdfColors.black, width: 1),
                          children: [
                            customTableRow(
                                texts: ['AÇÕES', 'RESPONSÁVEL', 'PRAZO']),
                            customTableRow(),
                            customTableRow(),
                            customTableRow(),
                            customTableRow(),
                          ]),
                      customHeaderContainer(strAvaliacaoEficacia,
                          subtitle: strResponsavelQualidade),
                      pw.Row(children: [
                        pw.Expanded(
                          flex: 3,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 2, vertical: 4),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 1)),
                            child: defaultTextSize(strAcaoCorretiva),
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(2),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 1)),
                            child: pw.Row(children: [
                              defaultTextSize(strData),
                              pw.Expanded(
                                child:
                                    customTextField('action_verified_date', ''),
                              )
                            ]),
                          ),
                        ),
                      ]),
                      pw.Row(children: [
                        pw.Expanded(
                          flex: 3,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 2, vertical: 4),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 1)),
                            child: defaultTextSize(strReprogramarAcoes),
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(2),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 1)),
                            child: pw.Row(children: [
                              defaultTextSize('NOVA DATA: '),
                              pw.Expanded(
                                child: customTextField('reprogramed_date', ''),
                              )
                            ]),
                          ),
                        ),
                      ]),
                      pw.Row(children: [
                        pw.Expanded(
                          flex: 3,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 2, vertical: 4),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 1)),
                            child: defaultTextSize(strEmitirRNC),
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(2),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 1)),
                            child: pw.Row(children: [
                              defaultTextSize('RNC Nº: '),
                              pw.Expanded(
                                child: customTextField('rnc_number', ''),
                              )
                            ]),
                          ),
                        ),
                      ]),
                      pw.Row(children: [
                        pw.Expanded(
                          flex: 3,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 2, vertical: 4),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 1)),
                            child:
                                defaultTextSize('ASSINATURA DO RESPONSÁVEL: '),
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(2),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 1)),
                            child: pw.Row(children: [
                              defaultTextSize('DATA: '),
                              pw.Expanded(
                                child: customTextField('qlt_date', ''),
                              )
                            ]),
                          ),
                        ),
                      ]),
                    ]),
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 10),
                child: pw.Text(
                  strCaminhoArquivo,
                  textAlign: pw.TextAlign.start,
                  style: const pw.TextStyle(fontSize: 8),
                ),
              ),
            ]),
  );
  final file = File(
      '$savePath/ASSTEC ${asstec.id} ${asstec.group} - ${asstec.customer}.pdf');
  await file.writeAsBytes(await pdf.save());
}

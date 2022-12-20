import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:intl/intl.dart';

pdfGenerator(List<String> name, List<double> price, List<int> count, List<double> cost) async {
  //Get the total amount.
  double _getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value = grid.rows[i].cells[grid.columns.count - 1].value as String;
      total += double.parse(value);
    }
    return total;
  }

  //Draws the invoice header
  PdfLayoutResult _drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String date = format.format(DateTime.now());

    //Draw rectangle
    page.graphics.drawRectangle(brush: PdfSolidBrush(PdfColor(168, 208, 141, 255)), bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //Draw string
    page.graphics.drawString(date, PdfStandardFont(PdfFontFamily.helvetica, 10),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, -25, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
    page.graphics.drawString('Total payable amount', PdfStandardFont(PdfFontFamily.helvetica, 25),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 3, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawRectangle(bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90), brush: PdfSolidBrush(PdfColor(112, 173, 71)));
    page.graphics.drawString(r'Rs ' + _getTotalAmount(grid).toString(), PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.middle));

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);

    //Draw string
    page.graphics.drawString('Amount', contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.bottom));

    //Create data foramt and convert it to text.
    final Size contentSize = contentFont.measureString(date);

    return PdfTextElement().draw(
        page: page, bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120, contentSize.width + 30, pageSize.height - 120))!;
  }

  //Draws the grid
  void _drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;
    //Draw grand total.
    page.graphics.drawString('Grand Total', PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(quantityCellBounds!.left, result.bounds.bottom + 10, quantityCellBounds!.width, quantityCellBounds!.height));
    page.graphics.drawString(
        '\Rs ' + _getTotalAmount(grid).toString(), PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds!.left, result.bounds.bottom + 10, totalPriceCellBounds!.width, totalPriceCellBounds!.height));
  }

  //Draw the invoice footer data.
  void _drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen = PdfPen(PdfColor(168, 208, 141, 255), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line

    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100), Offset(pageSize.width, pageSize.height - 100));
    const String footerContent = 'Not Zomato\r\n\r\n ¡Provecho! \r\n\r\n Any Questions? Google it :)';
    //Added 30 as a margin for the layout
    page.graphics.drawString(footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right), bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }

  //Create and row for the grid.
  void _addProducts(String productId, String productName, double price, int quantity, double total, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId;
    row.cells[1].value = productName;
    row.cells[2].value = price.toString();
    row.cells[3].value = quantity.toString();
    row.cells[4].value = total.toString();
  }

  //Create PDF grid and return
  PdfGrid _getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 5);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(102, 187, 106, 255));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = '';
    headerRow.cells[1].value = 'Product Name';
    headerRow.cells[2].value = 'Price';
    headerRow.cells[3].value = 'Quantity';
    headerRow.cells[4].value = 'Total';
    for (int i = 0; i < name.length; i++) {
      _addProducts(i.toString(), name[i], price[i], count[i], cost[i], grid);
    }
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent6);
    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding = PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding = PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  final appDirectory = (await getExternalStorageDirectory())!.path;

  //Create a PDF document.
  final PdfDocument document = PdfDocument();

  //Add page to the PDF
  final PdfPage page = document.pages.add();

  //Get page client size
  final Size pageSize = page.getClientSize();

  //Draw rectangle
  page.graphics.drawRectangle(bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height), pen: PdfPen(PdfColor(168, 208, 141, 255)));

  //Generate PDF grid.
  final PdfGrid grid = _getGrid();

  //Draw the header section by creating text element
  final PdfLayoutResult result = _drawHeader(page, pageSize, grid);

  //Draw grid
  _drawGrid(page, grid, result);

  //Add invoice footer
  _drawFooter(page, pageSize);

  //Save and dispose the document.
  final List<int> bytes = document.save();
  document.dispose();

  //Launch file.
  final file = File('$appDirectory/Invoice.pdf');
  await file.writeAsBytes(bytes, flush: true);

  OpenFile.open('$appDirectory/Invoice.pdf');
}

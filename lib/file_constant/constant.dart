import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

final fontStyle = GoogleFonts.lobster(fontSize: 25);
final styles = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
final fontColorStyle = GoogleFonts.lobster(fontSize: 20);

OverlayEntry overlayEntry;
IconData changingicon = Icons.brightness_7;
PdfScrollDirection scrollDirection = PdfScrollDirection.vertical;
PdfPageLayoutMode pageLayoutMode = PdfPageLayoutMode.continuous;
String url;
bool showAppBar = true;
bool showBottomAppBar = true;

GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
PdfViewerController pdfViewerController = PdfViewerController();

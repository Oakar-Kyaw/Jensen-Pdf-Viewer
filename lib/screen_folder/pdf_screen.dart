import 'dart:io';

import '/file_constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../get/controller.dart';
import '../button_and_bar/icon_button.dart';
import '../button_and_bar/drop_downbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../file_folder/store_screen.dart';
import '../button_and_bar/popup_menu_bar.dart';
SharedPreferences _prefs;
class PdfScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<Controller>(
          init: Controller(),
          builder: (value) => Scaffold(
              appBar: showAppBar
                  ? (AppBar(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(15))),
                automaticallyImplyLeading: false,
                elevation: 15,
                title: Container(width: MediaQuery.of(context).size.width * 0.5, child: DropDownBar()),
                actions: [
                  iconButton(
                      icons: changingicon,
                      onPress: () async {
                        await Future.delayed(const Duration(milliseconds: 300), () {
                          value.ChangingIcon(changingicon);
                        });

                        if (changingicon == Icons.brightness_7) {
                          Get.changeThemeMode(ThemeMode.light);
                        } else if (changingicon == Icons.brightness_2) {
                          Get.changeThemeMode(ThemeMode.dark);
                        }
                      }),
                  SizedBox(
                    width: 20,
                  ),
                  PopupMenuBar()
                ],
              ))
                  : null,
              body: GestureDetector(
                onDoubleTap: () {
                  value.ShowAppBarAndBottomAppBar();
                },
                child: SfPdfViewer.file(File('${Get.arguments}'),
                    onPageChanged:(PdfPageChangedDetails detail){

                      savePageNo(detail.newPageNumber);},
                    pageSpacing: 4, canShowScrollHead: true, canShowScrollStatus: true, scrollDirection: scrollDirection, enableTextSelection: true, enableDocumentLinkAnnotation: true, pageLayoutMode: pageLayoutMode, canShowPaginationDialog: true, enableDoubleTapZooming: false, initialZoomLevel: 1, onTextSelectionChanged: (PdfTextSelectionChangedDetails detail) {
                  if (detail.selectedText == null && overlayEntry != null) {
                    overlayEntry.remove();
                    overlayEntry = null;
                  } else if (detail.selectedText != null && overlayEntry == null) {
                    value.showContextMenu(context, detail);
                  }
                }, controller: pdfViewerController, key: pdfViewerKey),
              ),
              bottomNavigationBar: showBottomAppBar
                  ? Container(
                child: BottomAppBar(
                  elevation: 15,
                  color: context.theme.backgroundColor,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    iconButton(
                        icons: Icons.menu,
                        onPress: () async {
                          await Future.delayed(const Duration(milliseconds: 200), () {
                            value.Menu();
                          });
                        }),
                    SizedBox(width: 30),
                    iconButton(
                        icons: Icons.arrow_left,
                        onPress: () {
                          pdfViewerController.previousPage();
                        }),
                    SizedBox(width: 15),
                    iconButton(
                        icons: Icons.arrow_right,
                        onPress: () {
                          pdfViewerController.nextPage();
                        }),
                    SizedBox(width: 30),
                    iconButton(
                        icons: Icons.zoom_in,
                        onPress: () {
                          pdfViewerController.zoomLevel += 0.1;
                        }),
                    SizedBox(width: 15),
                    iconButton(
                        icons: Icons.zoom_out,
                        onPress: () {
                          pdfViewerController.zoomLevel -= 0.1;
                        }),
                    SizedBox(width: 10),
                    iconButton(
                        icons: Icons.book,
                        onPress: () async{
                          _prefs = await SharedPreferences.getInstance();
                          pdfViewerController.jumpToPage(_prefs.getInt('pageno')??1);
                        }),
                  ]),
                ),
              )
                  : null)),
    );
  }
}


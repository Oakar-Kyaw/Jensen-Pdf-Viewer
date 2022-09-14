import 'package:flutter/material.dart';
import '../file_constant/constant.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../button_and_bar/drop_downbar.dart';
import '../file_folder/store_data.dart';
final _wordcontroller=TextEditingController();
final _meaningcontroller=TextEditingController();
bool isLoading = false;
int myPageNumber;
final db = StoreData();
class Controller extends GetxController {
  ChangingDirection(String menutype) {
    if (menutype == "Horizontal") {
      scrollDirection = PdfScrollDirection.horizontal;
      pageLayoutMode = PdfPageLayoutMode.single;
    } else if (menutype == "Vertical") {
      scrollDirection = PdfScrollDirection.vertical;
      pageLayoutMode = PdfPageLayoutMode.continuous;
    }
    update();
  }

  ChangingIcon(IconData icon) {
    if (icon == Icons.brightness_2) {
      changingicon = Icons.brightness_7;
    } else if (icon == Icons.brightness_7) {
      changingicon = Icons.brightness_2;
    }
    update();
  }

  ChangingValue(String value) {
    chosenvalue = value;

    update();
  }

  ShowAppBarAndBottomAppBar() {
    showAppBar = !showAppBar;
    showBottomAppBar = !showBottomAppBar;
    update();
  }

  GetUrl(String word) {
    switch (chosenvalue) {
      case 'Cambridge_Dictionary':
        url = 'https://dictionary.cambridge.org/dictionary/english/$word ';
        break;
      case 'Japanese_to_English':
        url = 'https://jisho.org/search/$word ';
        break;
      case 'Chinese_to_English':
        url = 'https://www.omgchinese.com/dictionary/?q=$word ';
        break;
      case 'English_to_Myanmar':
        url = 'https://www.myordbok.com/definition?q=$word';
        break;
      case 'Google_Translate':
        url = 'https://translate.google.com/?sl=auto&tl=my&text=$word&op=translate';
        break;
      case 'Google_Search':
        url = 'https://www.google.fi/search?q=$word&source=hp&ei=bvrcYYCrIZqc4-EP2pSi-Ag&iflsig=ALs-wAMAAAAAYd0IfnTrhOIDe6szx4tJ6gzVqvj1oAMD&ved=0ahUKEwiAmqXi4aj1AhUazjgGHVqKCI8Q4dUDCAc&uact=5&oq=primitive&gs_lcp=Cgdnd3Mtd2l6EAMyBAgAEBMyBAgAEBMyBAgAEBMyBAgAEBMyBAgAEBMyBAgAEBMyBAgAEBMyBAgAEBMyBAgAEBMyBAgAEBM6BQgAEMQCOgQIABADOgQIABAeOgYIABAKEBNQuQtY5y9gyjZoAnAAeACAAfkBiAHWCpIBBTAuOS4xmAEAoAEBsAEA&sclient=gws-wiz';
        break;
      case 'Korean_to_English':
        url = 'https://en.dict.naver.com/#/search?range=all&query=$word';
        break;
    }
    Get.toNamed('/second/third', arguments: url);

    update();
  }

  showContextMenu(BuildContext context, PdfTextSelectionChangedDetails detail) {
    final OverlayState _overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: detail.globalSelectedRegion.center.dy - 55,
          left: detail.globalSelectedRegion.bottomLeft.dx,
          child: TextButton(
            onPressed: () {
              GetUrl(detail.selectedText);
            },
            child: Text('Search', style: TextStyle(fontSize: 17)),
          ),
        ));
    _overlayState.insert(overlayEntry);
    update();
  }

  Menu() {
    pdfViewerKey.currentState?.openBookmarkView();
    update();
  }

  showBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
            decoration:BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:context.theme.scaffoldBackgroundColor,
            ),
            height:MediaQuery.of(context).size.height*0.59,
            width: MediaQuery.of(context).size.width*0.9,

            alignment: Alignment.center,
            child:Column(

                children:[
                  Container(

                      margin:EdgeInsets.only(left:20,right:20,top:20),
                      child: TextField(
                          controller:_wordcontroller,
                          decoration:InputDecoration(labelText:'Word',labelStyle: fontStyle))),
                  SizedBox(height:20),
                  Container(

                      margin:EdgeInsets.only(left:20,right:20),
                      child: TextField(
                          controller:_meaningcontroller,

                          decoration:InputDecoration(labelText:'Meaning',labelStyle: fontStyle)

                      )),
                  SizedBox(height:20),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      margin:EdgeInsets.only(left:20,right:20),
                      child: ElevatedButton(child:Text("Note"),onPressed:(){

                        db.addNote(_wordcontroller.text,_meaningcontroller.text);
                        Navigator.pop(context);
                        _wordcontroller.text="";
                        _meaningcontroller.text="";
                      })),
                ])
        );
      },
    );
  }
}

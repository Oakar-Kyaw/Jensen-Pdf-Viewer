import 'dart:io';
import 'dart:typed_data';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';

import '../file_constant/constant.dart';

import '../file_folder/file_picker.dart';

import '/button_and_bar/icon_button.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pdf_image_renderer/pdf_image_renderer.dart';

import 'package:path_provider_extention/path_provider_extention.dart';

import '../file_folder/file_manager.dart';

import '../file_folder/sorting.dart';
import '../file_folder/store_screen.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FileSystemEntity> pdffile;
  List<Uint8List> pdfimage = [];
  BannerAd bannerAds;
  AppOpenAd openAd;
  bool isAdsload = false;
  void initState() {
    super.initState();
    initBannerAds();
    loadAd();
    getFile();
  }

  void dispose() {
    super.dispose();
    bannerAds.dispose;
  }

  loadAd() {
    AppOpenAd.load(
        adUnitId: 'ca-app-pub-4233045876357680/8169845508',
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
          print('ad is loaded');
          openAd = ad;
          openAd.show();
        }, onAdFailedToLoad: (error) {
          print('ad failed to load $error');
        }),
        orientation: AppOpenAd.orientationPortrait);
  }

  initBannerAds() {
    bannerAds = BannerAd(
      size: AdSize.banner,
      adUnitId:'ca-app-pub-4233045876357680/9259518166',
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdsload = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print(error.toString());
        },
      ),
      request: AdRequest(),
    );
    bannerAds.load();
  }

  getFile() async {
    await Permission.storage.request();
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
    var fm = FileManager(root: Directory(root)); //
    pdffile = await fm.filesTree(
      excludedPaths: [
        "/storage/emulated/0/Android"
      ],
      extensions: [
        "pdf",
      ],
      sortedBy: FlutterFileUtilsSorting.Alpha,
      //optional, to filter files, list only pdf files
    );


    for (int index = 0; index < pdffile.length; index++) {
      final document = await PdfImageRendererPdf(path: pdffile[index].path);
      await document.open();

      // open a page from the pdf document using the page index
      await document.openPage(pageIndex: 0);

      // get the render size after the page is loaded
      final size = await document.getPageSize(pageIndex: 0);

      // get the actual image of the page
      final pageImage = await document.renderPage(
        pageIndex: 0,
        x: 0,
        y: 0,
        width: size.width, // you can pass a custom size here to crop the image
        height: size.height, // you can pass a custom size here to crop the image
        scale: 1, // increase the scale for better quality (e.g. for zooming)
        background: Colors.white,
      );
      await document.closePage(pageIndex:0);
      document.close();


      setState(() {
        pdfimage.add(pageImage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.all(5),
              children: [
                DrawerHeader(decoration: BoxDecoration(color: Colors.cyan), child: Text("Jensen Pdf Viewer", style: fontStyle)),
                ListTile(
                    leading: iconButton(icons: Icons.folder_open, onPress: () {}),
                    title: Text('Pick Files', style: styles),
                    onTap: () {
                      FilePickers().PickFile();
                    }),
                ListTile(
                    leading: iconButton(icons: Icons.bug_report, onPress: () {}),
                    title: Text('Report Bug', style: styles),
                    onTap: () async {
                      await Future.delayed(const Duration(seconds: 1), () {
                        Get.offNamed('fourth');
                      });
                    })
              ],
            )),
        appBar: AppBar(
          title: Text('Jensen Pdf Viewer', style: fontStyle),
        ),
        body: pdfimage != null
            ? Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 3, right: 3),
                    decoration: BoxDecoration(
                        color: Color(0xFFA9C9CC),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(4, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        )),
                    child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(4),
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                                onTap: () async {
                                  await Future.delayed(const Duration(milliseconds: 200), () {
                                    Get.offNamed('second', arguments: '${pdffile[index].path}');
                                  });
                                  save(pdffile[index].path); },
                                child: Card(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height * 0.8,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: MemoryImage(pdfimage[index]), fit: BoxFit.fill),
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                  ),
                                ));
                          },
                          itemCount: pdfimage.length,
                          itemWidth: 250.0,
                          layout: SwiperLayout.STACK,
                        ))),
              ),
              SizedBox(height: 10),
              Container(
                child: Text("Categories", style: fontStyle),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                    itemCount: pdfimage.length,
                    itemBuilder: (context, index) {
                      String fileName = pdffile[index].path.split('/').last;
                      return Card(
                          color: context.theme.scaffoldBackgroundColor,
                          elevation: 10,
                          margin: EdgeInsets.all(5),
                          child: Container(
                            margin: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                    onTap: () async {
                                      await Future.delayed(const Duration(milliseconds: 200), () {
                                        Get.offNamed('second', arguments: '${pdffile[index].path}');
                                        save(pdffile[index].path); });
                                    },
                                    child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width * 0.25,
                                          maxHeight: MediaQuery.of(context).size.width * 0.21,
                                        ),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: Offset(0, 3), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          image: DecorationImage(image: MemoryImage(pdfimage[index]), fit: BoxFit.fill),
                                        ))),
                                SizedBox(width: 10),
                                Center(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width * 0.4,
                                      margin: EdgeInsets.only(left: 20),
                                      child: Text(
                                        fileName,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: styles,
                                        maxLines: 1,
                                      )),
                                ),
                                iconButton(
                                    icons: Icons.forward,
                                    onPress: () async {
                                      await Future.delayed(const Duration(milliseconds: 200), () {
                                        Get.offNamed('second', arguments: '${pdffile[index].path}');
                                        save(pdffile[index].path); });
                                    }),
                              ],
                            ),
                          ));
                      //  }))
                    }),
              ),
            ],
          ),
        )
            : Container(child: Center(child: Container(margin: EdgeInsets.all(20), child: Text("There is no Pdf in Internal Storage. Tap Menu Icon", style: fontStyle)))),
        bottomNavigationBar: isAdsload
            ? Container(
          width: bannerAds.size.width.toDouble(),
          height: bannerAds.size.height.toDouble(),
          child: AdWidget(
            ad: bannerAds,
          ),
        )
            : null,
      ),
    );
  }
}

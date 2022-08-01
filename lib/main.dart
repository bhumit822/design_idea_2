import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:design_idea_2/controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> url = [
    "https://zazzi.s3.ap-south-1.amazonaws.com/62bc49ec6979a83459ec797b/photography/1658913174998.jpg",
    "https://zazzi.s3.ap-south-1.amazonaws.com/62bc49ec6979a83459ec797b/photography/1658914705131.jpg",
    "https://zazzi.s3.ap-south-1.amazonaws.com/62bc49ec6979a83459ec797b/photography/1658915015659.jpg",
    "https://zazzi.s3.ap-south-1.amazonaws.com/62bc49ec6979a83459ec797b/photography/1658915020140.jpg",
    "https://zazzi.s3.ap-south-1.amazonaws.com/62bc49ec6979a83459ec797b/photography/1658915049848.mp4",
    "https://zazzi.s3.ap-south-1.amazonaws.com/62bc49ec6979a83459ec797b/photography/1658922801024.mp4"
  ];

  // List<String> url = [
  //   "https://player.vimeo.com/progressive_redirect/playback/711046074/rendition/540p/file.mp4?loc=external&oauth2_token_id=57447761&signature=68ab3c549d021f88210f71d5b7bc2c27af4022bc7e6ff3aec0bf9a1957c31a32",
  //   'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
  //   'https://images.pexels.com/photos/719396/pexels-photo-719396.jpeg?auto=compress&cs=tinysrgb&w=600',
  //   'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
  //   'https://images.pexels.com/photos/1624496/pexels-photo-1624496.jpeg?auto=compress&cs=tinysrgb&w=600',
  //   'https://images.pexels.com/photos/459301/pexels-photo-459301.jpeg?auto=compress&cs=tinysrgb&w=600'
  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // Future<Uint8List?> getThumbnail(videoPath) async {
  //   // Uint8List? uint8list;

  //   Uint8List? uint8list = await VideoThumbnail.thumbnailData(
  //     // video: "",
  //     video: videoPath,
  //     timeMs: 2000,
  //     imageFormat: ImageFormat.JPEG,
  //     maxHeight: 1080,
  //     // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
  //     quality: 90,
  //   );
  //   log("errooo2-->");
  //   final fileName = await VideoThumbnail.thumbnailFile(
  //     video:
  //         "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
  //     thumbnailPath: (await getTemporaryDirectory()).path,
  //     imageFormat: ImageFormat.WEBP,
  //     maxHeight:
  //         64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
  //     quality: 75,
  //   );
  //   return uint8list;
  // }

  final c = Get.put(C());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(actions: [
          IconButton(
              onPressed: () async {
                PermissionStatus permissionResult =
                    await Permission.storage.request();
                for (var i in url) {
                  c.progress.value = 0.0;
                  final temppath = await getTemporaryDirectory();
                  final file =
                      File(temppath.path + i.split("photography/").last);
                  // final download = await Dio().get(
                  //   i,
                  //   options: Options(
                  //     responseType: ResponseType.bytes,
                  //     followRedirects: false,
                  //   ),
                  // );

                  Dio().download(i, file.path, onReceiveProgress: (r, t) {
                    final a = (r / t);

                    c.progress.value = a.toPrecision(2);
                    print("$a");
                    // print("Total  $t ++++ Recieved  $r");
                  });

                  // file.writeAsBytesSync(download.data, mode: FileMode.write);
                  // final a = await file.readAsBytes();
                  // ImageGallerySaver.saveImage(a);
                  ImageGallerySaver.saveFile(file.path);
                  // ImageGallerySaver.saveFile(temppath.path,
                  //     name: i.split("photography/").last);
                }
                // var appDocDir = await getTemporaryDirectory();
                // String savePath = appDocDir.path + "/temp.mp4";
                // await Dio().download(
                //     "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
                //     savePath);
                // final result = await ImageGallerySaver.saveFile(savePath);
                // print((await Permission.photos.request()));

                // for (var i in url) {
                //   PermissionStatus permissionResult =
                //       await Permission.storage.request();

                //   final path = await getApplicationDocumentsDirectory();
                //   // print(path.path);
                //   // print((await Permission.storage.status.isGranted));
                //   try {
                //     Directory appDocDirectory = await getTemporaryDirectory();
                //     print(appDocDirectory.path);

                //     final download = await Dio().get(
                //       i,
                //       options: Options(
                //         responseType: ResponseType.bytes,
                //         followRedirects: false,
                //       ),
                //     );

                //     final file = File(path.path + i.split("photography/").last);
                //     file.writeAsBytesSync(download.data, mode: FileMode.write);

                //     print(file.path);
                //   } catch (e) {
                //     print("erroepath ----===>$e");
                //   }

                //   // try {
                //   await Permission.manageExternalStorage.request();
                //   //   final folderName = "Elpixie";
                //   //   Directory newPath =
                //   //       Directory("storage/emulated/0/$folderName/");
                //   //   String path = newPath.path;

                //   //   if (await newPath.exists()) {
                //   //     newPath = newPath;
                //   //   } else {
                //   //     if (permissionResult == PermissionStatus.granted) {
                //   //       //   Directory _appFile = Directory(_storageInfo[0].rootDir + '/MyTestFOlder');
                //   //       // _appFile.create();
                //   //       new Directory("$path").create(recursive: true)
                //   //           // The created directory is returned as a Future.
                //   //           .then((Directory directory) {
                //   //         newPath = directory;
                //   //       });
                //   //     }
                //   //   }
                //   //   final temppath = await getTemporaryDirectory();

                //   //   final download = await Dio().get(
                //   //     i,
                //   //     options: Options(
                //   //       responseType: ResponseType.bytes,
                //   //       followRedirects: false,
                //   //     ),
                //   //   );

                //   //   final file = File(path + i.split("photography/").last);
                //   //   file.writeAsBytesSync(download.data, mode: FileMode.write);
                //   //   print(" patth ========$path");
                //   //   print(" patth ========${file.path}");
                //   //   print(" patth ========${download.data}");
                //   // } catch (e) {
                //   //   print("cpdf error ===============  $e");
                //   // }
                // }
              },
              icon: Icon(Icons.download))
        ]),
        body: Center(
            child: Obx(
          () => CircularProgressIndicator(
            semanticsLabel: "h",
            value: c.progress.value,
          ),
        )),
        // body: Container(
        //   height: Get.height,
        //   width: Get.width,
        //   child: url.length == 0
        //       ? Container()
        //       : MasonryGridView.count(
        //           crossAxisSpacing: 4,
        //           itemCount: url.length,
        //           mainAxisSpacing: 4,
        //           crossAxisCount: 2,
        //           itemBuilder: (context, i) {
        //             if (GetUtils.isVideo(url[i])) {
        //               return FutureBuilder<Uint8List?>(
        //                   future: getThumbnail(url[i]),
        //                   builder: (context, snapshot) {
        //                     if (snapshot.hasData) {
        //                       print("asdasda---${snapshot.data!}");
        //                       return Image.memory(snapshot.data!);
        //                     } else {
        //                       return Container(
        //                         height: 100,
        //                         width: 100,
        //                         color: Colors.red,
        //                       );
        //                     }
        //                   });
        //             } else {
        //               return Image.network(url[i]);
        //             }
        //           }),
        // ),
      ),
    );
  }
}

//
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:pdf_render/pdf_render_widgets.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:universal_html/html.dart' as html;
// // import 'dart:html' as html;
// import 'base64.dart';
//
// class PdfRenderExample extends StatefulWidget {
//   const PdfRenderExample({super.key});
//
//   @override
//   State<PdfRenderExample> createState() => _PdfRenderExampleState();
// }
//
// class _PdfRenderExampleState extends State<PdfRenderExample> {
//   final controller = PdfViewerController();
//   TapDownDetails? _doubleTapDetails;
//   File pdfFile = File('');
//
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     openPdf();
//   }
//
//
//
//   void openPdf() async {
//
//
//       List<int> pdfBytes = base64Decode(base64StringData);
//       final String appDocPath = await _getAppDocPath();
//       print('appDocPath $appDocPath');
//
//
//         pdfFile = File('$appDocPath/my_pdf_file.pdf');
//         print('path $pdfFile');
//         await pdfFile.writeAsBytes(pdfBytes);
//         setState(() {
//
//         });
//
//   }
//
//   Future<String> _getAppDocPath() async {
//     print('web');
//     if (kIsWeb) {
//       print('In Web');
//       final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
//       final completer = Completer<void>();
//
//       uploadInput.onChange.listen((event) {
//         completer.complete();
//       });
//
//       uploadInput.click();
//       await completer.future;
//
//       final file = uploadInput.files!.first;
//       final reader = html.FileReader();
//       reader.readAsArrayBuffer(html.Blob([file]));
//       await reader.onLoad.first;
//
//       final Uint8List pdfBytes = Uint8List.fromList(reader.result as List<int>);
//
//       // Handle the Uint8List data as needed
//       // You may want to save it to the server or perform further processing
//
//       // Return a placeholder value as we don't have direct file access in the web
//       return 'web_path_placeholder';
//     } else {
//       print('In Mobile side');
//       // Running on Android/iOS
//       final Directory appDocDir = await getApplicationDocumentsDirectory();
//       return appDocDir.path;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: ValueListenableBuilder<Matrix4>(
//             // The controller is compatible with ValueListenable<Matrix4> and you can receive notifications on scrolling and zooming of the view.
//               valueListenable: controller,
//               builder: (context, _, child) => Text(controller.isReady
//                   ? 'Page #${controller.currentPageNumber}'
//                   : 'Page -')),
//         ),
//         backgroundColor: pdfFile.path != '' ? Colors.grey : Colors.white,
//
//         body: GestureDetector(
//           // Supporting double-tap gesture on the viewer.
//           onDoubleTapDown: (details) => _doubleTapDetails = details,
//           onDoubleTap: () => controller.ready?.setZoomRatio(
//             zoomRatio: controller.zoomRatio * 1.5,
//             center: _doubleTapDetails!.localPosition,
//           ),
//           child: pdfFile.path != ''
//               ? PdfViewer.openFutureFile(() async => pdfFile.path!,
//
//             viewerController: controller,
//             onError: (err) => print(err),
//             params: const PdfViewerParams(
//               padding: 10,
//               minScale: 1.0,
//             ),
//           )
//               : const Center(child: CircularProgressIndicator()),
//
//         ),
//         floatingActionButton: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             FloatingActionButton(
//               child: const Icon(Icons.first_page),
//               onPressed: () => controller.ready?.goToPage(pageNumber: 1),
//             ),
//             FloatingActionButton(
//               child: const Icon(Icons.navigate_before),
//               onPressed: () => controller.ready?.goToPage(
//                   pageNumber: controller.currentPageNumber == 1
//                       ? controller.currentPageNumber
//                       : controller.currentPageNumber - 1),
//             ),
//             FloatingActionButton(
//               child: const Icon(Icons.navigate_next),
//               onPressed: () => controller.ready?.goToPage(
//                   pageNumber:
//                       controller.pageCount == controller.currentPageNumber
//                           ? controller.currentPageNumber
//                           : controller.currentPageNumber + 1),
//             ),
//             FloatingActionButton(
//               child: const Icon(Icons.last_page),
//               onPressed: () =>
//                   controller.ready?.goToPage(pageNumber: controller.pageCount),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
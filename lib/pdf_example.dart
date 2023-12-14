//
// /// easy psf viewer code
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf_example/printing_data.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:typed_data';
//
// class PdfExample extends StatefulWidget {
//   const PdfExample({super.key});
//
//   @override
//   State<PdfExample> createState() => _PdfExampleState();
// }
//
// class _PdfExampleState extends State<PdfExample> {
//   String pdfUrl = 'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf';
//   late PDFDocument document;
//   bool isLoading = true;
//   String fileName = 'example.pdf';
//
//   @override
//   void initState() {
//     super.initState();
//     loadDocument();
//   }
//
//   loadDocument() async {
//     document = await PDFDocument.fromURL(pdfUrl);
//     setState(() => isLoading = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pdf Viewer'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.print),
//             onPressed: () {
//               printPdf();
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.download),
//             onPressed: () async {
//               downloadFile(context);
//             },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : PDFViewer(
//               document: document,
//               scrollDirection: Axis.vertical,
//               showPicker: false,
//               lazyLoad: true,
//             ),
//     );
//   }
//
//   Future<void> downloadFile(BuildContext context) async {
//     final status = await Permission.storage.request();
//     if (status.isGranted) {
//       final externalDirectory = await getExternalStorageDirectory();
//
//       final filePath = '${externalDirectory!.path}/$fileName';
//
//       final response = await http.get(Uri.parse(pdfUrl));
//
//       if (response.statusCode == 200) {
//         final file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('File downloaded to $filePath'),
//             duration: const Duration(seconds: 3),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Failed to download file'),
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Permission denied to access storage'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }
//
//
//   Future<void> printPdf() async {
//     final pdfData = await fetchPdfBytes(pdfUrl);
//     await Printing.layoutPdf(onLayout: (format) async {
//       return pdfData;
//     });
//   }
//
//   Future<Uint8List> fetchPdfBytes(String url) async {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       print('response bytes ${response.bodyBytes}');
//       return response.bodyBytes;
//     } else {
//       throw Exception('Failed to load PDF');
//     }
//   }
// }
//
// /// old code
// // import 'dart:io';
// // import 'package:http/http.dart' as http;
// // // import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
// // import 'package:flutter/material.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:pdf_example/printing_data.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'dart:typed_data';
// //
// // import 'package:pdf/pdf.dart' as pdf;
// // import 'package:pdf/widgets.dart' as pw;
// //
// // class PdfExample extends StatefulWidget {
// //   const PdfExample({super.key});
// //
// //   @override
// //   State<PdfExample> createState() => _PdfExampleState();
// // }
// //
// // class _PdfExampleState extends State<PdfExample> {
// //   String pdfUrl = 'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf';
// //  // late PDFDocument document;
// //   bool isLoading = true;
// //   String fileName = 'example.pdf';
// //   final pdf = pw.Document();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     loadDocument();
// //   }
// //
// //   loadDocument() async {
// //     //document = await PDFDocument.fromURL(pdfUrl);
// //     setState(() => isLoading = false);
// //
// //     final netImage = await networkImage('https://www.nfet.net/nfet.jpg');
// //
// //     pdf.addPage(pw.Page(build: (pw.Context context) {
// //       return pw.Center(
// //         child: pw.Image(netImage as pw.ImageProvider),
// //       ); // Center
// //     })); // Page
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Pdf Viewer'),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.print),
// //             onPressed: () {
// //               printPdf();
// //             },
// //           ),
// //           IconButton(
// //             icon: const Icon(Icons.download),
// //             onPressed: () async {
// //               downloadFile(context);
// //             },
// //           ),
// //         ],
// //       ),
// //       // body: isLoading
// //       //     ? const Center(child: CircularProgressIndicator())
// //       //     : PDFViewer(
// //       //   document: document,
// //       //   scrollDirection: Axis.vertical,
// //       //   showPicker: false,
// //       //   lazyLoad: true,
// //       // ),
// //
// //       body: pdf.PdfPreview(
// //         maxPageWidth: 700,
// //         build: (format) => pdfDocument.save(),
// //       ),
// //     );
// //   }
// //
// //   Future<void> downloadFile(BuildContext context) async {
// //     final status = await Permission.storage.request();
// //     if (status.isGranted) {
// //       final externalDirectory = await getExternalStorageDirectory();
// //
// //       final filePath = '${externalDirectory!.path}/$fileName';
// //
// //       final response = await http.get(Uri.parse(pdfUrl));
// //
// //       if (response.statusCode == 200) {
// //         final file = File(filePath);
// //         await file.writeAsBytes(response.bodyBytes);
// //
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('File downloaded to $filePath'),
// //             duration: const Duration(seconds: 3),
// //           ),
// //         );
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Failed to download file'),
// //             duration: Duration(seconds: 3),
// //           ),
// //         );
// //       }
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('Permission denied to access storage'),
// //           duration: Duration(seconds: 3),
// //         ),
// //       );
// //     }
// //   }
// //
// //
// //   Future<void> printPdf() async {
// //     final pdfData = await fetchPdfBytes(pdfUrl);
// //     await Printing.layoutPdf(onLayout: (format) async {
// //       return pdfData;
// //     });
// //   }
// //
// //   Future<Uint8List> fetchPdfBytes(String url) async {
// //     final response = await http.get(Uri.parse(url));
// //     if (response.statusCode == 200) {
// //       print('response bytes ${response.bodyBytes}');
// //       return response.bodyBytes;
// //     } else {
// //       throw Exception('Failed to load PDF');
// //     }
// //   }
// // }
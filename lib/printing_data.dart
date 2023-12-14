// import 'dart:async';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// // import 'package:pdf/pdf.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
// import 'dart:ui' as ui;
// import 'package:flutter/foundation.dart'
//     show
//     ErrorDescription,
//     FlutterError,
//     FlutterErrorDetails,
//     InformationCollector,
//     StringProperty;
// import 'package:flutter/services.dart' show MethodCall, MethodChannel;
// import 'dart:io';
// import 'dart:ffi' as ffi;
// import 'dart:io' as io;
// import 'package:ffi/ffi.dart' as ffi;
// import 'package:http/http.dart' as http;
// import 'dart:math' as math;
//
// import 'dart:async';
// import 'dart:typed_data';
//
// import 'package:image/image.dart' as im;
//
// // import 'color.dart';
//
// // import 'point.dart';
//
// // import 'print_job.dart';
//
// /// Flutter pdf printing library
// mixin Printing {
//   /// Prints a Pdf document to a local printer using the platform UI
//   /// the Pdf document is re-built in a [LayoutCallback] each time the
//   /// user changes a setting like the page format or orientation.
//   ///
//   /// returns a future with a `bool` set to true if the document is printed
//   /// and false if it is canceled.
//   /// throws an exception in case of error
//   ///
//   /// Set [usePrinterSettings] to true to use the configuration defined by
//   /// the printer. May not work for all the printers and can depend on the
//   /// drivers. (Supported platforms: Windows)
//   static Future<bool> layoutPdf({
//     required LayoutCallback onLayout,
//     String name = 'Document',
//     PdfPageFormat format = PdfPageFormat.standard,
//     bool dynamicLayout = true,
//     bool usePrinterSettings = false,
//   }) {
//     return PrintingPlatform.instance.layoutPdf(
//       null,
//       onLayout,
//       name,
//       format,
//       dynamicLayout,
//       usePrinterSettings,
//     );
//   }
//
//   /// Enumerate the available printers on the system.
//   ///
//   /// This is not supported on all platforms. Check the result of [info] to
//   /// find at runtime if this feature is available or not.
//   static Future<List<Printer>> listPrinters() {
//     return PrintingPlatform.instance.listPrinters();
//   }
//
//   /// Opens the native printer picker interface, and returns the URL of the
//   /// selected printer.
//   ///
//   /// This is not supported on all platforms. Check the result of [info] to
//   /// find at runtime if this feature is available or not.
//   static Future<Printer?> pickPrinter({
//     required BuildContext context,
//     Rect? bounds,
//     String? title,
//   }) async {
//     final printingInfo = await info();
//
//     if (printingInfo.canListPrinters) {
//       final printers = await listPrinters();
//       printers.sort((a, b) {
//         if (a.isDefault) {
//           return -1;
//         }
//         if (b.isDefault) {
//           return 1;
//         }
//         return a.name.compareTo(b.name);
//       });
//
//       // ignore: use_build_context_synchronously
//       return await showDialog<Printer>(
//         context: context,
//         builder: (context) => SimpleDialog(
//           title: Text(title ?? 'Select Printer'),
//           children: [
//             for (final printer in printers)
//               if (printer.isAvailable)
//                 SimpleDialogOption(
//                   onPressed: () => Navigator.of(context).pop(printer),
//                   child: Text(
//                     printer.name,
//                     style: TextStyle(
//                       fontStyle: printer.isDefault
//                           ? FontStyle.italic
//                           : FontStyle.normal,
//                     ),
//                   ),
//                 ),
//           ],
//         ),
//       );
//     }
//
//     bounds ??= Rect.fromCircle(center: Offset.zero, radius: 10);
//
//     return await PrintingPlatform.instance.pickPrinter(bounds);
//   }
//
//   /// Prints a Pdf document to a specific local printer with no UI
//   ///
//   /// returns a future with a `bool` set to true if the document is printed
//   /// and false if it is canceled.
//   /// throws an exception in case of error
//   ///
//   /// This is not supported on all platforms. Check the result of [info] to
//   /// find at runtime if this feature is available or not.
//   ///
//   /// Set [usePrinterSettings] to true to use the configuration defined by
//   /// the printer. May not work for all the printers and can depend on the
//   /// drivers. (Supported platforms: Windows)
//   static FutureOr<bool> directPrintPdf({
//     required Printer printer,
//     required LayoutCallback onLayout,
//     String name = 'Document',
//     PdfPageFormat format = PdfPageFormat.standard,
//     bool dynamicLayout = true,
//     bool usePrinterSettings = false,
//   }) {
//     return PrintingPlatform.instance.layoutPdf(
//       printer,
//       onLayout,
//       name,
//       format,
//       dynamicLayout,
//       usePrinterSettings,
//     );
//   }
//
//   /// Displays a platform popup to share the Pdf document to another application.
//   ///
//   /// [subject] will be the email subject if selected application is email.
//   ///
//   /// [body] will be the extra text that can be shared along with the Pdf document.
//   /// For email application [body] will be the email body text.
//   ///
//   /// [emails] will be the list of emails to which you want to share the Pdf document.
//   /// If the selected application is email application then the these [emails] will be
//   /// filled in the to address.
//   ///
//   /// [subject] and [body] will only work for Android and iOS platforms.
//   /// [emails] will only work for Android Platform.
//   static Future<bool> sharePdf({
//     required Uint8List bytes,
//     String filename = 'document.pdf',
//     Rect? bounds,
//     String? subject,
//     String? body,
//     List<String>? emails,
//   }) {
//     bounds ??= Rect.fromCircle(center: Offset.zero, radius: 10);
//
//     return PrintingPlatform.instance.sharePdf(
//       bytes,
//       filename,
//       bounds,
//       subject,
//       body,
//       emails,
//     );
//   }
//
//   /// Convert an html document to a pdf data
//   ///
//   /// This is not supported on all platforms. Check the result of [info] to
//   /// find at runtime if this feature is available or not.
//   static Future<Uint8List> convertHtml({
//     required String html,
//     String? baseUrl,
//     PdfPageFormat format = PdfPageFormat.standard,
//   }) {
//     return PrintingPlatform.instance.convertHtml(
//       html,
//       baseUrl,
//       format,
//     );
//   }
//
//   /// Returns a [PrintingInfo] object representing the capabilities
//   /// supported for the current platform
//   static Future<PrintingInfo> info() {
//     return PrintingPlatform.instance.info();
//   }
//
//   /// Convert a PDF to a list of images.
//   /// ```dart
//   /// await for (final page in Printing.raster(content)) {
//   ///   final image = page.asImage();
//   /// }
//   /// ```
//   ///
//   /// This is not supported on all platforms. Check the result of [info] to
//   /// find at runtime if this feature is available or not.
//   static Stream<PdfRaster> raster(
//       Uint8List document, {
//         List<int>? pages,
//         double dpi = PdfPageFormat.inch,
//       }) {
//     assert(dpi > 0);
//
//     return PrintingPlatform.instance.raster(document, pages, dpi);
//   }
// }
//
// /// Callback used to generate the Pdf document dynamically when the user
// /// changes the page settings: size and margins
// typedef LayoutCallback = FutureOr<Uint8List> Function(PdfPageFormat format);
//
// /// The interface that implementations of printing must implement.
// abstract class PrintingPlatform extends PlatformInterface {
//   /// Constructs a PrintingPlatform.
//   PrintingPlatform() : super(token: _token);
//
//   static final Object _token = Object();
//
//   static PrintingPlatform _instance = MethodChannelPrinting();
//
//   /// The default instance of [PrintingPlatform] to use.
//   ///
//   /// Defaults to [MethodChannelPrinting].
//   static PrintingPlatform get instance => _instance;
//
//   /// Platform-specific plugins should set this with their own platform-specific
//   /// class that extends [PrintingPlatform] when they register themselves.
//   static set instance(PrintingPlatform instance) {
//     PlatformInterface.verifyToken(instance, _token);
//     _instance = instance;
//   }
//
//   /// Returns a [PrintingInfo] object representing the capabilities
//   /// supported for the current platform
//   Future<PrintingInfo> info();
//
//   /// Prints a Pdf document to a local printer using the platform UI
//   /// the Pdf document is re-built in a [LayoutCallback] each time the
//   /// user changes a setting like the page format or orientation.
//   ///
//   /// returns a future with a `bool` set to true if the document is printed
//   /// and false if it is canceled.
//   /// throws an exception in case of error
//   Future<bool> layoutPdf(
//       Printer? printer,
//       LayoutCallback onLayout,
//       String name,
//       PdfPageFormat format,
//       bool dynamicLayout,
//       bool usePrinterSettings,
//       );
//
//   /// Enumerate the available printers on the system.
//   Future<List<Printer>> listPrinters();
//
//   /// Opens the native printer picker interface, and returns the URL of the selected printer.
//   Future<Printer?> pickPrinter(Rect bounds);
//
//   /// Displays a platform popup to share the Pdf document to another application.
//   ///
//   /// [subject] will be the email subject if selected application is email.
//   ///
//   /// [body] will be the extra text that can be shared along with the Pdf document.
//   /// For email application [body] will be the email body text.
//   ///
//   /// [emails] will be the list of emails to which you want to share the Pdf document.
//   /// If the selected application is email application then the these [emails] will be
//   /// filled in the to address.
//   ///
//   /// [subject] and [body] will only work for Android and iOS platforms.
//   /// [emails] will only work for Android Platform.
//   Future<bool> sharePdf(
//       Uint8List bytes,
//       String filename,
//       Rect bounds,
//       String? subject,
//       String? body,
//       List<String>? emails,
//       );
//
//   /// Convert an html document to a pdf data
//   Future<Uint8List> convertHtml(
//       String html,
//       String? baseUrl,
//       PdfPageFormat format,
//       );
//
//   /// Convert a Pdf document to bitmap images
//   Stream<PdfRaster> raster(
//       Uint8List document,
//       List<int>? pages,
//       double dpi,
//       );
// }
//
// /// Information about a printer
// @immutable
// class Printer {
//   /// Create a printer information
//   const Printer({
//     required this.url,
//     String? name,
//     this.model,
//     this.location,
//     this.comment,
//     bool? isDefault,
//     bool? isAvailable,
//   })  : name = name ?? url,
//         isDefault = isDefault ?? false,
//         isAvailable = isAvailable ?? true;
//
//   /// Create an information object from a dictionnary
//   factory Printer.fromMap(Map<dynamic, dynamic> map) => Printer(
//     url: map['url'],
//     name: map['name'],
//     model: map['model'],
//     location: map['location'],
//     comment: map['comment'],
//     isDefault: map['default'],
//     isAvailable: map['available'],
//   );
//
//   /// The platform specific printer identification
//   final String url;
//
//   /// The display name of the printer
//   final String name;
//
//   /// The printer model
//   final String? model;
//
//   /// The physical location of the printer
//   final String? location;
//
//   /// A user comment about the printer
//   final String? comment;
//
//   /// Is this the default printer on the system
//   final bool isDefault;
//
//   /// The printer is available for printing
//   final bool isAvailable;
//
//   @override
//   String toString() => '''$runtimeType $name
//   url:$url
//   location:$location
//   model:$model
//   comment:$comment
//   isDefault:$isDefault
//   isAvailable: $isAvailable''';
//
//   Map<String, Object?> toMap() => {
//     'url': url,
//     'name': name,
//     'model': model,
//     'location': location,
//     'comment': comment,
//     'default': isDefault,
//     'available': isAvailable,
//   };
// }
//
// /// Capabilities supported for the current platform
// class PrintingInfo {
//   /// Create an information object
//   const PrintingInfo({
//     this.directPrint = false,
//     this.dynamicLayout = false,
//     this.canPrint = false,
//     this.canConvertHtml = false,
//     this.canListPrinters = false,
//     this.canShare = false,
//     this.canRaster = false,
//   });
//
//   /// Create an information object from a dictionnary
//   factory PrintingInfo.fromMap(Map<dynamic, dynamic> map) => PrintingInfo(
//     directPrint: map['directPrint'] ?? false,
//     dynamicLayout: map['dynamicLayout'] ?? false,
//     canPrint: map['canPrint'] ?? false,
//     canConvertHtml: map['canConvertHtml'] ?? false,
//     canListPrinters: map['canListPrinters'] ?? false,
//     canShare: map['canShare'] ?? false,
//     canRaster: map['canRaster'] ?? false,
//   );
//
//   /// Default information with no feature available
//   static const PrintingInfo unavailable = PrintingInfo();
//
//   /// The platform can print directly to a printer
//   final bool directPrint;
//
//   /// The platform can request a dynamic layout when the user change
//   /// the printer or printer settings
//   final bool dynamicLayout;
//
//   /// The platform implementation is able to print a Pdf document
//   final bool canPrint;
//
//   /// The platform implementation is able to convert an html document to Pdf
//   final bool canConvertHtml;
//
//   /// The platform implementation is able list the available printers on the system
//   final bool canListPrinters;
//
//   /// The platform implementation is able to share a Pdf document
//   /// to other applications
//   final bool canShare;
//
//   /// The platform implementation is able to convert pages from a Pdf document
//   /// to a stream of images
//   final bool canRaster;
//
//   @override
//   String toString() => '''$runtimeType:
//   canPrint: $canPrint
//   directPrint: $directPrint
//   dynamicLayout: $dynamicLayout
//   canConvertHtml: $canConvertHtml
//   canListPrinters: $canListPrinters
//   canShare: $canShare
//   canRaster: $canRaster''';
// }
//
// /// Represents a bitmap image
// class PdfRaster extends PdfRasterBase {
//   /// Create a bitmap image
//   PdfRaster(
//       int width,
//       int height,
//       Uint8List pixels,
//       ) : super(width, height, true, pixels);
//
//   /// Decode RGBA raw image to dart:ui Image
//   Future<ui.Image> toImage() {
//     final comp = Completer<ui.Image>();
//     ui.decodeImageFromPixels(
//       pixels,
//       width,
//       height,
//       ui.PixelFormat.rgba8888,
//           (ui.Image image) => comp.complete(image),
//     );
//     return comp.future;
//   }
//
//   /// Convert to a PNG image
//   @override
//   Future<Uint8List> toPng() async {
//     final image = await toImage();
//     final data = await image.toByteData(format: ui.ImageByteFormat.png);
//     return data!.buffer.asUint8List();
//   }
// }
//
// /// Image provider for a [PdfRaster]
// class PdfRasterImage extends ImageProvider<PdfRaster> {
//   /// Create an ImageProvider from a [PdfRaster]
//   PdfRasterImage(this.raster);
//
//   /// The image source
//   final PdfRaster raster;
//
//   Future<ImageInfo> _loadAsync() async {
//     final uiImage = await raster.toImage();
//     return ImageInfo(image: uiImage, scale: 1);
//   }
//
//   @override
//   ImageStreamCompleter loadImage(PdfRaster key, ImageDecoderCallback decode) {
//     return OneFrameImageStreamCompleter(_loadAsync());
//   }
//
//   @override
//   Future<PdfRaster> obtainKey(ImageConfiguration configuration) async {
//     return raster;
//   }
// }
//
// const MethodChannel _channel = MethodChannel('net.nfet.printing');
//
// /// An implementation of [PrintingPlatform] that uses method channels.
// class MethodChannelPrinting extends PrintingPlatform {
//   /// Create a [PrintingPlatform] object for method channels.
//   MethodChannelPrinting() : super() {
//     _channel.setMethodCallHandler(_handleMethod);
//   }
//
//   static final _printJobs = PrintJobs();
//
//   /// Callbacks from platform plugin
//   static Future<dynamic> _handleMethod(MethodCall call) async {
//     switch (call.method) {
//       case 'onLayout':
//         final job = _printJobs.getJob(call.arguments['job']);
//         if (job == null) {
//           return;
//         }
//         final format = PdfPageFormat(
//           call.arguments['width'],
//           call.arguments['height'],
//           marginLeft: call.arguments['marginLeft'],
//           marginTop: call.arguments['marginTop'],
//           marginRight: call.arguments['marginRight'],
//           marginBottom: call.arguments['marginBottom'],
//         );
//
//         Uint8List bytes;
//         try {
//           bytes = await job.onLayout!(format);
//         } catch (e, s) {
//           InformationCollector? collector;
//
//           assert(() {
//             collector = () sync* {
//               yield StringProperty('PageFormat', format.toString());
//             };
//             return true;
//           }());
//
//           FlutterError.reportError(FlutterErrorDetails(
//             exception: e,
//             stack: s,
//             stackFilter: (input) => input,
//             library: 'printing',
//             context: ErrorDescription('while generating a PDF'),
//             informationCollector: collector,
//           ));
//
//           // if (job.useFFI) {
//           //   return setErrorFfi(job, e.toString());
//           // }
//
//           rethrow;
//         }
//
//         // if (job.useFFI) {
//         //   return setDocumentFfi(job, bytes);
//         // }
//
//         return Uint8List.fromList(bytes);
//       case 'onCompleted':
//         final bool? completed = call.arguments['completed'];
//         final String? error = call.arguments['error'];
//         final job = _printJobs.getJob(call.arguments['job']);
//         if (job != null) {
//           if (completed == false && error != null) {
//             job.onCompleted!.completeError(error);
//           } else {
//             job.onCompleted!.complete(completed);
//           }
//         }
//         break;
//       case 'onHtmlRendered':
//         final job = _printJobs.getJob(call.arguments['job']);
//         if (job != null) {
//           job.onHtmlRendered!.complete(call.arguments['doc']);
//         }
//         break;
//       case 'onHtmlError':
//         final job = _printJobs.getJob(call.arguments['job']);
//         if (job != null) {
//           job.onHtmlRendered!.completeError(call.arguments['error']);
//         }
//         break;
//       case 'onPageRasterized':
//         final job = _printJobs.getJob(call.arguments['job']);
//         if (job != null) {
//           final raster = PdfRaster(
//             call.arguments['width'],
//             call.arguments['height'],
//             call.arguments['image'],
//           );
//           job.onPageRasterized!.add(raster);
//         }
//         break;
//       case 'onPageRasterEnd':
//         final job = _printJobs.getJob(call.arguments['job']);
//         if (job != null) {
//           final dynamic error = call.arguments['error'];
//           if (error != null) {
//             job.onPageRasterized!.addError(error);
//           }
//           await job.onPageRasterized!.close();
//           _printJobs.remove(job.index);
//         }
//         break;
//     }
//   }
//
//   @override
//   Future<PrintingInfo> info() async {
//     _channel.setMethodCallHandler(_handleMethod);
//     Map<dynamic, dynamic>? result;
//
//     try {
//       result = await _channel.invokeMethod(
//         'printingInfo',
//         <String, dynamic>{},
//       );
//     } catch (e) {
//       assert(() {
//         // ignore: avoid_print
//         print('Error getting printing info: $e');
//         return true;
//       }());
//
//       return PrintingInfo.unavailable;
//     }
//
//     return PrintingInfo.fromMap(result!);
//   }
//
//   @override
//   Future<bool> layoutPdf(
//       Printer? printer,
//       LayoutCallback onLayout,
//       String name,
//       PdfPageFormat format,
//       bool dynamicLayout,
//       bool usePrinterSettings,
//       ) async {
//     final job = _printJobs.add(
//       onCompleted: Completer<bool>(),
//       onLayout: onLayout,
//     );
//
//     final params = <String, dynamic>{
//       if (printer != null) 'printer': printer.url,
//       'name': name,
//       'job': job.index,
//       'width': format.width,
//       'height': format.height,
//       'marginLeft': format.marginLeft,
//       'marginTop': format.marginTop,
//       'marginRight': format.marginRight,
//       'marginBottom': format.marginBottom,
//       'dynamic': dynamicLayout,
//       'usePrinterSettings': usePrinterSettings,
//     };
//
//     await _channel.invokeMethod<int>('printPdf', params);
//     try {
//       return await job.onCompleted!.future;
//     } finally {
//       _printJobs.remove(job.index);
//     }
//   }
//
//   @override
//   Future<List<Printer>> listPrinters() async {
//     final params = <String, dynamic>{};
//     final list =
//     await _channel.invokeMethod<List<dynamic>>('listPrinters', params);
//
//     final printers = <Printer>[];
//
//     for (final printer in list!) {
//       printers.add(Printer.fromMap(printer));
//     }
//
//     return printers;
//   }
//
//   @override
//   Future<Printer?> pickPrinter(Rect bounds) async {
//     final params = <String, dynamic>{
//       'x': bounds.left,
//       'y': bounds.top,
//       'w': bounds.width,
//       'h': bounds.height,
//     };
//     final printer = await _channel.invokeMethod<Map<dynamic, dynamic>>(
//         'pickPrinter', params);
//     if (printer == null) {
//       return null;
//     }
//     return Printer.fromMap(printer);
//   }
//
//   @override
//   Future<bool> sharePdf(
//       Uint8List bytes,
//       String filename,
//       Rect bounds,
//       String? subject,
//       String? body,
//       List<String>? emails,
//       ) async {
//     final params = <String, dynamic>{
//       'doc': Uint8List.fromList(bytes),
//       'name': filename,
//       'subject': subject,
//       'body': body,
//       'emails': emails,
//       'x': bounds.left,
//       'y': bounds.top,
//       'w': bounds.width,
//       'h': bounds.height,
//     };
//     return await _channel.invokeMethod<int>('sharePdf', params) != 0;
//   }
//
//   @override
//   Future<Uint8List> convertHtml(
//       String html, String? baseUrl, PdfPageFormat format) async {
//     final job = _printJobs.add(
//       onHtmlRendered: Completer<Uint8List>(),
//     );
//
//     final params = <String, dynamic>{
//       'html': html,
//       'baseUrl': baseUrl,
//       'width': format.width,
//       'height': format.height,
//       'marginLeft': format.marginLeft,
//       'marginTop': format.marginTop,
//       'marginRight': format.marginRight,
//       'marginBottom': format.marginBottom,
//       'job': job.index,
//     };
//
//     await _channel.invokeMethod<void>('convertHtml', params);
//     final result = await job.onHtmlRendered!.future;
//     _printJobs.remove(job.index);
//     return result;
//   }
//
//   @override
//   Stream<PdfRaster> raster(
//       Uint8List document,
//       List<int>? pages,
//       double dpi,
//       ) {
//     final job = _printJobs.add(
//       onPageRasterized: StreamController<PdfRaster>(),
//     );
//
//     final params = <String, dynamic>{
//       'doc': Uint8List.fromList(document),
//       'pages': pages,
//       'scale': dpi / PdfPageFormat.inch,
//       'job': job.index,
//     };
//
//     _channel.invokeMethod<void>('rasterPdf', params);
//     return job.onPageRasterized!.stream;
//   }
// }
//
// /// Represents a print job to communicate with the platform implementation
// class PrintJob {
//   /// Create a print job
//   const PrintJob._({
//     required this.index,
//     this.onLayout,
//     this.onHtmlRendered,
//     this.onCompleted,
//     this.onPageRasterized,
//     required this.useFFI,
//   });
//
//   /// Callback used when calling Printing.layoutPdf()
//   final LayoutCallback? onLayout;
//
//   /// Callback used when calling Printing.convertHtml()
//   final Completer<Uint8List>? onHtmlRendered;
//
//   /// Future triggered when the job is done
//   final Completer<bool>? onCompleted;
//
//   /// Stream of rasterized pages
//   final StreamController<PdfRaster>? onPageRasterized;
//
//   /// The Job number
//   final int index;
//
//   /// Use the FFI side-channel to send the PDF data
//   final bool useFFI;
// }
//
// /// Represents a list of print jobs
// class PrintJobs {
//   /// Create a list print jobs
//   PrintJobs();
//
//   static var _currentIndex = 0;
//
//   final _printJobs = <int, PrintJob>{};
//
//   /// Add a print job to the list
//   PrintJob add({
//     LayoutCallback? onLayout,
//     Completer<Uint8List>? onHtmlRendered,
//     Completer<bool>? onCompleted,
//     StreamController<PdfRaster>? onPageRasterized,
//   }) {
//     final job = PrintJob._(
//       index: _currentIndex++,
//       onLayout: onLayout,
//       onHtmlRendered: onHtmlRendered,
//       onCompleted: onCompleted,
//       onPageRasterized: onPageRasterized,
//       useFFI: Platform.isMacOS || Platform.isIOS,
//     );
//     _printJobs[job.index] = job;
//     return job;
//   }
//
//   /// Retrive an existing job
//   PrintJob? getJob(int index) {
//     return _printJobs[index];
//   }
//
//   /// remove a print job from the list
//   void remove(int index) {
//     _printJobs.remove(index);
//   }
// }
//
// /// Load the dynamic library
// final ffi.DynamicLibrary _dynamicLibrary = _open();
// ffi.DynamicLibrary _open() {
//   if (io.Platform.isMacOS || io.Platform.isIOS) {
//     return ffi.DynamicLibrary.process();
//   }
//   throw UnsupportedError('This platform is not supported.');
// }
//
// /// Set the Pdf document data
// void setDocumentFfi(PrintJob job, Uint8List data) {
//   final nativeBytes = ffi.calloc<ffi.Uint8>(data.length);
//   nativeBytes.asTypedList(data.length).setAll(0, data);
//   _setDocument(job.index, nativeBytes, data.length);
//   ffi.calloc.free(nativeBytes);
// }
//
// final _SetDocumentDart _setDocument =
// _dynamicLibrary.lookupFunction<_SetDocumentC, _SetDocumentDart>(
//   'net_nfet_printing_set_document',
// );
//
// typedef _SetDocumentC = ffi.Void Function(
//     ffi.Uint32 job,
//     ffi.Pointer<ffi.Uint8> data,
//     ffi.Uint64 size,
//     );
//
// typedef _SetDocumentDart = void Function(
//     int job,
//     ffi.Pointer<ffi.Uint8> data,
//     int size,
//     );
//
// /// Set the Pdf Error message
// void setErrorFfi(PrintJob job, String message) {
//   _setError(job.index, ffi.StringUtf8Pointer(message).toNativeUtf8());
// }
//
// final _SetErrorDart _setError =
// _dynamicLibrary.lookupFunction<_SetErrorC, _SetErrorDart>(
//   'net_nfet_printing_set_error',
// );
//
// typedef _SetErrorC = ffi.Void Function(
//     ffi.Uint32 job,
//     ffi.Pointer<ffi.Utf8> message,
//     );
//
// typedef _SetErrorDart = void Function(
//     int job,
//     ffi.Pointer<ffi.Utf8> message,
//     );
//
// /// Download an image from the network.
// Future<ImageProvider> networkImage(
//     String url, {
//       bool cache = true,
//       Map<String, String>? headers,
//      // PdfImageOrientation? orientation,
//       double? dpi,
//       PdfBaseCache? pdfCache,
//     }) async {
//   pdfCache ??= PdfBaseCache.defaultCache;
//   final bytes = await pdfCache.resolve(
//     name: url,
//     uri: Uri.parse(url),
//     cache: cache,
//     headers: headers,
//   );
//
//   return MemoryImage(bytes);
//   // return MemoryImage(bytes, orientation: orientation, dpi: dpi);
// }
//
// /// Store data in a cache
// abstract class PdfBaseCache {
//   /// Create a cache
//   const PdfBaseCache();
//
//   /// The default cache used when none specified
//   static PdfBaseCache defaultCache = PdfMemoryCache();
//
//   /// Add some data to the cache
//   Future<void> add(String key, Uint8List bytes);
//
//   /// Retrieve some data from the cache
//   Future<Uint8List?> get(String key);
//
//   /// Does the cache contains this data?
//   Future<bool> contains(String key);
//
//   /// Remove some data from the cache
//   Future<void> remove(String key);
//
//   /// Clear the cache
//   Future<void> clear();
//
//   /// Download the font
//   Future<Uint8List?> _download(
//       Uri uri, {
//         Map<String, String>? headers,
//       }) async {
//     final response = await http.get(uri, headers: headers);
//     if (response.statusCode != 200) {
//       return null;
//     }
//
//     return response.bodyBytes;
//   }
//
//   /// Resolve the data
//   Future<Uint8List> resolve({
//     required String name,
//     required Uri uri,
//     bool cache = true,
//     Map<String, String>? headers,
//   }) async {
//     if (cache && await contains(name)) {
//       return (await get(name))!;
//     }
//
//     final bytes = await _download(uri, headers: headers);
//
//     if (bytes == null) {
//       throw FlutterError('Unable to download $uri');
//     }
//
//     if (cache) {
//       await add(name, bytes);
//     }
//
//     return bytes;
//   }
// }
//
// /// Memory cache
// class PdfMemoryCache extends PdfBaseCache {
//   /// Create a memory cache
//   PdfMemoryCache();
//
//   final _imageCache = <String, Uint8List>{};
//
//   Timer? _timer;
//
//   void _resetTimer() {
//     _timer?.cancel();
//     _timer = Timer(const Duration(minutes: 20), () {
//       clear();
//     });
//   }
//
//   @override
//   Future<void> add(String key, Uint8List bytes) async {
//     _imageCache[key] = bytes;
//     _resetTimer();
//   }
//
//   @override
//   Future<Uint8List?> get(String key) async {
//     _resetTimer();
//     return _imageCache[key];
//   }
//
//   @override
//   Future<void> clear() async {
//     _imageCache.clear();
//   }
//
//   @override
//   Future<bool> contains(String key) async {
//     return _imageCache.containsKey(key);
//   }
//
//   @override
//   Future<void> remove(String key) async {
//     _imageCache.remove(key);
//   }
// }
//
// /*
//  * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
//  *
//  * Licensed under the Apache License, Version 2.0 (the "License");
//  * you may not use this file except in compliance with the License.
//  * You may obtain a copy of the License at
//  *
//  *     http://www.apache.org/licenses/LICENSE-2.0
//  *
//  * Unless required by applicable law or agreed to in writing, software
//  * distributed under the License is distributed on an "AS IS" BASIS,
//  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  * See the License for the specific language governing permissions and
//  * limitations under the License.
//  */
//
//
//
// class PdfPageFormat {
//   const PdfPageFormat(this.width, this.height,
//       {double marginTop = 0.0,
//         double marginBottom = 0.0,
//         double marginLeft = 0.0,
//         double marginRight = 0.0,
//         double? marginAll})
//       : assert(width > 0),
//         assert(height > 0),
//         marginTop = marginAll ?? marginTop,
//         marginBottom = marginAll ?? marginBottom,
//         marginLeft = marginAll ?? marginLeft,
//         marginRight = marginAll ?? marginRight;
//
//   static const PdfPageFormat a3 =
//   PdfPageFormat(29.7 * cm, 42 * cm, marginAll: 2.0 * cm);
//   static const PdfPageFormat a4 =
//   PdfPageFormat(21.0 * cm, 29.7 * cm, marginAll: 2.0 * cm);
//   static const PdfPageFormat a5 =
//   PdfPageFormat(14.8 * cm, 21.0 * cm, marginAll: 2.0 * cm);
//   static const PdfPageFormat a6 =
//   PdfPageFormat(105 * mm, 148 * mm, marginAll: 1.0 * cm);
//   static const PdfPageFormat letter =
//   PdfPageFormat(8.5 * inch, 11.0 * inch, marginAll: inch);
//   static const PdfPageFormat legal =
//   PdfPageFormat(8.5 * inch, 14.0 * inch, marginAll: inch);
//
//   static const PdfPageFormat roll57 =
//   PdfPageFormat(57 * mm, double.infinity, marginAll: 5 * mm);
//   static const PdfPageFormat roll80 =
//   PdfPageFormat(80 * mm, double.infinity, marginAll: 5 * mm);
//
//   static const PdfPageFormat undefined =
//   PdfPageFormat(double.infinity, double.infinity);
//
//   static const PdfPageFormat standard = a4;
//
//   static const double point = 1.0;
//   static const double inch = 72.0;
//   static const double cm = inch / 2.54;
//   static const double mm = inch / 25.4;
//
//   final double width;
//   final double height;
//
//   final double marginTop;
//   final double marginBottom;
//   final double marginLeft;
//   final double marginRight;
//
//   PdfPageFormat copyWith(
//       {double? width,
//         double? height,
//         double? marginTop,
//         double? marginBottom,
//         double? marginLeft,
//         double? marginRight}) {
//     return PdfPageFormat(width ?? this.width, height ?? this.height,
//         marginTop: marginTop ?? this.marginTop,
//         marginBottom: marginBottom ?? this.marginBottom,
//         marginLeft: marginLeft ?? this.marginLeft,
//         marginRight: marginRight ?? this.marginRight);
//   }
//
//   /// Total page dimensions
//   PdfPoint get dimension => PdfPoint(width, height);
//
//   /// Total page width excluding margins
//   double get availableWidth => width - marginLeft - marginRight;
//
//   /// Total page height excluding margins
//   double get availableHeight => height - marginTop - marginBottom;
//
//   /// Total page dimensions excluding margins
//   PdfPoint get availableDimension => PdfPoint(availableWidth, availableHeight);
//
//   PdfPageFormat get landscape =>
//       width >= height ? this : copyWith(width: height, height: width);
//
//   PdfPageFormat get portrait =>
//       height >= width ? this : copyWith(width: height, height: width);
//
//   PdfPageFormat applyMargin(
//       {required double left,
//         required double top,
//         required double right,
//         required double bottom}) =>
//       copyWith(
//         marginLeft: math.max(marginLeft, left),
//         marginTop: math.max(marginTop, top),
//         marginRight: math.max(marginRight, right),
//         marginBottom: math.max(marginBottom, bottom),
//       );
//
//   @override
//   String toString() {
//     return '$runtimeType ${width}x$height margins:$marginLeft, $marginTop, $marginRight, $marginBottom';
//   }
//
//   @override
//   bool operator ==(Object other) {
//     if (other is! PdfPageFormat) {
//       return false;
//     }
//
//     return other.width == width &&
//         other.height == height &&
//         other.marginLeft == marginLeft &&
//         other.marginTop == marginTop &&
//         other.marginRight == marginRight &&
//         other.marginBottom == marginBottom;
//   }
//
//   @override
//   int get hashCode => toString().hashCode;
// }
//
// /*
//  * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
//  *
//  * Licensed under the Apache License, Version 2.0 (the "License");
//  * you may not use this file except in compliance with the License.
//  * You may obtain a copy of the License at
//  *
//  *     http://www.apache.org/licenses/LICENSE-2.0
//  *
//  * Unless required by applicable law or agreed to in writing, software
//  * distributed under the License is distributed on an "AS IS" BASIS,
//  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  * See the License for the specific language governing permissions and
//  * limitations under the License.
//  */
//
//
// /// Represents a bitmap image
// class PdfRasterBase {
//   /// Create a bitmap image
//   const PdfRasterBase(
//       this.width,
//       this.height,
//       this.alpha,
//       this.pixels,
//       );
//
//   factory PdfRasterBase.fromImage(im.Image image) {
//     final data = image
//         .convert(format: im.Format.uint8, numChannels: 4, noAnimation: true)
//         .toUint8List();
//     return PdfRasterBase(image.width, image.height, true, data);
//   }
//
//   factory PdfRasterBase.fromPng(Uint8List png) {
//     final img = im.PngDecoder().decode(png)!;
//     return PdfRasterBase.fromImage(img);
//   }
//
//   static im.Image shadowRect(
//       double width,
//       double height,
//       double spreadRadius,
//       double blurRadius,
//       PdfColor color,
//       ) {
//     final shadow = im.Image(
//       width: (width + spreadRadius * 2).round(),
//       height: (height + spreadRadius * 2).round(),
//       format: im.Format.uint8,
//       numChannels: 4,
//     );
//
//     im.fillRect(
//       shadow,
//       x1: spreadRadius.round(),
//       y1: spreadRadius.round(),
//       x2: (spreadRadius + width).round(),
//       y2: (spreadRadius + height).round(),
//       color: im.ColorUint8(4)
//         ..r = color.red * 255
//         ..g = color.green * 255
//         ..b = color.blue * 255
//         ..a = color.alpha * 255,
//     );
//
//     return im.gaussianBlur(shadow, radius: blurRadius.round());
//   }
//
//   static im.Image shadowEllipse(
//       double width,
//       double height,
//       double spreadRadius,
//       double blurRadius,
//       PdfColor color,
//       ) {
//     final shadow = im.Image(
//       width: (width + spreadRadius * 2).round(),
//       height: (height + spreadRadius * 2).round(),
//       format: im.Format.uint8,
//       numChannels: 4,
//     );
//
//     im.fillCircle(
//       shadow,
//       x: (spreadRadius + width / 2).round(),
//       y: (spreadRadius + height / 2).round(),
//       radius: (width / 2).round(),
//       color: im.ColorUint8(4)
//         ..r = color.red * 255
//         ..g = color.green * 255
//         ..b = color.blue * 255
//         ..a = color.alpha * 255,
//     );
//
//     return im.gaussianBlur(shadow, radius: blurRadius.round());
//   }
//
//   /// The width of the image
//   final int width;
//
//   /// The height of the image
//   final int height;
//
//   /// The alpha channel is used
//   final bool alpha;
//
//   /// The raw RGBA pixels of the image
//   final Uint8List pixels;
//
//   @override
//   String toString() => 'Image ${width}x$height ${width * height * 4} bytes';
//
//   /// Convert to a PNG image
//   Future<Uint8List> toPng() async {
//     final img = asImage();
//     return im.PngEncoder().encode(img);
//   }
//
//   /// Returns the image as an [Image] object from the pub:image library
//   im.Image asImage() {
//     return im.Image.fromBytes(
//       width: width,
//       height: height,
//       bytes: pixels.buffer,
//       bytesOffset: pixels.offsetInBytes,
//       format: im.Format.uint8,
//       numChannels: 4,
//     );
//   }
// }
//
//
// @immutable
// class PdfPoint {
//   const PdfPoint(this.x, this.y);
//
//   final double x, y;
//
//   static const PdfPoint zero = PdfPoint(0.0, 0.0);
//
//   @override
//   String toString() => 'PdfPoint($x, $y)';
//
//   PdfPoint translate(double offsetX, double offsetY) =>
//       PdfPoint(x + offsetX, y + offsetY);
// }
//
//
// /*
//  * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
//  *
//  * Licensed under the Apache License, Version 2.0 (the "License");
//  * you may not use this file except in compliance with the License.
//  * You may obtain a copy of the License at
//  *
//  *     http://www.apache.org/licenses/LICENSE-2.0
//  *
//  * Unless required by applicable law or agreed to in writing, software
//  * distributed under the License is distributed on an "AS IS" BASIS,
//  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  * See the License for the specific language governing permissions and
//  * limitations under the License.
//  */
//
//
// /// Represents an RGB color
// class PdfColor {
//   /// Create a color with red, green, blue and alpha components
//   /// values between 0 and 1
//   const PdfColor(this.red, this.green, this.blue, [this.alpha = 1.0])
//       : assert(red >= 0 && red <= 1),
//         assert(green >= 0 && green <= 1),
//         assert(blue >= 0 && blue <= 1),
//         assert(alpha >= 0 && alpha <= 1);
//
//   /// Return a color with: 0xAARRGGBB
//   const PdfColor.fromInt(int color)
//       : red = (color >> 16 & 0xff) / 255.0,
//         green = (color >> 8 & 0xff) / 255.0,
//         blue = (color & 0xff) / 255.0,
//         alpha = (color >> 24 & 0xff) / 255.0;
//
//   /// Can parse colors in the form:
//   /// * #RRGGBBAA
//   /// * #RRGGBB
//   /// * #RGB
//   /// * RRGGBBAA
//   /// * RRGGBB
//   /// * RGB
//   factory PdfColor.fromHex(String color) {
//     if (color.startsWith('#')) {
//       color = color.substring(1);
//     }
//
//     double red;
//     double green;
//     double blue;
//     var alpha = 1.0;
//
//     if (color.length == 3) {
//       red = int.parse(color.substring(0, 1) * 2, radix: 16) / 255;
//       green = int.parse(color.substring(1, 2) * 2, radix: 16) / 255;
//       blue = int.parse(color.substring(2, 3) * 2, radix: 16) / 255;
//       return PdfColor(red, green, blue, alpha);
//     }
//
//     assert(color.length == 3 || color.length == 6 || color.length == 8);
//
//     red = int.parse(color.substring(0, 2), radix: 16) / 255;
//     green = int.parse(color.substring(2, 4), radix: 16) / 255;
//     blue = int.parse(color.substring(4, 6), radix: 16) / 255;
//
//     if (color.length == 8) {
//       alpha = int.parse(color.substring(6, 8), radix: 16) / 255;
//     }
//
//     return PdfColor(red, green, blue, alpha);
//   }
//
//   /// Load an RGB color from a RYB color
//   factory PdfColor.fromRYB(double red, double yellow, double blue,
//       [double alpha = 1.0]) {
//     assert(red >= 0 && red <= 1);
//     assert(yellow >= 0 && yellow <= 1);
//     assert(blue >= 0 && blue <= 1);
//     assert(alpha >= 0 && alpha <= 1);
//
//     const magic = <List<double>>[
//       <double>[1, 1, 1],
//       <double>[1, 1, 0],
//       <double>[1, 0, 0],
//       <double>[1, 0.5, 0],
//       <double>[0.163, 0.373, 0.6],
//       <double>[0.0, 0.66, 0.2],
//       <double>[0.5, 0.0, 0.5],
//       <double>[0.2, 0.094, 0.0]
//     ];
//
//     double cubicInt(double t, double A, double B) {
//       final weight = t * t * (3 - 2 * t);
//       return A + weight * (B - A);
//     }
//
//     double getRed(double iR, double iY, double iB) {
//       final x0 = cubicInt(iB, magic[0][0], magic[4][0]);
//       final x1 = cubicInt(iB, magic[1][0], magic[5][0]);
//       final x2 = cubicInt(iB, magic[2][0], magic[6][0]);
//       final x3 = cubicInt(iB, magic[3][0], magic[7][0]);
//       final y0 = cubicInt(iY, x0, x1);
//       final y1 = cubicInt(iY, x2, x3);
//       return cubicInt(iR, y0, y1);
//     }
//
//     double getGreen(double iR, double iY, double iB) {
//       final x0 = cubicInt(iB, magic[0][1], magic[4][1]);
//       final x1 = cubicInt(iB, magic[1][1], magic[5][1]);
//       final x2 = cubicInt(iB, magic[2][1], magic[6][1]);
//       final x3 = cubicInt(iB, magic[3][1], magic[7][1]);
//       final y0 = cubicInt(iY, x0, x1);
//       final y1 = cubicInt(iY, x2, x3);
//       return cubicInt(iR, y0, y1);
//     }
//
//     double getBlue(double iR, double iY, double iB) {
//       final x0 = cubicInt(iB, magic[0][2], magic[4][2]);
//       final x1 = cubicInt(iB, magic[1][2], magic[5][2]);
//       final x2 = cubicInt(iB, magic[2][2], magic[6][2]);
//       final x3 = cubicInt(iB, magic[3][2], magic[7][2]);
//       final y0 = cubicInt(iY, x0, x1);
//       final y1 = cubicInt(iY, x2, x3);
//       return cubicInt(iR, y0, y1);
//     }
//
//     final redValue = getRed(red, yellow, blue);
//     final greenValue = getGreen(red, yellow, blue);
//     final blueValue = getBlue(red, yellow, blue);
//     return PdfColor(redValue, greenValue, blueValue, alpha);
//   }
//
//   /// Opacity
//   final double alpha;
//
//   /// Red component
//   final double red;
//
//   /// Green component
//   final double green;
//
//   /// Blue component
//   final double blue;
//
//   /// Get the int32 representation of this color
//   int toInt() =>
//       ((((alpha * 255.0).round() & 0xff) << 24) |
//       (((red * 255.0).round() & 0xff) << 16) |
//       (((green * 255.0).round() & 0xff) << 8) |
//       (((blue * 255.0).round() & 0xff) << 0)) &
//       0xFFFFFFFF;
//
//   /// Get an Hexadecimal representation of this color
//   String toHex() {
//     final i = toInt();
//     final rgb = (i & 0xffffff).toRadixString(16).padLeft(6, '0');
//     final a = ((i & 0xff000000) >> 24).toRadixString(16).padLeft(2, '0');
//     return '#$rgb$a';
//   }
//
//   /// Convert this color to CMYK
//   PdfColorCmyk toCmyk() {
//     return PdfColorCmyk.fromRgb(red, green, blue, alpha);
//   }
//
//   /// Convert this color to HSV
//   PdfColorHsv toHsv() {
//     return PdfColorHsv.fromRgb(red, green, blue, alpha);
//   }
//
//   /// Convert this color to HSL
//   PdfColorHsl toHsl() {
//     return PdfColorHsl.fromRgb(red, green, blue, alpha);
//   }
//
//   static double _linearizeColorComponent(double component) {
//     if (component <= 0.03928) {
//       return component / 12.92;
//     }
//     return math.pow((component + 0.055) / 1.055, 2.4).toDouble();
//   }
//
//   /// Determines whether the given [PdfColor] is light.
//   bool get isLight => !isDark;
//
//   /// Determines whether the given [PdfColor] is dark.
//   bool get isDark {
//     final relativeLuminance = luminance;
//     const kThreshold = 0.15;
//     return (relativeLuminance + 0.05) * (relativeLuminance + 0.05) > kThreshold;
//   }
//
//   /// Get the luminance
//   double get luminance {
//     final R = _linearizeColorComponent(red);
//     final G = _linearizeColorComponent(green);
//     final B = _linearizeColorComponent(blue);
//     return 0.2126 * R + 0.7152 * G + 0.0722 * B;
//   }
//
//   /// Build a Material Color shade using the given [strength].
//   ///
//   /// To lighten a color, set the [strength] value to < .5
//   /// To darken a color, set the [strength] value to > .5
//   PdfColor shade(double strength) {
//     final ds = 1.5 - strength;
//     final hsl = toHsl();
//
//     return PdfColorHsl(
//         hsl.hue, hsl.saturation, (hsl.lightness * ds).clamp(0.0, 1.0));
//   }
//
//   /// Get a complementary color with hue shifted by -120°
//   PdfColor get complementary => toHsv().complementary;
//
//   /// Get some similar colors
//   List<PdfColor> get monochromatic => toHsv().monochromatic;
//
//   /// Returns a list of complementary colors
//   List<PdfColor> get splitcomplementary => toHsv().splitcomplementary;
//
//   /// Returns a list of tetradic colors
//   List<PdfColor> get tetradic => toHsv().tetradic;
//
//   /// Returns a list of triadic colors
//   List<PdfColor> get triadic => toHsv().triadic;
//
//   /// Returns a list of analagous colors
//   List<PdfColor> get analagous => toHsv().analagous;
//
//   /// Apply the color transparency by updating the color values according to a
//   /// background color.
//   PdfColor flatten({PdfColor background = const PdfColor(1, 1, 1)}) {
//     return PdfColor(
//       alpha * red + (1 - alpha) * background.red,
//       alpha * green + (1 - alpha) * background.green,
//       alpha * blue + (1 - alpha) * background.blue,
//       background.alpha,
//     );
//   }
//
//   @override
//   String toString() => '$runtimeType($red, $green, $blue, $alpha)';
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) {
//       return true;
//     }
//     if (other.runtimeType != runtimeType) {
//       return false;
//     }
//     return other is PdfColor &&
//         other.red == red &&
//         other.green == green &&
//         other.blue == blue &&
//         other.alpha == alpha;
//   }
//
//   @override
//   int get hashCode => toInt();
// }
//
// class PdfColorGrey extends PdfColor {
//   /// Create a grey color
//   const PdfColorGrey(double color, [double alpha = 1.0])
//       : super(color, color, color, alpha);
// }
//
// /// Represents an CMYK color
// class PdfColorCmyk extends PdfColor {
//   /// Creates a CMYK color
//   const PdfColorCmyk(this.cyan, this.magenta, this.yellow, this.black,
//       [double a = 1.0])
//       : super((1.0 - cyan) * (1.0 - black), (1.0 - magenta) * (1.0 - black),
//       (1.0 - yellow) * (1.0 - black), a);
//
//   /// Create a CMYK color from red ,green and blue components
//   const PdfColorCmyk.fromRgb(double r, double g, double b, [double a = 1.0])
//       : black = 1.0 - r > g
//       ? r
//       : g > b
//       ? r > g
//       ? r
//       : g
//       : b,
//         cyan = (1.0 -
//             r -
//             (1.0 - r > g
//                 ? r
//                 : g > b
//                 ? r > g
//                 ? r
//                 : g
//                 : b)) /
//             (1.0 -
//                 (1.0 - r > g
//                     ? r
//                     : g > b
//                     ? r > g
//                     ? r
//                     : g
//                     : b)),
//         magenta = (1.0 -
//             g -
//             (1.0 - r > g
//                 ? r
//                 : g > b
//                 ? r > g
//                 ? r
//                 : g
//                 : b)) /
//             (1.0 -
//                 (1.0 - r > g
//                     ? r
//                     : g > b
//                     ? r > g
//                     ? r
//                     : g
//                     : b)),
//         yellow = (1.0 -
//             b -
//             (1.0 - r > g
//                 ? r
//                 : g > b
//                 ? r > g
//                 ? r
//                 : g
//                 : b)) /
//             (1.0 -
//                 (1.0 - r > g
//                     ? r
//                     : g > b
//                     ? r > g
//                     ? r
//                     : g
//                     : b)),
//         super(r, g, b, a);
//
//   /// Cyan component
//   final double cyan;
//
//   /// Magenta component
//   final double magenta;
//
//   /// Yellow component
//   final double yellow;
//
//   /// Black component
//   final double black;
//
//   @override
//   PdfColorCmyk toCmyk() {
//     return this;
//   }
//
//   @override
//   String toString() => '$runtimeType($cyan, $magenta, $yellow, $black, $alpha)';
// }
//
// double _getHue(
//     double red, double green, double blue, double max, double delta) {
//   var hue = double.nan;
//   if (max == 0.0) {
//     hue = 0.0;
//   } else if (max == red) {
//     hue = 60.0 * (((green - blue) / delta) % 6);
//   } else if (max == green) {
//     hue = 60.0 * (((blue - red) / delta) + 2);
//   } else if (max == blue) {
//     hue = 60.0 * (((red - green) / delta) + 4);
//   }
//
//   /// Set hue to 0.0 when red == green == blue.
//   hue = hue.isNaN ? 0.0 : hue;
//   return hue;
// }
//
// /// Same as HSB, Cylindrical geometries with hue, their angular dimension,
// /// starting at the red primary at 0°, passing through the green primary
// /// at 120° and the blue primary at 240°, and then wrapping back to red at 360°
// class PdfColorHsv extends PdfColor {
//   /// Creates an HSV color
//   factory PdfColorHsv(double hue, double saturation, double value,
//       [double alpha = 1.0]) {
//     final chroma = saturation * value;
//     final secondary = chroma * (1.0 - (((hue / 60.0) % 2.0) - 1.0).abs());
//     final match = value - chroma;
//
//     double red;
//     double green;
//     double blue;
//     if (hue < 60.0) {
//       red = chroma;
//       green = secondary;
//       blue = 0.0;
//     } else if (hue < 120.0) {
//       red = secondary;
//       green = chroma;
//       blue = 0.0;
//     } else if (hue < 180.0) {
//       red = 0.0;
//       green = chroma;
//       blue = secondary;
//     } else if (hue < 240.0) {
//       red = 0.0;
//       green = secondary;
//       blue = chroma;
//     } else if (hue < 300.0) {
//       red = secondary;
//       green = 0.0;
//       blue = chroma;
//     } else {
//       red = chroma;
//       green = 0.0;
//       blue = secondary;
//     }
//
//     return PdfColorHsv._(hue, saturation, value, (red + match).clamp(0.0, 1.0),
//         (green + match).clamp(0.0, 1.0), (blue + match).clamp(0.0, 1.0), alpha);
//   }
//
//   const PdfColorHsv._(this.hue, this.saturation, this.value, double red,
//       double green, double blue, double alpha)
//       : assert(hue >= 0 && hue < 360),
//         assert(saturation >= 0 && saturation <= 1),
//         assert(value >= 0 && value <= 1),
//         super(red, green, blue, alpha);
//
//   /// Creates an HSV color from red, green, blue components
//   factory PdfColorHsv.fromRgb(double red, double green, double blue,
//       [double alpha = 1.0]) {
//     final max = math.max(red, math.max(green, blue));
//     final min = math.min(red, math.min(green, blue));
//     final delta = max - min;
//
//     final hue = _getHue(red, green, blue, max, delta);
//     final saturation = max == 0.0 ? 0.0 : delta / max;
//
//     return PdfColorHsv._(hue, saturation, max, red, green, blue, alpha);
//   }
//
//   /// Angular position the colorspace coordinate diagram in degrees from 0° to 360°
//   final double hue;
//
//   /// Saturation of the color
//   final double saturation;
//
//   /// Brightness
//   final double value;
//
//   @override
//   PdfColorHsv toHsv() {
//     return this;
//   }
//
//   /// Get a complementary color with hue shifted by -120°
//   @override
//   PdfColorHsv get complementary =>
//       PdfColorHsv((hue - 120) % 360, saturation, value, alpha);
//
//   /// Get a similar color
//   @override
//   List<PdfColorHsv> get monochromatic => <PdfColorHsv>[
//     PdfColorHsv(
//         hue,
//         (saturation > 0.5 ? saturation - 0.2 : saturation + 0.2)
//             .clamp(0, 1),
//         (value > 0.5 ? value - 0.1 : value + 0.1).clamp(0, 1)),
//     PdfColorHsv(
//         hue,
//         (saturation > 0.5 ? saturation - 0.4 : saturation + 0.4)
//             .clamp(0, 1),
//         (value > 0.5 ? value - 0.2 : value + 0.2).clamp(0, 1)),
//     PdfColorHsv(
//         hue,
//         (saturation > 0.5 ? saturation - 0.15 : saturation + 0.15)
//             .clamp(0, 1),
//         (value > 0.5 ? value - 0.05 : value + 0.05).clamp(0, 1))
//   ];
//
//   /// Get two complementary colors with hue shifted by -120°
//   @override
//   List<PdfColorHsv> get splitcomplementary => <PdfColorHsv>[
//     PdfColorHsv((hue - 150) % 360, saturation, value, alpha),
//     PdfColorHsv((hue - 180) % 360, saturation, value, alpha),
//   ];
//
//   @override
//   List<PdfColorHsv> get triadic => <PdfColorHsv>[
//     PdfColorHsv((hue + 80) % 360, saturation, value, alpha),
//     PdfColorHsv((hue - 120) % 360, saturation, value, alpha),
//   ];
//
//   @override
//   List<PdfColorHsv> get tetradic => <PdfColorHsv>[
//     PdfColorHsv((hue + 120) % 360, saturation, value, alpha),
//     PdfColorHsv((hue - 150) % 360, saturation, value, alpha),
//     PdfColorHsv((hue + 60) % 360, saturation, value, alpha),
//   ];
//
//   @override
//   List<PdfColorHsv> get analagous => <PdfColorHsv>[
//     PdfColorHsv((hue + 30) % 360, saturation, value, alpha),
//     PdfColorHsv((hue - 20) % 360, saturation, value, alpha),
//   ];
//
//   @override
//   String toString() => '$runtimeType($hue, $saturation, $value, $alpha)';
// }
//
// /// Represents an HSL color
// class PdfColorHsl extends PdfColor {
//   /// Creates an HSL color
//   factory PdfColorHsl(double hue, double saturation, double lightness,
//       [double alpha = 1.0]) {
//     final chroma = (1.0 - (2.0 * lightness - 1.0).abs()) * saturation;
//     final secondary = chroma * (1.0 - (((hue / 60.0) % 2.0) - 1.0).abs());
//     final match = lightness - chroma / 2.0;
//
//     double red;
//     double green;
//     double blue;
//     if (hue < 60.0) {
//       red = chroma;
//       green = secondary;
//       blue = 0.0;
//     } else if (hue < 120.0) {
//       red = secondary;
//       green = chroma;
//       blue = 0.0;
//     } else if (hue < 180.0) {
//       red = 0.0;
//       green = chroma;
//       blue = secondary;
//     } else if (hue < 240.0) {
//       red = 0.0;
//       green = secondary;
//       blue = chroma;
//     } else if (hue < 300.0) {
//       red = secondary;
//       green = 0.0;
//       blue = chroma;
//     } else {
//       red = chroma;
//       green = 0.0;
//       blue = secondary;
//     }
//     return PdfColorHsl._(
//         hue,
//         saturation,
//         lightness,
//         alpha,
//         (red + match).clamp(0.0, 1.0),
//         (green + match).clamp(0.0, 1.0),
//         (blue + match).clamp(0.0, 1.0));
//   }
//
//   const PdfColorHsl._(this.hue, this.saturation, this.lightness, double alpha,
//       double red, double green, double blue)
//       : assert(hue >= 0 && hue < 360),
//         assert(saturation >= 0 && saturation <= 1),
//         assert(lightness >= 0 && lightness <= 1),
//         super(red, green, blue, alpha);
//
//   /// Creates an HSL color from red, green, and blue components
//   factory PdfColorHsl.fromRgb(double red, double green, double blue,
//       [double alpha = 1.0]) {
//     final max = math.max(red, math.max(green, blue));
//     final min = math.min(red, math.min(green, blue));
//     final delta = max - min;
//
//     final hue = _getHue(red, green, blue, max, delta);
//     final lightness = (max + min) / 2.0;
//     // Saturation can exceed 1.0 with rounding errors, so clamp it.
//     final saturation = lightness == 1.0
//         ? 0.0
//         : (delta / (1.0 - (2.0 * lightness - 1.0).abs())).clamp(0.0, 1.0);
//     return PdfColorHsl._(hue, saturation, lightness, alpha, red, green, blue);
//   }
//
//   /// Hue component
//   final double hue;
//
//   /// Saturation component
//   final double saturation;
//
//   /// Lightness component
//   final double lightness;
//
//   @override
//   PdfColorHsl toHsl() {
//     return this;
//   }
//
//   @override
//   String toString() => '$runtimeType($hue, $saturation, $lightness, $alpha)';
// }

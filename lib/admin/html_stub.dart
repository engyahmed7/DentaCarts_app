// lib/admin/html_stub.dart
library html_stub;

import 'dart:async';

class File {
  File(List<dynamic> parts, [this.name = '', String? type]);

  /// اسم الملف (غير قابل للإلغاء حتى لا يسبب ?String تحذيرات)
  final String name;

  /// حجم افتراضي (لن يُستخدم على الموبايل)
  int get size => 0;
}

class FileReader {
  void readAsArrayBuffer(Object _) {}

  /// النتيجة بعد القراءة (لا تُستخدَم فعليًا على الموبايل)
  dynamic result;

  /// Stream أحداث التحميل – نُعيد Stream فارغًا كي يرضى المترجم
  Stream<void> get onLoad => Stream.empty();
  Stream<void> get onLoadEnd => Stream.empty();
}

class Blob {
  Blob(List<dynamic> parts, [String? type]);
}

class Url {
  static String createObjectUrl(Object _) => '';
  static String createObjectUrlFromBlob(Object _) => '';
  static void revokeObjectUrl(String _) {}
}

class AnchorElement {
  AnchorElement({String? href});
  String? href;
  String? target;

  /// الميثود المطلوبة من الكود في ManageProductsTable
  void setAttribute(String name, String value) {}

  void click() {}
}
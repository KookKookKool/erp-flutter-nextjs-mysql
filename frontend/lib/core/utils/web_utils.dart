import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

String getWebHostNonNull({int port = 3000}) {
  if (kIsWeb) {
    // บน web ให้ใช้ window.location.hostname
    // ต้อง import dart:html แบบ conditional
    // แต่ dart:html ใช้ได้เฉพาะบน web เท่านั้น
    // ดังนั้นใช้ dynamic import
    return 'http://' +
        (Uri.base.host.isNotEmpty ? Uri.base.host : 'localhost') +
        ':$port';
  } else {
    // บน mobile หรือ desktop
    return 'http://localhost:$port';
  }
}

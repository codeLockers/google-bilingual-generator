import 'package:google_bilingual_annotations/google_bilingual_annotations.dart';
import 'package:flutter/material.dart';

import 'en_us.dart';

// ignore_for_file: camel_case_types
@GoogleBilingual(['./lib'], 'zh_Hans', GOOGLE_SHEET_CREDENTIAL)
const Locale zh = Locale('zh', 'Hans');

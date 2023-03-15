import 'dart:io';
import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:google_bilingual_annotations/google_bilingual_annotations.dart';
import 'package:google_bilingual_generator/src/google_apis.dart';
import 'package:google_bilingual_generator/src/google_bilingual_visitor.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:path/path.dart' as p;
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';

class GoogleBilingualGenerator extends GeneratorForAnnotation<GoogleBilingual> {
  late Future<List<TranslationItem>> _remoteTranslationSteam;
  late Future<List<TranslationItem>> _localTranslationsSteam;

  List<TranslationItem> _remoteTranslations = [];
  List<TranslationItem> _localTranslations = [];

  bool hasFetched = false;
  bool hasAppended = false;
  bool hasDeleted = false;

  late GoogleSheet _googleSheet;

  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    ConstantReader paths = annotation.read('paths');
    ConstantReader credential = annotation.read('credential');
    if (!paths.isList || !credential.isMap) {
      return null;
    }
    _googleSheet = GoogleSheet(GoogleCredential.fromJson(credential.mapValue
        .map((key, value) => MapEntry<String?, String?>(
            key?.toStringValue(), value?.toStringValue()))));
    if (!hasFetched) {
      hasFetched = true;
      _remoteTranslationSteam = _googleSheet.getAllTranslations();
      _localTranslationsSteam = _fetchLocalTranslations(paths.listValue);
    }
    _remoteTranslations = await _remoteTranslationSteam;
    _localTranslations = await _localTranslationsSteam;
    StringBuffer potBuffer = StringBuffer();
    potBuffer.writeln('msgid ""');
    potBuffer.writeln('msgstr ""');
    potBuffer.writeln('"Language: ${element.displayName}\\n"');
    potBuffer.writeln('"Content-Type: text/plain; charset=utf-8\\n"');
    potBuffer.writeln('');

    //local
    for (var local in _localTranslations) {
      if (local.msgid.isEmpty) {
        continue;
      }
      if (local.msgctxt.isNotEmpty) {
        potBuffer.writeln('msgctxt ${local.msgctxt}');
      }
      potBuffer.writeln('msgid ${local.msgid}');
      potBuffer.writeln(
          'msgstr "${_getValue(local, element.displayName)}"'); //set value
      potBuffer.writeln('');
    }

    if (!hasAppended) {
      hasAppended = true;
      List<TranslationItem> appendItems = await _findAppendTranslation();
      //append new copies to google sheet
      await _googleSheet.append(appendItems);
    }

    if (!hasDeleted) {
      hasDeleted = true;
      List<int> unuseRows = await _findUnusedTranslations();
      await _googleSheet.delete(unuseRows);
    }

    return potBuffer.toString();
  }
}

extension GoogleableGeneratorExtension on GoogleBilingualGenerator {
  List<TranslationItem> _parseFile(String path) {
    String content = File(path).readAsStringSync();
    ParseStringResult result = parseString(content: content);
    CompilationUnit unit = result.unit;
    GoogleBilingualVisitor visitor = GoogleBilingualVisitor(unit, path);
    unit.visitChildren(visitor);
    return visitor.items;
  }

  Future<List<TranslationItem>> _fetchLocalTranslations(
      List<DartObject> paths) {
    List<TranslationItem> items = [];
    paths.map((e) => e.toStringValue()).forEach((element) {
      Directory dir = Directory(element ?? "");
      dir.listSync(recursive: true).forEach((f) {
        if (f.statSync().type == FileSystemEntityType.file &&
            p.extension(f.path) == '.dart') {
          List<TranslationItem> copies = _parseFile(f.path);
          items.addAll(copies);
        }
      });
    });
    //group by same msgid && msgctxt
    Map<String, List<TranslationItem>> localTranslationGroups = {};
    for (var lt in items) {
      String key = '${lt.msgid}_${lt.msgctxt}';
      List<TranslationItem> items = localTranslationGroups[key] ?? [];
      items.add(lt);
      localTranslationGroups[key] = items;
    }

    List<TranslationItem> localTranslations = localTranslationGroups
        .map(
            (key, value) => MapEntry<String, TranslationItem>(key, value.first))
        .entries
        .map((e) => e.value)
        .toList();

    return Future<List<TranslationItem>>.value(localTranslations);
  }

  TranslationItem? _findTranslationFromRemote(TranslationItem matchLocal) {
    return _remoteTranslations.firstWhereOrNull((remote) {
      return remote.formatMsgid() == matchLocal.msgid &&
          remote.formatMsgctxt() == matchLocal.msgctxt;
    });
  }

  Future<List<TranslationItem>> _findAppendTranslation() {
    //find new copies
    List<TranslationItem> appendItems = [];
    for (var local in _localTranslations) {
      TranslationItem? item = _remoteTranslations.firstWhereOrNull((remote) {
        return remote.formatMsgid() == local.msgid &&
            remote.formatMsgctxt() == local.msgctxt;
      });

      if (item == null) {
        appendItems.add(local);
      }
    }
    return Future.value(appendItems);
  }

  Future<List<int>> _findUnusedTranslations() {
    List<int> unusedIndex = [];
    for (var remote in _remoteTranslations.asMap().entries.toList()) {
      if (remote.value.msgid.isEmpty &&
          remote.value.msgctxt.isEmpty &&
          remote.value.zh.isEmpty &&
          remote.value.en.isEmpty) {
        unusedIndex.add(remote.key);
        continue;
      }
      TranslationItem? item = _localTranslations.firstWhereOrNull((local) {
        return remote.value.formatMsgid() == local.msgid &&
            remote.value.formatMsgctxt() == local.msgctxt;
      });
      if (item == null) {
        unusedIndex.add(remote.key);
      }
    }
    return Future.value(unusedIndex);
  }

  String _getValue(TranslationItem local, String language) {
    TranslationItem? remote = _findTranslationFromRemote(local);
    if (language.startsWith('zh')) {
      return remote?.zh ?? '';
    } else if (language.startsWith('en')) {
      return remote?.en ?? '';
    } else {
      return '';
    }
  }
}

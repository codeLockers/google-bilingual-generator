import 'package:google_bilingual_generator/src/google_apis.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class GoogleBilingualVisitor extends GeneralizingAstVisitor {
  String file;
  CompilationUnit unit;
  List<TranslationItem> items = [];
  GoogleBilingualVisitor(this.unit, this.file);

  @override
  visitNode(AstNode node) {
    final childEntities = node.childEntities.toList();
    if (childEntities.length > 3 &&
        childEntities.first.toString() == 'context' &&
        childEntities[1].toString() == '.' &&
        childEntities[2].toString() == 't') {
      GoogleBilingualItemVisitor itemVisitor = GoogleBilingualItemVisitor();
      node.visitChildren(itemVisitor);
      items.add(itemVisitor.item);
    }
    return super.visitNode(node);
  }
}

class GoogleBilingualItemVisitor extends GeneralizingAstVisitor {
  AstNode? _previousNode;
  TranslationItem item = TranslationItem('', '', '', '');

  @override
  visitNode(AstNode node) {
    if (_previousNode?.beginToken.toString() == '(' &&
        _previousNode?.endToken.toString() == ')' &&
        node.beginToken.toString() == node.endToken.toString()) {
      //key node
      item.msgid = node.beginToken.toString();
    }
    if (_previousNode?.beginToken.toString() == 'msgctxt' &&
        _previousNode?.endToken.toString() == 'msgctxt' &&
        (_previousNode?.childEntities.length ?? 0) > 0 &&
        _previousNode?.childEntities.first.toString() == 'msgctxt' &&
        node.beginToken.toString() == node.endToken.toString()) {
      //msgctxt node
      item.msgctxt = node.beginToken.toString();
    }
    _previousNode = node;
    return super.visitNode(node);
  }
}

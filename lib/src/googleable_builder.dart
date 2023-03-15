import 'package:build/build.dart';
import 'package:google_bilingual_generator/src/googleable_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder googleable(BuilderOptions options) =>
    LibraryBuilder(GoogleBilingualGenerator(), generatedExtension: '.po',
        formatOutput: (code) {
      String remove =
          "// **************************************************************************\n// GoogleBilingualGenerator\n// **************************************************************************\n";
      return code.replaceFirst(remove, "");
    }, header: "", allowSyntaxErrors: false);

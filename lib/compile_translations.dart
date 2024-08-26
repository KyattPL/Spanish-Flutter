import 'dart:io';
import 'dart:convert';

const String INPUT_DIRECTORY = '../assets/translations'; // Adjust this path as needed
const String OUTPUT_FILE = '../assets/tests_json.json';
const String SEPARATOR = '|'; // Adjust this to your chosen separator

void main() async {
  final directory = Directory(INPUT_DIRECTORY);
  final translations = await processTextFiles(directory);

  final outputFile = File(OUTPUT_FILE);
  await outputFile.writeAsString(jsonEncode(translations));

  print('Translation compilation complete. Output saved to $OUTPUT_FILE');
}

Future<Map<String, dynamic>> processTextFiles(Directory directory) async {
  final translations = <String, dynamic>{};

  await for (final file in directory.list(recursive: true, followLinks: false)) {
    if (file is File && file.path.endsWith('.txt')) {
      final filename = file.uri.pathSegments.last.replaceAll('.txt', '');
      final fileTranslations = await parseTextFile(file, filename);
      translations.addAll(fileTranslations);
    }
  }

  return translations;
}

Future<Map<String, dynamic>> parseTextFile(File file, String filename) async {
  final translations = <String, dynamic>{};
  final lines = await file.readAsLines();

  int partCounter = 1;
  List<Map<String, dynamic>> currentPart = [];

  for (final line in lines) {
    if (line.trim().isEmpty) {
      if (currentPart.isNotEmpty) {
        translations['${filename}_part$partCounter'] = {'data': currentPart};
        partCounter++;
        currentPart = [];
      }
    } else {
      final parts = line.split(SEPARATOR);
      if (parts.length == 2) {
        final esp = parts[0].trim();
        final eng = parts[1].trim();
        currentPart.add({'eng': eng, 'esp': esp, 'in_learning': true});
      }
    }
  }

  // Add the last part if it's not empty
  if (currentPart.isNotEmpty) {
    translations['${filename}_part$partCounter'] = {'data': currentPart};
  }

  return translations;
}
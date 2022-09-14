import 'dart:io';

// packages
import 'package:path/path.dart' as pathlib;

// local

import 'exception.dart';
import 'sorting.dart';

// returns [File] or [Directory]
/// * argument objects = [File] or [Directory]
/// * argument by [String]: 'date', 'alpha', 'size'
List<dynamic> sortBy(List<dynamic> objects, FlutterFileUtilsSorting by, {bool reversed: false}) {
  switch (by) {
    case FlutterFileUtilsSorting.Alpha:
      objects.sort((a, b) => getBaseName(a.path).compareTo(getBaseName(b.path)));
      break;

    case FlutterFileUtilsSorting.Date:
      objects.sort((a, b) {
        return a.statSync().modified.millisecondsSinceEpoch.compareTo(b.statSync().modified.millisecondsSinceEpoch);
      });
      break;

    case FlutterFileUtilsSorting.Size:
      objects.sort((a, b) {
        return a.statSync().size.compareTo(b.statSync().size);
      });
      break;

    case FlutterFileUtilsSorting.Type:
      objects.sort((a, b) {
        return pathlib.extension(a.path).compareTo(pathlib.extension(b.path));
      });

      break;
    default:
      objects.sort((a, b) => getBaseName(a.path).compareTo(getBaseName(b.path)));
  }
  if (reversed == true) {
    return objects.reversed.toList();
  }
  return objects;
}

/// Return the name of the file or the folder
/// i.e: /root/home/myfile.zip = myfile.zip
/// [extension]: with extension [true] or not [false], [true]
/// by default
String getBaseName(String path, {bool extension: true}) {
  if (extension) {
    return pathlib.split(path).last;
  } else {
    return pathlib.split(path).last.split(new RegExp(r'\.\w+'))[0];
  }
}

Future<List<File>> listFiles(String path, {List<String> extensions, followsLinks = false, excludeHidden = false, FlutterFileUtilsSorting sortedBy, bool reversed: false}) async {
  List<File> files = [];

  try {
    List contents = Directory(path).listSync(followLinks: followsLinks, recursive: false);
    if (extensions != null) {
      // Future<List<String>> extensionsPatterns =
      //     RegexTools.makeExtensionPatterns(extensions);
      for (var fileOrDir in contents) {
        if (fileOrDir is File) {
          String file = pathlib.normalize(fileOrDir.path);
          for (var extension in extensions) {
            if (pathlib.extension(file).replaceFirst(".", "") == extension.replaceFirst('.', '')) {
              if (excludeHidden) {
                if (file.startsWith('.')) files.add(File(pathlib.normalize(fileOrDir.absolute.path)));
              } else {
                files.add(File(pathlib.normalize(fileOrDir.absolute.path)));
              }
            }
          }
        }
      }
    } else {
      for (var fileOrDir in contents) {
        if (fileOrDir is File) {
          files.add(File(pathlib.normalize(fileOrDir.absolute.path)));
        }
      }
    }
  } catch (error) {
    throw FileManagerError(error.toString());
  }
  if (files != null) {
    return sortBy(files, sortedBy, reversed: reversed);
  }

  return files;
}

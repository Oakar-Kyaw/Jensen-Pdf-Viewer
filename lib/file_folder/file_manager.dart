import 'dart:async';
import 'dart:io';

// packages
import 'package:path/path.dart' as p;

// local files
import 'exception.dart';
import 'sorting.dart';

import 'file_system_utils.dart';

class FileManager {
  // The start point .
  Directory root;

  FileManager({this.root});

  /// * This function returns a [List] of [int howMany] of type [File] of recently created files.
  /// * [excludeHidded] if [true] hidden files will not be returned
  /// * sortedBy: [Sorting]
  /// * [bool] reversed: in case parameter sortedBy is used

  /// Return list tree of directories.
  /// You may exclude some directories from the list.
  /// * [excludedPaths] will excluded paths and their subpaths from the final [list]
  /// * sortedBy: [FlutterFileUtilsSorting]
  /// * [bool] reversed: in case parameter sortedBy is used
  Future<List<Directory>> dirsTree({List<String> excludedPaths, bool followLinks: false, bool excludeHidden: false, FlutterFileUtilsSorting sortedBy}) async {
    List<Directory> dirs = [];

    try {
      var contents = root.listSync(recursive: true, followLinks: followLinks);
      if (excludedPaths != null) {
        for (var fileOrDir in contents) {
          if (fileOrDir is Directory) {
            for (var excludedPath in excludedPaths) {
              if (!p.isWithin(excludedPath, p.normalize(fileOrDir.path))) {
                if (!excludeHidden) {
                  dirs.add(Directory(p.normalize(fileOrDir.absolute.path)));
                } else {
                  if (!fileOrDir.absolute.path.contains(RegExp(r"\.[\w]+"))) {
                    dirs.add(Directory(p.normalize(fileOrDir.absolute.path)));
                  }
                }
              }
            }
          }
        }
      } else {
        for (var fileOrDir in contents) {
          if (fileOrDir is Directory) {
            if (!excludeHidden) {
              dirs.add(Directory(p.normalize(fileOrDir.absolute.path)));
            } else {
              // The Regex below is used to check if the directory contains
              // ".file" in pathe
              if (!fileOrDir.absolute.path.contains(RegExp(r"\.[\w]+"))) {
                dirs.add(Directory(p.normalize(fileOrDir.absolute.path)));
              }
            }
          }
        }
      }
    } catch (error) {
      throw FileManagerError(error.toString());
    }
    if (dirs != null) {
      return sortBy(dirs, sortedBy);
    }

    return dirs;
  }

  /// Return tree [List] of files starting from the root of type [File]
  /// * [excludedPaths] example: '/storage/emulated/0/Android' no files will be
  ///   returned from this path, and its sub directories
  /// * sortedBy: [Sorting]
  /// * [bool] reversed: in case parameter sortedBy is used
  Future<List<File>> filesTree({List<String> extensions, List<String> excludedPaths, excludeHidden = false, bool reversed: false, FlutterFileUtilsSorting sortedBy}) async {
    List<File> files = [];

    List<Directory> dirs = await dirsTree(excludedPaths: excludedPaths, excludeHidden: excludeHidden);

    dirs.insert(0, Directory(root.path));

    if (extensions != null) {
      for (var dir in dirs) {
        for (var file in await listFiles(dir.absolute.path, extensions: extensions)) {
          if (excludeHidden) {
            if (!file.path.startsWith("."))
              files.add(file);
            else
              print("Excluded: ${file.path}");
          } else {
            files.add(file);
          }
        }
      }
    } else {
      for (var dir in dirs) {
        for (var file in await listFiles(dir.absolute.path)) {
          if (excludeHidden) {
            if (!file.path.startsWith("."))
              files.add(file);
            else
              print("Excluded: ${file.path}");
          } else {
            files.add(file);
          }
        }
      }
    }

    if (sortedBy != null) {
      return sortBy(files, sortedBy);
    }

    return files;
  }

  /// Return tree [List] of files starting from the root of type [File].
  ///
  /// This function uses filter

  /// Returns a list of found items of [Directory] or [File] type or empty list.
  /// You may supply `Regular Expression` e.g: "*\.png", instead of string.
  /// * [filesOnly] if set to [true] return only files
  /// * [dirsOnly] if set to [true] return only directories
  /// * You can set both to [true]
  /// * sortedBy: [Sorting]
  /// * [bool] reversed: in case parameter sortedBy is used
  /// * Example:
  /// * List<String> imagesPaths = await FileManager.search("myFile.png");

  /// Returns a list of found items of [Directory] or [File] type or empty list.
  /// You may supply `Regular Expression` e.g: "*\.png", instead of string.
  /// * [filesOnly] if set to [true] return only files
  /// * [dirsOnly] if set to [true] return only directories
  /// * You can set both to [true]
  /// * sortedBy: [FlutterFileUtilsSorting]
  /// * [bool] reverse: in case parameter sortedBy is used
  /// * Example:
  /// * `List<String> imagesPaths = await FileManager.search("myFile.png").toList();`

}

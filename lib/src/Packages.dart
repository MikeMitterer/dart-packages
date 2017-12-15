part of packages;

/*
 * Copyright (c) 2016, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


/// Resolves packages-Names
class Packages {
    static const String _FILENAME = ".packages";

    final File packagesFile = new File(_FILENAME);
    final Map<String,String> _packages = new Map<String,String>();

    Package resolvePackageUri(final Uri uri) {
        if(_packages.isEmpty && hasPackages) {
            _readPackagesFile();
        }

        if(uri.scheme != "package") {
            throw new ArgumentError("This is not a valid package-URI! Scheme must be 'package' but was '${uri.scheme}'");
        }

        if(uri.path == null || uri.path.isEmpty) {
            throw new ArgumentError("Invalid package path! (${uri})");
        }

        // First path element ist the packagename
        final String packagename = path.split(uri.path)[0].trim();

        if(packagename.startsWith(r"\W")) {
            throw new ArgumentError("Invalid packagename: ($packagename)!");
        }

        if(!_packages.containsKey(packagename)) {
            throw new RangeError("Could not find $packagename in your .packages-File");
        }

        return new Package(uri,packagename,Uri.parse(path.normalize(_packages[packagename])));
    }

    /// Returns all packages in .packages-File
    List<Package> get all {
        if(_packages.isEmpty && packagesFile.existsSync()) {
            _readPackagesFile();
        }
        final List<Package> packages = new List<Package>();
        _packages.keys.forEach((final String packagename) {
            packages.add(resolvePackageUri(Uri.parse("package:$packagename")));
        });
        return packages;
    }

    /// Returns packages (global + local) with a path to the local filesystem
    Future<List<PackageWithPath>> get withPath async {
        final List<PackageWithPath> packages = new List<PackageWithPath>();
        all.forEach((final Package package)
            => packages.add(new PackageWithPath(package.packagename, package.root.toFilePath())));

        (await globals).where((final GlobalPackage package) => package.hasPath)
            .forEach((final GlobalPackage package){
                final temp = new PackageWithPath(package.packagename, package.path.value);
                if(!packages.contains(temp)) {
                    packages.add(temp);
                }
        });
        return packages;
    }


    /// All packages activated via "pub global activate"
    Future<List<GlobalPackage>> get globals async {
        final packages = await _readGlobalPackages();
        final globalPackages = new List<GlobalPackage>();

        packages.forEach((final String line) {
            final List<String> segments = line.split(" ");
            // 2 Segments = hosted package (~/.pub-cache/hosted/pub.dartlang.org)
            // e.g. sass 1.0.0-alpha.9
            if(segments.length == 2) {
                final String name = segments[0];
                final String version = segments[1];

                // Maybe we can resolve the packagename
                try {
                    final Package package = resolvePackageUri(Uri.parse("package:${name}"));
                    globalPackages.add(new GlobalPackage(name, version, package.root.toFilePath()));

                } catch(_) {
                    globalPackages.add(new GlobalPackage(name, version));
                }
            }
            // More segments = Local activated Package
            // e.g. l10n 0.18.0 at path "/Volumes/Daten/DevLocal/DevDart/L10N4Dart"
            else if(segments.length == 5) {
                globalPackages.add(
                    new GlobalPackage(segments[0], segments[1], segments[4].replaceAll('"', "")));
            }
        });

        return globalPackages;
    }

    /// Returns true if .packages-File is available
    bool get hasPackages {
        return packagesFile.existsSync();
    }

    //- private --------------------------------------------------------------------------------------------------------

    /// Reads the lines from a .packages file
    ///
    /// Format:
    ///     bignum:file:///Users/mikemitterer/.pub-cache/hosted/pub.dartlang.org/bignum-0.1.0/lib/
    ///     mobiad_rest_ui_mdl:../../lib/
    void _readPackagesFile() {
        final List<String> lines = packagesFile.readAsLinesSync();

        _packages.clear();
        lines.where((final String line) => line.contains(":") && !line.trim().startsWith("#"))
            .forEach((final String line) {

            final int index  = line.indexOf(":");
            final String package = line.substring(0,index);         // e.g. bignum or mobiad_rest_ui_mdl
            final String packagePath = line.substring(index + 1);   // e.g. ../../lib/

            _packages[package] = packagePath;
        } );
    }

    
    /// Reads all the "pub global" activated packages
    Future<List<String>> _readGlobalPackages() async {
        final ProcessResult result = await Process.run("pub", [ "global", "list" ]);
        if (result.exitCode != 0) {
            throw new ArgumentError("'pub global list' faild with: ${(result.stderr as String).trim()}!");
        }
        return result.stdout.toString().split("\n");
    }
}

/// Shared class between [Package] and [GlobalPackage]
abstract class PackageBase {
    /// The packagename defined in pubspec.yaml
    final String packagename;

    PackageBase(this.packagename);
}

/// Some of the global packages dont have a path
class PackageWithPath extends PackageBase {
    final String path;

    PackageWithPath(final String packagename, this.path) : super(packagename);

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
            other is PackageWithPath &&
                runtimeType == other.runtimeType &&
                path == other.path;

    @override
    int get hashCode => packagename.hashCode;
}

/// Details about the requested package
class Package extends PackageBase {

    /// The basis for the request
    ///
    /// e.g. package:foo/bar.txt
    final Uri _base;

    /// Absolute path to package
    ///
    /// Can be a relative path like "../../lib" or can start with "file:///..."
    /// "lib" for the requesting library/package
    ///
    /// E.g. if the "packages" library ask for "lib" it returns "lib"
    final Uri lib;

    Package(this._base, final String packagename, this.lib) : super(packagename);

    /// Uri to localhost
    Future<Uri> get resource {
        return Isolate.resolvePackageUri(_base);
    }

    /// Full path to uri
    Uri get uri {
        return Uri.parse(path.normalize("${lib}${_base.path.replaceFirst(packagename,"")}"));
    }

    /// Package-root (without /lib at the end)
    ///
    /// The returned [Uri] always starts with "file://"
    /// Returns ALWAYS the full path to the package-root
    Uri get root {
        String packageRoot = lib.toString().replaceFirst(new RegExp(r"/lib$"),"");

        // "lib" indicates that
        // it refers to the package requesting this information
        if(packageRoot == "lib") {
            packageRoot = path.current;
        }
        if(!packageRoot.startsWith("file://")) {
            packageRoot = "file://${packageRoot}";
        }
        return Uri.parse(packageRoot);
    }
}

class GlobalPackage extends PackageBase {
    final String version;
    final Optional<String> path;

    GlobalPackage(final String packagename, this.version, [ final String path ])
        : this.path = new Optional.ofNullable(path), super(packagename);

    bool get hasPath => path.isPresent;

}
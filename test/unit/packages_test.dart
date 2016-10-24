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

library packages.test;

import 'package:test/test.dart';
import 'package:packages/packages.dart';

main() {
    final Packages packages = new Packages();
    final String myLocalPathToGrinder = "/Users/mikemitterer/.pub-cache/hosted/pub.dartlang.org/grinder-";

    test('> Packagename', () {
        final Package package = packages.resolvePackageUri(Uri.parse("package:grinder"));
        expect(package.packagename, "grinder");
    }); // end of 'Packagename' test

    test('> Lib-Path', () {
        final Package package = packages.resolvePackageUri(Uri.parse("package:grinder"));
        final String grinder = package.lib.path.toString();

        expect(grinder.startsWith(myLocalPathToGrinder), isTrue);
        expect(package.lib.path.endsWith("lib"), isTrue);

    }); // end of 'Test path' test

    test('> Package for this package (should be lib);', () {
        final Package package = packages.resolvePackageUri(Uri.parse("package:packages"));
        expect(package.lib.toString(),"lib");
    }); // end of 'Package for this package (should be lib)' test

    test('> Uri', () {
        final Package package = packages.resolvePackageUri(Uri.parse("package:grinder/src/ansi.dart"));
        expect(package.packagename, "grinder");
        expect(package.uri.path.startsWith(myLocalPathToGrinder), isTrue);
        expect(package.uri.path.endsWith("/src/ansi.dart"), isTrue);
    }); // end of 'Uri' test

//    test('> Resource', () async {
//        final Package package = packages.resolvePackageUri(Uri.parse("package:grinder/src/ansi.dart"));
//        final Uri uri = await package.resource;
//        print(uri);
//
//    }); // end of 'Resource' test

    test('> Root', () {
        final Package package = packages.resolvePackageUri(Uri.parse("package:grinder"));
        final String purePackageWithoutVersion = package.root.toString().replaceFirst(
            new RegExp(r"grinder-[0-9.+]*$"),"grinder");

        expect(purePackageWithoutVersion.endsWith("grinder"), isTrue);
    }); // end of 'Root' test

    test('> Root for current package', () {
        final Package package = packages.resolvePackageUri(Uri.parse("package:packages"));

        // Path to local Packages-Folder: '/Volumes/Daten/DevLocal/DevDart/Packages'
        expect(package.root.toString().endsWith("/Packages"), isTrue);

    }); // end of 'Root for current package' test

    test('> Path to local lib', () {
        final Package packageForThisLib = packages.resolvePackageUri(Uri.parse("package:packages"));
        expect(packageForThisLib.lib.path,"lib");
    }); // end of 'Path to local lib' test

    test('> Wrong package scheme', () {
        expect(() => packages.resolvePackageUri(Uri.parse("file://grinder")), throwsArgumentError);
    }); // end of 'Wrong package scheme' test

    test('> Empty path', () {
        expect(() => packages.resolvePackageUri(Uri.parse("package:")), throwsArgumentError);
    }); // end of 'Empty path' test

    test('> Wrong path', () {
        expect(() => packages.resolvePackageUri(Uri.parse("package:/mdl/abc.txt")), throwsArgumentError);
    }); // end of 'Wrong path' test

    test('> Package is not available', () {
        expect(() => packages.resolvePackageUri(Uri.parse("package:abc/hallo.txt")), throwsRangeError);
    }); // end of 'Package is not available' test

}

// @TestOn("browser")
// unit
library test.unit.globals;

import 'package:test/test.dart';
import 'package:packages/packages.dart';

main() async {
    //final Logger _logger = new Logger("test.unit.globals");
    //configLogging(show: Level.INFO);

    final Packages packages = new MockedPackages();

    group('Global Packages', () {
        setUp(() {});

        test('> list', () async {
            final globals = await packages.globals;
            expect(globals.length, 15);
        }); // end of 'pub global' test

        test('> local packages', () async {
            final globals = await packages.globals;
            final localPackages = globals.where((final GlobalPackage package) => package.hasPath);

            // We have at least 9 global packages but maybe one of
            // them is in the local .packages file
            expect(localPackages.length, greaterThanOrEqualTo(9));

            // They all start with a /
            expect(localPackages.where(
                    (final GlobalPackage package) => package.path.value.startsWith("/")).length,
                        greaterThanOrEqualTo(9));

        }); // end of 'local packages' test

        test('> Versions', () async {
            final globals = await packages.globals;

            // They all start with a digit
            expect(globals.where(
                    (final GlobalPackage package) 
                        => package.version.startsWith(new RegExp(r"\d"))).length, equals(15));
        }); // end of 'Versions' test


    });
    // End of 'simple' group
}

// - Helper --------------------------------------------------------------------------------------

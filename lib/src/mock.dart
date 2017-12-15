part of packages;

/// Only for testing
class MockedPackages extends Packages {

    @override
    Future<List<String>> _readGlobalPackages() {
        return new Future(() {
            return <String>[
                'buildsamples 0.0.1 at path "/Volumes/Daten/DevLocal/DevDart/BuildSamples"',
                'changelog 1.4.2 at path "/Volumes/Daten/DevLocal/DevDart/Changelog"',
                'dart_style 0.2.4',
                'dasic 1.1.0 at path "/Volumes/Daten/DevLocal/DevDart/Dasic"',
                'dependency_validator 1.0.0',
                'fcm_push 1.0.0 at path "/Volumes/Daten/DevLocal/DevDart/fcm-push"',
                'git_version 0.1.7 at path "/Volumes/Daten/DevLocal/DevDart/GitVersion"',
                'grinder 0.8.0+2',
                'l10n 0.18.0 at path "/Volumes/Daten/DevLocal/DevDart/L10N4Dart"',
                'packages 0.1.9 at path "/Volumes/Daten/DevLocal/DevDart/Packages"',
                'pub_mediator 1.0.1',
                'sass 1.0.0-alpha.9',
                'sitegen 1.3.2 at path "/Volumes/Daten/DevLocal/DevDart/SiteGen"',
                'stagedive 0.5.0 at path "/Volumes/Daten/DevLocal/DevDart/StageDive"',
                'stagehand 1.1.6'
            ];
        });
    }
}
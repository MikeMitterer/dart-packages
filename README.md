# Packages
> Resolves a package name to its path on your HD  

### Use as library

```
    final Package package = packages.resolvePackageUri(Uri.parse("package:grinder"));

    print(package.packagename); 
    // grinder
    
    print(package.lib.path); 
    // file:///Users/mikemitterer/.pub-cache/hosted/pub.dartlang.org/grinder-0.8.0+3/lib;
    
    print(package.uri.path); 
    // file:///Users/mikemitterer/.pub-cache/hosted/pub.dartlang.org/grinder-0.8.0+3/lib;    

    final Uri resource = await package.resource;
    print(resource); 
    // http://localhost:62232/packages/grinder
        
```

or if you want a specific file in a package

```
    final Package package = packages.resolvePackageUri(Uri.parse("package:grinder/src/ansi.dart"));

    print(package.packagename); 
    // grinder
    
    print(package.lib.path); 
    // file:///Users/mikemitterer/.pub-cache/hosted/pub.dartlang.org/grinder-0.8.0+3/lib;
    
    print(package.uri.path); 
    // file:///Users/mikemitterer/.pub-cache/hosted/pub.dartlang.org/grinder-0.8.0+3/lib/src/ansi.dart;    

    final Uri resource = await package.resource;
    print(resource); 
    // http://localhost:62232/packages/grinder/src/ansi.dart    
```

### Use as cmdline application

```bash

Usage: packages [options] <packagename>
    -h, --[no-]help       Shows this help information
    -l, --[no-]list       Lists all packages
    -v, --[no-]verbose    More package details

```

##### Sample output:
```bash
    packages -v package:grinder/src/ansi.dart
    
    Name: grinder
        Lib: file:///Users/mikemitterer/.pub-cache/hosted/pub.dartlang.org/grinder-0.8.0+3/lib
        Uri: file:///Users/mikemitterer/.pub-cache/hosted/pub.dartlang.org/grinder-0.8.0+3/lib/src/ansi.dart
        Resource: http://localhost:62788/packages/grinder/src/ansi.dart
```
Install 'Packages'
```shell
    pub global activate packages
```

Update 'Packages'
```shell
    # activate packages again
    pub global activate packages
```

Uninstall 'Packages'
```shell
    pub global deactivate packages   
```    

###License 

    Copyright 2016 Michael Mitterer (office@mikemitterer.at),
    IT-Consulting and Development Limited, Austrian Branch

    _____           _                         
    |  __ \         | |                        
    | |__) |_ _  ___| | ____ _  __ _  ___  ___ 
    |  ___/ _` |/ __| |/ / _` |/ _` |/ _ \/ __|
    | |  | (_| | (__|   < (_| | (_| |  __/\__ \
    |_|   \__,_|\___|_|\_\__,_|\__, |\___||___/
                             __/ |          
                            |___/           
                                                            
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
    either express or implied. See the License for the specific language
    governing permissions and limitations under the License.


If this plugin is helpful for you - please [(Circle)](http://gplus.mikemitterer.at/) me
or **star** this repo here on GitHub
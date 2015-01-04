Phackage
========

Phackage is an easy to use script to 'attempt' to automate the setup of new PHP Packages.
Without much effort, you can have a library, and unit tests.

Requirements
------------

To start with, you must have a `git config` of `user.name` and `user.email` set up on your machine. Phackage uses these
values to populate some of the data it needs.

Running with `./phackage` will ask you a couple of questions:

 * Package Name - the name of your package, like `MyAwesomePhpPackage`
 * Package Description - Describe the package `My awesome PHP package is... awesome!`
 * Whether to create a `composer.json` file - If you say `Y` then a composer.json file will be created

So that you know...
-------------------

Depending on your needs, this may or may not fit your use case. The `composer.json` file is created with the MIT licence.

It assumes you're going to use GitHub, and you need to have a GitHub username. Nothing gets sent to GitHub, it just uses
your username to establish a probable URL for your package.

Package Structure
-----------------

Here's what the process looks like:

```bash
roger@xps:~/Development/phackage$ ./phackage.sh

-----------------------------------------------
|  Phackage - PHP library creation made easy  |
-----------------------------------------------

What's the name of the package?: MyPackage
Describe the package (for README.md): MyPackage is an awesome package
File: MyPackage-src/src/MyPackage/MyPackage.php created!
File: MyPackage-src/tests/MyPackageTests/TestBase.php created!
File: MyPackage-src/tests/MyPackageTests/MyPackageTest.php created!
File: MyPackage-src/tests/bootstrap.php created!
File: MyPackage-src/phpunit.xml.dist created!
File: MyPackage-src/.gitignore created!
File: MyPackage-src/README.md created!
Running composer check
Do you want to create a default composer file?
[y/n] y
What's your GitHub username?: rogerthomas84
File: MyPackage-src/composer.json created!
Please check the composer.json file and edit the fields as required.
Package creation complete

roger@xps:~/Development/phackage$ cd MyPackage-src/
roger@xps:~/Development/phackage/MyPackage-src$ ll
total 32
drwxrwxr-x 4 roger roger 4096 Jan  5 09:25 ./
drwxrwxr-x 4 roger roger 4096 Jan  5 09:25 ../
-rw-rw-r-- 1 roger roger  422 Jan  5 09:25 composer.json
-rw-rw-r-- 1 roger roger    8 Jan  5 09:25 .gitignore
-rw-rw-r-- 1 roger roger 1351 Jan  5 09:25 phpunit.xml.dist
-rw-rw-r-- 1 roger roger  101 Jan  5 09:25 README.md
drwxrwxr-x 3 roger roger 4096 Jan  5 09:25 src/
drwxrwxr-x 3 roger roger 4096 Jan  5 09:25 tests/
roger@xps:~/Development/phackage/MyPackage-src$

```

#!/usr/bin/env bash

check_file_exists()
{
   if [[ ! -f "$1" ]]; then
       echo -e "\e[31mFatal Error!"
       echo -e "\e[31mFile: $1 does not exist.\e[0m"
       exit 2
   else
       echo -e "\e[92mFile: $1 created!\e[0m"
   fi
}

# These values are assigned during run.
gitEmail=""
gitUser=""
githubUser=""
name=""
description=""

echo
echo "-----------------------------------------------"
echo "|  Phackage - PHP library creation made easy  |"
echo "-----------------------------------------------"
echo

if [[ $EUID == 0 ]]; then
    echo -e "\e[31mDo not use this as root.\e[0m"
    echo
    exit
fi

get_git_email()
{
    gitEmail=`git config user.email`
    if [ -z "$gitEmail" ]; then
        echo -e "\e[31mGit global configuration or user.email cannot be empty.\e[0m"
        exit
    fi
}
get_git_email

get_git_user()
{
    gitUser=`git config user.name`
    if [ -z "$gitUser" ]; then
        echo -e "\e[31mGit global configuration or user.name cannot be empty.\e[0m"
        exit
    fi
}
get_git_user

get_package_name()
{
    while [[ True ]] ; do
        echo -n "What's the name of the package?: "
        read name
        if [ -z "$name" ]; then
            echo -e "\e[31mPackage name cannot be empty\e[0m"
            continue
        fi
        pattern=" |'"
        if [[ $name =~ $pattern ]]; then
            echo -e "\e[31mPackage name cannot contain spaces.\e[0m"
            continue
        fi
        if [ -d "${name}-src" ]; then
            echo -e "\e[31mDirectory: ${name}-src already exists\e[0m"
            continue
        fi
        name="$(tr '[:lower:]' '[:upper:]' <<< ${name:0:1})${name:1}"
        break
    done
}
get_package_name

get_package_description()
{
    while [[ True ]] ; do
        echo -n "Describe the package (for README.md): "
        read description
        if [ -z "$description" ]; then
            echo -e "\e[31mPackage description cannot be empty\e[0m"
            continue
        fi
        break
    done
}
get_package_description


mkdir ${name}-src/src/${name} -p

# Creating ${name}.php
cat << EOF | tee ${name}-src/src/${name}/${name}.php >> /dev/null
<?php
/**
 * @author ${gitUser} <${gitEmail}>
 */
namespace $name;

/**
 * $name
 */
class $name
{
    public function simpleMethod()
    {
        return 1;
    }
}
EOF

check_file_exists ${name}-src/src/${name}/${name}.php

mkdir $name-src/tests/${name}Tests -p

# Creating TestBase.php
cat << EOF | tee ${name}-src/tests/${name}Tests/TestBase.php >> /dev/null
<?php
/**
 * @author ${gitUser} <${gitEmail}>
 */
namespace ${name}Tests;

/**
 * TestBase
 */
class TestBase extends \PHPUnit_Framework_TestCase
{
}
EOF

check_file_exists ${name}-src/tests/${name}Tests/TestBase.php

# Creating ${name}Test.php
cat << EOF | tee ${name}-src/tests/${name}Tests/${name}Test.php >> /dev/null
<?php
/**
 * @author ${gitUser} <${gitEmail}>
 */
namespace ${name}Tests;

use ${name}\\${name};

/**
 * ${name}\Test
 */
class ${name}Test extends TestBase
{
    public function testTemplate()
    {
        \$instance = new ${name}();
        \$this->assertEquals(1, \$instance->simpleMethod());
    }
}
EOF

check_file_exists ${name}-src/tests/${name}Tests/${name}Test.php

# Creating tests bootstrap
cat << EOF | tee ${name}-src/tests/bootstrap.php >> /dev/null
<?php
\$path = realpath(dirname(__FILE__) . '/../');
spl_autoload_register(function (\$name) use(\$path) {
    \$name = implode(DIRECTORY_SEPARATOR, explode('\\\', \$name)) . '.php';
    \$srcPath = \$path . DIRECTORY_SEPARATOR . 'src' . DIRECTORY_SEPARATOR . \$name;
    if (file_exists(\$srcPath)) {
        include \$srcPath;
    }
    \$testsPath = \$path . DIRECTORY_SEPARATOR . 'tests' . DIRECTORY_SEPARATOR . \$name;
    if (file_exists(\$testsPath)) {
        include \$testsPath;
    }
});
EOF

check_file_exists ${name}-src/tests/bootstrap.php

# Creating phpunit.xml.dist
cat << EOF | tee ${name}-src/phpunit.xml.dist >> /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<phpunit
    backupGlobals="true"
    backupStaticAttributes="false"
    cacheTokens="false"
    colors="true"
    convertErrorsToExceptions="true"
    convertNoticesToExceptions="true"
    convertWarningsToExceptions="true"
    forceCoversAnnotation="false"
    mapTestClassNameToCoveredClassName="false"
    processIsolation="false"
    stopOnError="false"
    stopOnFailure="false"
    stopOnIncomplete="false"
    stopOnSkipped="false"
    timeoutForSmallTests="1"
    timeoutForMediumTests="10"
    timeoutForLargeTests="60"
    strict="false"
    bootstrap="tests/bootstrap.php"
    verbose="false">

    <testsuites>
        <testsuite name="All ${name} Tests">
            <directory>tests/${name}Tests</directory>
        </testsuite>
    </testsuites>

    <filter>
        <whitelist>
            <directory>src/${name}</directory>
            <exclude>
                <directory>tests/${name}Tests</directory>
                <file>tests/bootstrap.php</file>
            </exclude>
        </whitelist>
    </filter>

    <logging>
        <log type="coverage-html" target="build/coverage-html" title="${name} Code Coverage" charset="UTF-8" highlight="true" lowUpperBound="35" highLowerBound="70"/>
        <log type="testdox-html" target="build/testdox.html"/>
    </logging>

</phpunit>
EOF

check_file_exists ${name}-src/phpunit.xml.dist

# Creating .gitignore
cat << EOF | tee ${name}-src/.gitignore >> /dev/null
build/*
EOF

check_file_exists ${name}-src/.gitignore

# Creating README.md
cat << EOF | tee ${name}-src/README.md >> /dev/null
${name}
=======

${description}

Getting Started
---------------

To be completed
EOF

check_file_exists ${name}-src/README.md

confirm_composer_file()
{
    echo "Running composer check"
    echo "Do you want to create a default composer file?"
    read -p "[y/n] " -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo
        echo -e "\e[92mPackage creation complete\e[0m"
        echo
        exit
    fi
    echo
}
confirm_composer_file

get_github_username()
{
    while [[ True ]] ; do
        echo -n "What's your GitHub username?: "
        read githubUser
        if [ -z "$githubUser" ]; then
            echo -e "\e[31mGitHub username cannot be empty\e[0m"
            continue
        fi
        break
    done
}
get_github_username

cat << EOF | tee ${name}-src/composer.json >> /dev/null
{
    "name": "$githubUser/${name,,}",
    "description": "${description}",
    "keywords": ["${name,,}"],
    "homepage": "https://github.com/${githubUser}/${name,,}",
    "license": "MIT",
    "authors": [
        {
            "name": "${gitUser}",
            "email": "${gitEmail}"
        }
    ],
    "require": {
    },
    "autoload": {
        "psr-0": { "${name}": "src" }
    }
}
EOF

check_file_exists ${name}-src/composer.json

echo -e "\e[92mPlease check the composer.json file and edit the fields as required.\e[0m"
echo -e "\e[92mPackage creation complete\e[0m"
echo

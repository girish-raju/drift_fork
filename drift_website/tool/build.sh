#!/bin/sh

# Removing the target directory if it already exists
rm -r build/

# If the environmental value IS_RELEASE is set to true, then DONT generate the robots.txt file
if [ "$IS_RELEASE" != "true" ]; then
    echo "Not a release build, set IS_RELEASE to true to allow crawling."
    echo "User-agent: *" > ./web/robots.txt
    echo "Disallow: /" >> ./web/robots.txt
else
    echo "Release build!"
    echo "User-agent: *" > ./web/robots.txt
    echo "Disallow:" >> ./web/robots.txt
fi

# Main content
dart run jaspr_cli:jaspr build --no-managed-build-options
dart run tool/build_search_index.dart
rm -r build/jaspr/packages build/jaspr/.dart_tool build/jaspr/.build.manifest

# Build the flutter web project
cd ../examples/app
flutter pub get
if [ $? -ne 0 ]; then
    echo "Failed to build the example project"
    exit 1
fi
# Run build_runner to generate files in the `test` directory
dart run build_runner build --delete-conflicting-outputs --release
if [ $? -ne 0 ]; then
    echo "Failed to build the example project"
    exit 1
fi

flutter build web --base-href "/examples/app/" --no-web-resources-cdn --pwa-strategy none
if [ $? -ne 0 ]; then
    echo "Failed to build the example project"
    exit 1
fi
mkdir -p ../../docs/build/jaspr/examples/app
rm -r ../../docs/build/jaspr/examples/app/*
mv -f ./build/web/* ../../docs/build/jaspr/examples/app
cd -

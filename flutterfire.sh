#!/bin/bash -e

function exit_if_file_not_exist() {
  if ! [[ -f $1 ]]; then
    echo "🚨 $2"
    exit 1
  fi
}

function run_command() {
  echo -e "\n[EXECUTING] $1\n"
  eval $1
}

# eg. main_prod.dart
function save_dart_main_file() {
  TEMPLATE_DATA=$(cat "lib/main_flavor.dart.template")
  FLAVOR=$1
  DESTINATION="lib/main_$FLAVOR.dart"

  sed "s/#{FLAVOR}/$FLAVOR/g" <<<"$TEMPLATE_DATA" >$DESTINATION
  echo "[CREATED] main_flavor.dart.template -> $DESTINATION"
}

function ensure_generated_dart_define_exist() {
  touch ios/Flutter/GeneratedDartDefines.xcconfig
}

function configure() {
  FLAVOR=$1
  PRODUCT=$2
  PACKAGE_NAME=$3
  WEB_APPLICATION_ID=$4
  ACCOUNT=$5
  PLATFORMS=${PLATFORMS:-'android,ios'}

  save_dart_main_file $FLAVOR
  ensure_generated_dart_define_exist

  run_command "flutterfire configure
    --project=$PRODUCT
    --ios-bundle-id=$PACKAGE_NAME
    --android-package-name=$PACKAGE_NAME
    --macos-bundle-id=$PACKAGE_NAME
    --web-app-id=$WEB_APPLICATION_ID
    --platforms=$PLATFORMS
    --ios-out="ios/Firebase/$FLAVOR/GoogleService-Info.plist"
    --android-out=android/app/src/$FLAVOR/google-services.json
    --macos-out="macos/Firebase/$FLAVOR/GoogleService-Info.plist"
    --out="lib/firebase_options/$FLAVOR.dart"
    --ios-build-config=Release-$FLAVOR
    --macos-build-config=Release-$FLAVOR
    --account=$ACCOUNT
    --token=$TOKEN
    --yes"
}

function main() {
  exit_if_file_not_exist "pubspec.yaml" "Make sure to execute scripts from project directory."

  case $1 in

  --community)
    configure 'community' 'juniorise-spooky-community' 'com.juniorise.spooky.community' '1:892248434003:android:07ab4b2c947355a263eda6' $2
    exit 0
    ;;

  --storypad)
    configure 'storypad' 'tc-write-story' 'com.tc.writestory' '1:315543702519:android:4e9cf4c1923c1dab74fcf2' $2
    exit 0
    ;;

  --spooky)
    configure 'spooky' 'juniorise-spooky' 'com.juniorise.spooky' '1:845318918007:android:8d9f8265b46011fd349b72' $2
    exit 0
    ;;

  *)
    help
    exit 0
    ;;

  esac
  shift
}

main $@

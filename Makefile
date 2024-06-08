flutteflhelp:
	@echo "Usage: make [action]\n \
	actions:\n \
	\tflget\t-> flutter pub get\n \
	\tflbrw\t-> flutter pub run build_runner watch --delete-conflicting-outputs\n \
	\tflbrb\t-> flutter pub run build_runner build --delete-conflicting-outputs\n \
	\tflgrg\t-> flutter pub global run intl_utils:generate\n \
	\tflsort\t-> flutter pub run import_sorter:main lib\/* test\/*\n\
	\tflc\t-> flutter clean\n \
	\tfldoc\t-> flutter doctor\n \
	"

flget:
	flutter pub get

flbrw:
	flutter pub run build_runner watch --delete-conflicting-outputs

flbrb:
	flutter pub run build_runner build --delete-conflicting-outputs

flgrg:
	flutter pub global run intl_utils:generate

flsort:
	flutter pub run import_sorter:main lib\/* test\/*

flc:
	flutter clean

fldoc:
	flutter doctor

# getschema:
# 	get-graphql-schema https://dev.sentimentapp.com.au/graphql > lib/schema.graphql

# getschema-stage:
# 	get-graphql-schema https://stage.sentimentapp.com.au/graphql > lib/schema.graphql

# firebase-config:
# 	flutterfire config \
#   --project=sentiment-9aad8 \
#   --out=lib/firebase_options.dart \
#   --ios-bundle-id=com.sentimentoperation.app \
#   --android-package-name=com.sentiment.app

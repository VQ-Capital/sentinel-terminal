.PHONY: all setup check lint fix build test clean run

all: check lint build

setup:
	@echo "⚙️ Installing dependencies..."
	flutter pub get

check:
	@echo "🔍 Checking code (analyze)..."
	flutter analyze

fix:
	@echo "🔧 Auto-fixing issues..."
	dart fix --apply
	dart format .

lint:
	@echo "🧹 Running linter and formatter (check mode)..."
	dart format --output=none --set-exit-if-changed .
	flutter analyze

build:
	@echo "🏗️ Building release version..."
	$(MAKE) build-web
	$(MAKE) build-linux
	$(MAKE) build-android

build-android:
	flutter build apk

build-ios:
	flutter build ios

build-web:
	flutter build web

build-macos:
	flutter build macos

build-linux:
	flutter build linux

build-windows:
	flutter build windows

test:
	@echo "🧪 Running tests..."
	flutter test

clean:
	@echo "🗑️ Cleaning artifacts..."
	flutter clean

run:
	@echo "🚀 Running the application..."
	flutter run

run-dev:
	flutter run --debug	

ci: check lint test	
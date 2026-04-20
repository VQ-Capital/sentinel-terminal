.PHONY: all setup check lint fix build test clean

all: check lint build

setup:


check:
	@echo "🔍 Checking code for compilation errors..."


fix:
	@echo "🔧 Auto-fixing issues..."


lint:
	@echo "🧹 Running linter and formatter (check mode)..."


build:


test:
	@echo "🧪 Running tests..."


clean:
	@echo "🗑️ Cleaning artifacts..."


run:
	@echo "🚀 Running the application..."

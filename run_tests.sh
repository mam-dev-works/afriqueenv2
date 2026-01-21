#!/bin/bash

# AfriQueen Test Runner
# Usage: ./run_tests.sh [option]

set -e

echo "🧪 AfriQueen Test Runner"
echo "======================="

case "$1" in
  "all")
    echo "Running all tests..."
    flutter test
    ;;
  "coverage")
    echo "Running tests with coverage..."
    flutter test --coverage
    echo "Generating HTML coverage report..."
    genhtml coverage/lcov.info -o coverage/html 2>/dev/null || echo "Install genhtml: brew install lcov (Mac) or apt-get install lcov (Linux)"
    echo "Coverage report: coverage/html/index.html"
    ;;
  "watch")
    echo "Running tests in watch mode..."
    flutter test --watch
    ;;
  "bloc")
    echo "Running BLoC tests..."
    flutter test test/features/*/bloc/*_test.dart
    ;;
  "repo")
    echo "Running repository tests..."
    flutter test test/features/*/repository/*_test.dart
    ;;
  "widgets")
    echo "Running widget tests..."
    flutter test test/widgets/
    ;;
  *)
    echo "Usage: ./run_tests.sh [option]"
    echo ""
    echo "Options:"
    echo "  all       - Run all tests"
    echo "  coverage  - Run tests with coverage report"
    echo "  watch     - Run tests in watch mode"
    echo "  bloc      - Run only BLoC tests"
    echo "  repo      - Run only repository tests"
    echo "  widgets   - Run only widget tests"
    echo ""
    echo "Example: ./run_tests.sh coverage"
    ;;
esac

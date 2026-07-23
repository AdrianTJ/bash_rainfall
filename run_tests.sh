#!/bin/bash

# Master Test Runner

# Run from the repository root so the tests/ glob resolves regardless of
# where this script is invoked from
cd "$(dirname "$0")" || exit 1

echo "Starting all tests..."
echo "-------------------"

failed=0
for test_file in tests/test_*.sh; do
    [[ -f "$test_file" ]] || continue
    if ! bash "$test_file"; then
        echo "❌ FAILED: $test_file"
        failed=1
    fi
done

echo "-------------------"
if (( failed )); then
    echo "❌ Some tests failed!"
    exit 1
fi
echo "✅ All tests passed! 🎉"

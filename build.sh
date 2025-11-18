#!/usr/bin/env bash
# Build script for Infinite Stairs PC
# Builds game for Windows, Linux, and macOS

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Build configuration
VERSION="1.0.0"
GODOT_BIN="godot"  # Assumes godot is in PATH

# Check if Godot is available
if ! command -v $GODOT_BIN &> /dev/null; then
    echo -e "${RED}Error: Godot not found in PATH${NC}"
    echo "Please install Godot 4.3+ or add it to your PATH"
    echo "Download from: https://godotengine.org/download"
    exit 1
fi

# Create builds directory
mkdir -p builds/windows builds/linux builds/macos

# Function to build for a specific platform
build_platform() {
    local platform=$1
    local preset_name=$2
    local output_path=$3

    echo -e "${YELLOW}Building for $platform...${NC}"

    $GODOT_BIN --headless --export-release "$preset_name" "$output_path" 2>&1 | grep -v "^$"

    if [ -f "$output_path" ] || [ -d "$output_path" ]; then
        echo -e "${GREEN}✓ $platform build complete: $output_path${NC}"
        return 0
    else
        echo -e "${RED}✗ $platform build failed${NC}"
        return 1
    fi
}

# Parse command line arguments
PLATFORM="${1:-all}"

case "$PLATFORM" in
    windows|win)
        build_platform "Windows" "Windows Desktop" "builds/windows/InfiniteStairs.exe"
        ;;
    linux)
        build_platform "Linux" "Linux/X11" "builds/linux/InfiniteStairs.x86_64"
        ;;
    macos|mac)
        build_platform "macOS" "macOS" "builds/macos/InfiniteStairs.zip"
        ;;
    all)
        echo -e "${GREEN}Building all platforms...${NC}"
        echo ""

        build_platform "Windows" "Windows Desktop" "builds/windows/InfiniteStairs.exe"
        echo ""

        build_platform "Linux" "Linux/X11" "builds/linux/InfiniteStairs.x86_64"
        echo ""

        build_platform "macOS" "macOS" "builds/macos/InfiniteStairs.zip"
        echo ""

        echo -e "${GREEN}All builds complete!${NC}"
        ;;
    *)
        echo -e "${RED}Unknown platform: $PLATFORM${NC}"
        echo "Usage: $0 [windows|linux|macos|all]"
        exit 1
        ;;
esac

# Make Linux build executable
if [ -f "builds/linux/InfiniteStairs.x86_64" ]; then
    chmod +x builds/linux/InfiniteStairs.x86_64
    echo -e "${GREEN}✓ Linux executable permissions set${NC}"
fi

echo ""
echo -e "${GREEN}Build process finished!${NC}"
echo "Builds are located in the 'builds/' directory"

#!/bin/bash
# setup-jj-docs.sh
# Sets up JJ (Jujutsu) official documentation for evidence-based skill

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

DOCS_DIR="$HOME/.local/share/jj-docs"
REPO_DIR="$DOCS_DIR/repo"
VERSION_FILE="$DOCS_DIR/VERSION.txt"
JJ_REPO_URL="https://github.com/jj-vcs/jj.git"

echo "Setting up JJ documentation..."
echo

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is not installed${NC}"
    echo "Please install git first:"
    echo "  - macOS: brew install git"
    echo "  - Ubuntu/Debian: sudo apt install git"
    echo "  - Fedora: sudo dnf install git"
    exit 1
fi

# Create docs directory
mkdir -p "$DOCS_DIR"

# Clone or update repository
if [ -d "$REPO_DIR/.git" ]; then
    echo -e "${YELLOW}Documentation repository already exists. Updating...${NC}"
    cd "$REPO_DIR"

    # Save current commit for comparison
    OLD_COMMIT=$(git rev-parse HEAD)

    # Update repository
    if git pull --quiet; then
        NEW_COMMIT=$(git rev-parse HEAD)
        if [ "$OLD_COMMIT" = "$NEW_COMMIT" ]; then
            echo -e "${GREEN}Documentation is already up to date${NC}"
        else
            echo -e "${GREEN}Documentation updated successfully${NC}"
            echo "  Old commit: ${OLD_COMMIT:0:12}"
            echo "  New commit: ${NEW_COMMIT:0:12}"
        fi
    else
        echo -e "${RED}Failed to update repository${NC}"
        exit 1
    fi
else
    echo "Cloning JJ repository to $REPO_DIR..."
    echo "This may take a minute..."

    if git clone --quiet "$JJ_REPO_URL" "$REPO_DIR"; then
        echo -e "${GREEN}Repository cloned successfully${NC}"
        cd "$REPO_DIR"
    else
        echo -e "${RED}Failed to clone repository${NC}"
        echo "Please check your internet connection and try again"
        exit 1
    fi
fi

# Get version information
COMMIT_HASH=$(git rev-parse HEAD)
COMMIT_DATE=$(git log -1 --format=%cd --date=short)
COMMIT_SUBJECT=$(git log -1 --format=%s)
GIT_VERSION=$(git describe --tags 2>/dev/null || echo "unknown")
DOWNLOAD_DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Write version information
cat > "$VERSION_FILE" << EOF
JJ Documentation Version Information
=====================================

Git commit hash: $COMMIT_HASH
Commit date: $COMMIT_DATE
Commit subject: $COMMIT_SUBJECT
Git version: $GIT_VERSION
Downloaded: $DOWNLOAD_DATE

Repository: $JJ_REPO_URL
Location: $REPO_DIR/docs/

To update documentation:
  cd $REPO_DIR && git pull

Or re-run this script:
  $0
EOF

echo
echo -e "${GREEN}Documentation installed successfully!${NC}"
echo
echo "Documentation location:"
echo "  $REPO_DIR/docs/"
echo
echo "Version information:"
echo "  Commit: ${COMMIT_HASH:0:12}"
echo "  Date: $COMMIT_DATE"
echo "  Version: $GIT_VERSION"
echo
echo "Version details saved to:"
echo "  $VERSION_FILE"
echo
echo -e "${GREEN}Setup complete!${NC}"
echo
echo "The JJ skill can now use official documentation from:"
echo "  $REPO_DIR/docs/"

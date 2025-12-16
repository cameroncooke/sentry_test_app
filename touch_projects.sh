#!/bin/bash

# Script to touch both iOS and Android projects to re-trigger size analysis workflows

TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")

# Update Android README
cat > android/README.md << EOF
# Android Project

Last updated: $TIMESTAMP
EOF

# Update iOS README
cat > ios/README.md << EOF
# iOS Project

Last updated: $TIMESTAMP
EOF

echo "Updated both projects with timestamp: $TIMESTAMP"
echo "  - android/README.md"
echo "  - ios/README.md"

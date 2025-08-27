#!/bin/bash

echo "Committing and pushing changes..."
echo

git add .
git commit -m "feat: add comprehensive single-spa setup with nvm support

- Updated README with complete architecture documentation
- Enhanced .gitignore with comprehensive patterns
- Added launch scripts for Windows (.bat) and Unix (.sh)
- Added .nvmrc for Node.js version management
- Updated package.json with additional utility scripts
- Added nvm support to all launch scripts"

git push

echo
echo "Done!"
#!/bin/bash
set -e;

echo "Installing deb";
dpkg -i $(find /workspace/.build/linux -type f -name '*.deb');

echo "Calling startxvfb.sh";
bash -c "/workspace/tools/startxvfb.sh";
    
echo "Detecting code-oss";
which code-oss;

echo "Calling test script";
xvfb-run /usr/bin/code-oss . --user-data-dir='.' test/electron/index.js;

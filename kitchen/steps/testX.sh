#!/bin/bash

echo "Exporting display :99.0";
#!/bin/bash

# testX.sh
#
# Start an X11 session with XVFB to run a passed test script (relative path!), then shut it down on completion.
#
# usage: testX.sh <test_script>

export DISPLAY=:99.0;

echo "Starting xvfb";
sh -e ../../../tools/xvfb start;

echo "Waiting 10 seconds for xvfb to start up";
sleep 10;
    
echo "Running tests";
$1;
    
echo "Stopping xvfb";
sh -e ../../../tools/xvfb stop;

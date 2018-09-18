#!/bin/bash
set -e;

echo "Entering code directory";
cd "$COBBLER_CODE_DIRECTORY";
    
echo "Applying patches";
for patch_script in ~/kitchen/cobbler/ingredients/patches/*
do

  echo "Marking patch as executable [${patch_script}]";
  chmod +x ~/kitchen/cobbler/ingredients/patches/${patch_script};
  
  echo "Executing patch [${patch_script}]";
  ~/kitchen/cobbler/ingredients/patches/${patch_script};
  
done
    
echo "Applying overlays";
/bin/cp --verbose -rf ~/kitchen/cobbler/ingredients/overlays/* /;

#!/bin/bash
set -e;

echo "Entering code directory";
cd "$ARCHIE_CODE_DIRECTORY";
    
echo "Applying patches";
for patch_script in ~/kitchen/archie/ingredients/patches/*
do

  echo "Marking patch as executable [${patch_script}]";
  chmod +x ~/kitchen/archie/ingredients/patches/${patch_script};
  
  echo "Executing patch [${patch_script}]";
  ~/kitchen/archie/ingredients/patches/${patch_script};
  
done
    
echo "Applying overlays";
/bin/cp --verbose -rf ~/kitchen/archie/ingredients/overlays/* /;

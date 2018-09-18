#!/bin/bash
set -e;
    
echo "Applying patches";
for patch_script in ~/root/kitchen/cobbler/ingredients/patches/*.sh
do
  echo "Executing patch [${patch_script}]";
  . ./${patch_script};
done
    
echo "Applying overlays";
/bin/cp --verbose -rf ~/root/kitchen/cobbler/ingredients/overlays/* ./;

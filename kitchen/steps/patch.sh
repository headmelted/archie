#!/bin/bash
set -e;

ls ../../../../cobbler/;
    
echo "Applying patches";
for patch_script in ../../../../cobbler/ingredients/patches/*.sh
do
  echo "Executing patch [${patch_script}]";
  . ./${patch_script};
done
    
echo "Applying overlays";
/bin/cp --verbose -rf ../../../../cobbler/ingredients/overlays/* ./;

#!/bin/sh
sed -i \
         -e 's/#160909/rgb(0%,0%,0%)/g' \
         -e 's/#c4c1c1/rgb(100%,100%,100%)/g' \
    -e 's/#160909/rgb(50%,0%,0%)/g' \
     -e 's/#076e01/rgb(0%,50%,0%)/g' \
     -e 's/#160909/rgb(50%,0%,50%)/g' \
     -e 's/#c4c1c1/rgb(0%,0%,50%)/g' \
	"$@"

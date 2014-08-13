#!/bin/sh
rm ../scripts/carousel_min.js
jsmin <../scripts/carousel.js > ../scripts/carousel_min_tmp.js
cat ../scripts/copyright.txt ../scripts/carousel_min_tmp.js > ../scripts/carousel_min.js
rm ../scripts/carousel_min_tmp.js
cp ../scripts/carousel_min.js ../scripts/carousel_min_tmp.js
gzip ../scripts/carousel_min.js
mv ../scripts/carousel_min_tmp.js ../scripts/carousel_min.js


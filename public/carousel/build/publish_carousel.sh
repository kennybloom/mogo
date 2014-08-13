#!/bin/sh

stamp="0.5.1"

##########################################
## HTML-NEW ~bscott/carousel/
##########################################
# Clean up old js & css files on html-new
ssh bscott@html-new.yahoo.com 'rm /homes/bscott/carousel/*.js'
ssh bscott@html-new.yahoo.com 'rm /homes/bscott/carousel/*.css'

# Stage new js & css files
scp ../scripts/carousel_min.js bscott@html-new.yahoo.com:/homes/bscott/carousel/carousel_$stamp.js
scp ../css/carousel.css bscott@html-new.yahoo.com:/homes/bscott/carousel/carousel_$stamp.css

##########################################
## HTML-NEW yahoo akamai area
##########################################
# Clean up prior files
ssh bscott@html-new.yahoo.com sudo -u yahoo 'rm /home/yahoo/htdocs.static/lib/yde/carousel/*.js'
ssh bscott@html-new.yahoo.com sudo -u yahoo 'rm /home/yahoo/htdocs.static/lib/yde/carousel/css/*.css'

# Push new js & css files
ssh bscott@html-new.yahoo.com sudo -u yahoo 'cp /homes/bscott/carousel/*.js /home/yahoo/htdocs.static/lib/yde/carousel/carousel_'$stamp'.js'
ssh bscott@html-new.yahoo.com sudo -u yahoo 'cp /homes/bscott/carousel/*.css /home/yahoo/htdocs.static/lib/yde/carousel/css/carousel_'$stamp'.css'


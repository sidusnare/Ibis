#!/bin/bash


TWITTER_BASE='https://twitter.com/search?f=tweets&vertical=default&q=geocode%3A'
RADIUS='30km'
#When the NHC is tracking a tropical storm / hurricane, it will have a box on http://www.nhc.noaa.gov/ 
#in the top left there will be an RSS looking icon that points to an XML feed with a markup they are 
#calling georss. We are just going to be crude and cut the lat long out of it with grep, etc... 
#So if you are using this after Irma, look find the new / correct feed and set it below.
NOAA_NHC_FEED='http://www.nhc.noaa.gov/nhc_at1.xml'


for p in xdg-open curl grep sed head;do
	if ! which "${p}" &>> /dev/null; then
		echo "Unable to find ${p}" >&2
		exit 1
	fi
done
#If they change the precision or you want to follow storms in other hemispheres, change the grep on 3 lines below to match
LATLONG=$(curl -k -s "${NOAA_NHC_FEED}" | grep '<nhc:center>.*</nhc:center>' |\
sed -e 's#<nhc:center>#\n#' -e 's#</nhc:center>#\n#' -e 's/ //g' |\
grep '^[0-9]*\.[0-9],-[0-9]*.[0-9]$' | head -n 1 | sed -e 's/,/%2C/' )

TWITTER_URI="${TWITTER_BASE}${LATLONG}%2C${RADIUS}"
echo "${TWITTER_URI}"
xdg-open "${TWITTER_URI}"

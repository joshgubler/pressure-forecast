jq='docker run --rm -i stedolan/jq'

LOCATION=$1
KEY=$2

DATA=`curl -s "http://api.worldweatheronline.com/free/v2/weather.ashx?q=$LOCATION&key=$KEY&format=json"`

DATES=`echo $DATA | $jq -c '[.data.weather[].date]'`
HOURS=`echo $DATA | $jq -c '[.data.weather[].hourly[].time]'`
PRESSURES=`echo $DATA | $jq -c '[.data.weather[].hourly[].pressure]'`
MIN=`echo $PRESSURES | $jq -c 'min'`
MAX=`echo $PRESSURES | $jq -c 'max'`

DATE_LABELS=`echo $DATES | sed 's/\"//g' | sed 's/\[/||/g' | sed 's/\]/||/g' | sed 's/,/||/g'`
HOUR_LABELS=`echo $HOURS | sed 's/\"//g' | sed 's/\[/|/g' | sed 's/\]/|/g' | sed 's/,/|/g' | sed 's/00//g'`
PRESSURE_DATA=`echo $PRESSURES | sed 's/\"//g' | sed 's/\[//g' | sed 's/\]//g'`
MIN_LABEL=`echo $MIN | sed 's/\"//g'`
MAX_LABEL=`echo $MAX | sed 's/\"//g'`

open "https://chart.googleapis.com/chart?cht=lc&chd=t:${PRESSURE_DATA}&chs=1000x300&chxt=x,x,y&chxl=0:${HOUR_LABELS}1:${DATE_LABELS}2:|${MIN_LABEL}|${MAX_LABEL}&chds=${MIN_LABEL},${MAX_LABEL}&chxtc=0,-300,0,0,0,0,0,0,0"

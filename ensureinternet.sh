#!/bin/sh


if pidof -x -o %PPID `basename $0` > /dev/null; then 
  exit
fi


#IP that does not answer to ping
#134.170.184.133
setConnected() {
  if (ping -n -W 2 -c 1 130.237.222.80 || ping -n -W 2 -c 1 8.8.8.8 || ping -n -W 2 -c 1 139.130.4.5) 1>&2 > /dev/null; then
    connected=true
  else
    connected=false
  fi
}

# Keep at it for 15 minutes about (1000 secs plus ping)
setConnected
attempts=0
while ! ${connected} && [ ${attempts} -lt 200 ] ; do
  setConnected
  sleep 5
  attempts=$((attempts + 1))
done

date
exit

if ! ${connected}; then
  echo "Resetting power to router on `date`"
  if tdtool --off Router|grep 'TellStick not found'
  then
    echo "Rebooting  on `date`"
    reboot
  fi
  sleep 30
  if tdtool --on Router|grep 'TellStick not found'
  then
    echo "Rebooting on `date`"
    reboot
  fi
fi


system-log "Waiting for system ready message"

FILE=/usr/share/retroarch/.ready

while true; do
  
  if [ -e "$FILE" ]; then
      break
  fi
  
  sleep 1
done

system-log "System now ready!"

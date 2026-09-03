FILE=/usr/share/retroarch/.ready

while true; do
  
  if [ -e "$FILE" ]; then
      break
  fi
  
  sleep 1
done

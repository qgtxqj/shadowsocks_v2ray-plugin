[ -z "$SSH_CLIENT" ] && source <(curl --fail --retry 3 -sSL "$HEROKU_EXEC_URL")

  if [ $(ps -ef | grep "ss-server" | grep -v "grep" | wc -l) -eq 0 ]
  then
 /entrypoint.sh
  echo "Restart ss Success!"
  fi
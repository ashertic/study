

checkFileIncludeString() {
  targetFile=$1
  searchString=$2

  # echo "$searchString"

  grep "$searchString" "$targetFile" > /dev/null
  if [ $? -eq 0 ]; then
    return 0 # found
  else
    return 1 # not found
  fi
}

appendWithCheck() {
  targetFilePath="$1"
  content="$2"
  if [ -e "$targetFilePath" ]
  then
    checkFileIncludeString "$targetFilePath" "$content"
    if [ $? -eq 1 ]
    then
      echo "Append '$content' to file:$targetFilePath"
      echo "$content" >> "$targetFilePath"
    fi
  fi

  return 0
}
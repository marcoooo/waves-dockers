(
  echo "USE mysql;"
  echo "set password for 'root'@'localhost' = password('bl@hblah');" >&2
  echo "set password for 'root'@'%' = password ('bl@hblah');" >&2
  echo "FLUSH PRIVILEGES;" >&2
  echo "CREATE USER 'wcs'@'localhost' IDENTIFIED BY 'password';" >&2
  echo "CREATE DATABASE agave-api;" >&2
  echo "CREATE DATABASE mavenbootstrap;" >&2 
  echo "GRANT ALL PRIVILEGES ON * . * TO 'wcs'@'localhost';" >&2
  sleep 5
  echo "UNLOCK  tables;" >&2
) | mysql ${ARGUMENTS}
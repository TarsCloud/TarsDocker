#!/bin/sh
# wait-for-mysql.sh

set -e

>&2 echo "$DBIP"
>&2 echo "$DBUser"
>&2 echo "$DBPassword"
>&2 echo "$DBPort"

until mysql -h"$DBIP" -u"$DBUser" -p"$DBPassword" -P"$DBPort" -e ";"; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 1
done

>&2 echo "MySQL is up - executing command"
exec "$@"
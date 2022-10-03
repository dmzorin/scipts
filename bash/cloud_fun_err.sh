#!/bin/bash

fun_calc() {
YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# argument
if [ -z "${1}" ]; then
echo "Date required in format: yyyy-mm-dd"
return
fi

pro=${2:-aan}
function_list=(
"function1"
"function2"
)

for function_name in ${function_list[*]}; do
printf "$YELLOW%-56s$NC%s" $function_name SUCCESS:
success_count=`gcloud logging read 'timestamp<="'${1}'T23:59:59.999Z" AND
timestamp>="'${1}'T00:00:00.000Z" AND
textPayload=~"finished with status: '"'"'ok'"'"'" AND
resource.labels.function_name="'$function_name'"' --project=${pro} --format list | grep -c "insertId:"`
printf "$GREEN%5s$NC CRASH:" $success_count

crash_count=`gcloud logging read 'timestamp<="'${1}'T23:59:59.999Z" AND
timestamp>="'${1}'T00:00:00.000Z" AND
textPayload=~"finished with status: '"'"'crash'"'"'" AND
resource.labels.function_name="'$function_name'"' --project=${pro} --format list | grep -c "insertId:"`
printf "$RED%5s$NC\n" $crash_count
done
}

# usage: fun_calc 2022-01-26
declare "$1=$2"
var="$1"
echo "${!var}"

declare -a "$1"
declare "$1[0]=testarray"
declare "$1[1]=testzwei"
var=$1[0]
echo "${!var}"

for (( i = 0; i < 2; i++ )); do
    var=$1[i]
    echo "${!var}"
    echo "${test[i]}"
done

if [ -z ${test+x} ]; then echo "test array is unset"; else echo "test array is set"; fi

unset "$1"

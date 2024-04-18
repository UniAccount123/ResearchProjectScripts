[ "$#" -lt 3 ] && { echo "Usage: start-jupyter <host> <port> <config>"; exit 1; }

trap "ssh $1 'pkill -u \$USER -f jupyter'" EXIT
ssh -XL $2:localhost:$2 $1 "source /data/scratch/forschungsprojekt/config/$3.sh && jupyter lab --no-browser --port=$2"


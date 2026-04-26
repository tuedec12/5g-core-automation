#!/bin/bash
echo "Running advanced multi-UE simulation..."

cd ~/UERANSIM
rm -f ue.log

echo "Booting 3 smartphones..."
# The -n 3 flag tells UERANSIM to boot 3 phones and auto-increment the IMSI!
sudo build/nr-ue -c config/open5gs-ue.yaml -n 3 > ue.log 2>&1 &

sleep 15

count=$(grep -c "PDU Session establishment is successful" ue.log)

sudo killall nr-ue

if [ "$count" -ge 3 ]
then
   echo "PASS: All 3 UEs successfully connected ✅"
   exit 0
else
   echo "FAIL: Only $count UEs connected ❌"
   exit 1
fi

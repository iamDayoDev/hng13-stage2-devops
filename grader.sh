#!/bin/bash

echo "🔍 Step 1: Baseline check (Blue active)..."

# Send 5 baseline requests
for i in {1..5}; do
  response=$(curl -s -D - http://localhost:8080/version)
  status=$(echo "$response" | grep HTTP | awk '{print $2}')
  pool=$(echo "$response" | grep X-App-Pool | awk '{print $2}' | tr -d '\r')
  release=$(echo "$response" | grep X-Release-Id | awk '{print $2}' | tr -d '\r')

  if [ "$status" != "200" ]; then
    echo "❌ Request $i failed with status $status"
    exit 1
  fi

  if [ "$pool" != "blue" ]; then
    echo "❌ Request $i routed to $pool instead of blue"
    exit 1
  fi

  echo "✅ Request $i OK — Pool: $pool, Release: $release"
done

echo "🔥 Step 2: Trigger chaos on Blue..."
curl -s -X POST http://localhost:8081/chaos/start?mode=error
sleep 5

echo "🔁 Step 3: Testing failover to Green..."

green_count=0
total=10

for i in $(seq 1 $total); do
  response=$(curl -s -D - http://localhost:8080/version)
  status=$(echo "$response" | grep HTTP | awk '{print $2}')
  pool=$(echo "$response" | grep X-App-Pool | awk '{print $2}' | tr -d '\r')
  release=$(echo "$response" | grep X-Release-Id | awk '{print $2}' | tr -d '\r')

  if [ "$status" != "200" ]; then
    echo "❌ Failover test $i failed with status $status"
    exit 1
  fi

  if [ "$pool" == "green" ]; then
    green_count=$((green_count + 1))
  fi

  echo "✅ Failover test $i — Pool: $pool, Release: $release"
done

echo "📊 Step 4: Stability check..."
echo "✅ $green_count/$total responses routed to Green"

if [ "$green_count" -lt 9 ]; then
  echo "❌ Failover unstable — less than 95% routed to Green"
  exit 1
fi

echo "✅ All tests passed — Blue failed, Green took over, headers intact, no downtime"

# Optional: stop chaos
curl -s -X POST http://localhost:8081/chaos/stop
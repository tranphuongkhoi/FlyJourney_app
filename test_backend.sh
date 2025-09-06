#!/bin/bash

echo "🔍 Testing Backend Connection..."
echo "================================"

# Test basic connection
echo "1. Testing basic connection to localhost:3000..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 | grep -q "200\|404\|500"; then
    echo "✅ Backend is running on port 3000"
else
    echo "❌ Backend is not accessible on port 3000"
    echo "💡 Make sure your backend server is running with: npm start or yarn start"
    exit 1
fi

# Test API endpoints
echo ""
echo "2. Testing API endpoints..."

# Test flights search endpoint
echo "Testing POST /api/v1/flights/search..."
response=$(curl -s -X POST http://localhost:3000/api/v1/flights/search \
  -H "Content-Type: application/json" \
  -d '{
    "departure_airport_code": "HAN",
    "arrival_airport_code": "SGN", 
    "departure_date": "01/08/2025",
    "airline_ids": [],
    "flight_class": "business",
    "passenger": {
      "adults": 1,
      "children": 0,
      "infant": 0
    },
    "page": 1,
    "limit": 50,
    "sort_by": "price",
    "sort_order": "asc"
  }' \
  -w "HTTP_CODE:%{http_code}")

http_code=$(echo "$response" | grep -o "HTTP_CODE:[0-9]*" | cut -d: -f2)

if [ "$http_code" = "200" ]; then
    echo "✅ Flight search API is working"
    echo "$response" | head -5
else
    echo "❌ Flight search API failed with code: $http_code"
    echo "$response"
fi

echo ""
echo "3. Testing roundtrip endpoint..."

# Test roundtrip search endpoint  
response2=$(curl -s -X POST http://localhost:3000/api/v1/flights/search/roundtrip \
  -H "Content-Type: application/json" \
  -d '{
    "departure_airport_code": "HAN",
    "arrival_airport_code": "SGN",
    "departure_date": "01/08/2025", 
    "return_date": "04/08/2025",
    "airline_ids": [2],
    "flight_class": "all",
    "passengers": {
      "adults": 1,
      "children": 0,
      "infants": 0
    },
    "page": 1,
    "limit": 50,
    "sort_by": "price",
    "sort_order": "asc"
  }' \
  -w "HTTP_CODE:%{http_code}")

http_code2=$(echo "$response2" | grep -o "HTTP_CODE:[0-9]*" | cut -d: -f2)

if [ "$http_code2" = "200" ]; then
    echo "✅ Roundtrip search API is working"
else
    echo "❌ Roundtrip search API failed with code: $http_code2"
    echo "$response2"
fi

echo ""
echo "🎉 Backend testing completed!"
echo "💡 Check the Flutter Debug Console for detailed logs when using the app"

#!/bin/bash

# API Testing Examples with curl

BASE_URL="http://localhost:3000"
TOKEN=""

echo "=========================================="
echo "Tester Panel API Testing Examples"
echo "=========================================="

# 1. Health Check
echo ""
echo "1️⃣  Health Check"
echo "GET $BASE_URL/api/health"
curl -s "$BASE_URL/api/health" | jq .
echo ""

# 2. Register
echo ""
echo "2️⃣  Register User"
echo "POST $BASE_URL/api/auth/register"
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/api/auth/register" \
  -H "Content-Type: application/json" \
  -d '{"email":"testuser@example.com","password":"password123","name":"Test User"}')

echo "$REGISTER_RESPONSE" | jq .

# Extract token from registration response
TOKEN=$(echo "$REGISTER_RESPONSE" | jq -r '.token // empty')

if [ -z "$TOKEN" ]; then
  echo "❌ Failed to get token from registration"
  exit 1
fi

echo "✓ Token: $TOKEN"

# 3. Login
echo ""
echo "3️⃣  Login User"
echo "POST $BASE_URL/api/auth/login"
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"testuser@example.com","password":"password123"}')

echo "$LOGIN_RESPONSE" | jq .
TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.token')

# 4. Get Current User
echo ""
echo "4️⃣  Get Current User Profile"
echo "GET $BASE_URL/api/users/profile/me"
curl -s -X GET "$BASE_URL/api/users/profile/me" \
  -H "Authorization: Bearer $TOKEN" | jq .

# 5. Get All Users
echo ""
echo "5️⃣  Get All Users"
echo "GET $BASE_URL/api/users"
curl -s -X GET "$BASE_URL/api/users" \
  -H "Authorization: Bearer $TOKEN" | jq .

# 6. Create Item
echo ""
echo "6️⃣  Create Item"
echo "POST $BASE_URL/api/items"
ITEM_RESPONSE=$(curl -s -X POST "$BASE_URL/api/items" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Item","description":"This is a test item","status":"pending"}')

echo "$ITEM_RESPONSE" | jq .

# 7. Get All Items
echo ""
echo "7️⃣  Get All Items"
echo "GET $BASE_URL/api/items"
curl -s -X GET "$BASE_URL/api/items" \
  -H "Authorization: Bearer $TOKEN" | jq .

# 8. Update Item
echo ""
echo "8️⃣  Update Item"
echo "PUT $BASE_URL/api/items/1"
curl -s -X PUT "$BASE_URL/api/items/1" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated Item","status":"in_progress"}' | jq .

echo ""
echo "=========================================="
echo "✅ Testing Complete!"
echo "=========================================="

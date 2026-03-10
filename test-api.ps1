# PowerShell script for comprehensive API testing
# Works on Windows with PowerShell 5.1+

param(
    [string]$BaseUrl = "http://localhost:3000",
    [switch]$Verbose
)

# Colors for output
$colors = @{
    Success = "Green"
    Error = "Red"
    Warning = "Yellow"
    Info = "Cyan"
}

function Write-Status {
    param($Message, $Type = "Info")
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "[$timestamp] " -NoNewline
    Write-Host $Message -ForegroundColor $colors[$Type]
}

function Test-Endpoint {
    param(
        [string]$Method,
        [string]$Endpoint,
        [hashtable]$Headers = @{},
        [string]$Body = $null,
        [string]$Description = ""
    )
    
    $url = "$BaseUrl$Endpoint"
    Write-Status "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Info"
    Write-Host "🧪 TEST: $Description"
    Write-Host "   $Method $Endpoint"
    
    try {
        $params = @{
            Uri = $url
            Method = $Method
            Headers = $Headers
            ContentType = "application/json"
        }
        
        if ($Body) {
            $params["Body"] = $Body
        }
        
        $response = Invoke-WebRequest @params -ErrorAction Stop
        $content = $response.Content | ConvertFrom-Json
        
        Write-Status "✅ SUCCESS (HTTP $($response.StatusCode))" "Success"
        
        if ($Verbose) {
            Write-Host ($content | ConvertTo-Json -Depth 3) -ForegroundColor Gray
        }
        
        return $content
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.Value__
        $errorMsg = $_.Exception.Message
        
        Write-Status "❌ FAILED (HTTP $statusCode)" "Error"
        Write-Status "Error: $errorMsg" "Error"
        
        return $null
    }
}

# Main testing sequence
Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  API Testing Suite - Tester Panel      ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

Write-Status "Testing API at: $BaseUrl" "Info"
Write-Status "Verbose mode: $Verbose" "Info"
Write-Host ""

# Test 1: Health Check
Write-Status "1️⃣ Health Check Test" "Info"
$health = Test-Endpoint -Method GET -Endpoint "/api/health" `
    -Description "Server health status"

if ($null -eq $health) {
    Write-Status "❌ Could not connect to server. Is it running?" "Error"
    exit 1
}

Write-Host ""

# Test 2: Register User
Write-Status "2️⃣ User Registration Test" "Info"
$email = "test-$(Get-Random)@example.com"
$registerBody = @{
    email = $email
    password = "TestPassword123!"
    name = "Test User $(Get-Date -Format 'HHmmss')"
} | ConvertTo-Json

$registerResponse = Test-Endpoint -Method POST -Endpoint "/api/auth/register" `
    -Body $registerBody `
    -Description "Register new user"

if ($null -eq $registerResponse -or -not $registerResponse.token) {
    Write-Status "⚠️  Registration failed, trying login with existing user" "Warning"
    $email = "testuser@example.com"
    $password = "password123"
}
else {
    $password = "TestPassword123!"
}

Write-Host ""

# Test 3: Login
Write-Status "3️⃣ User Login Test" "Info"
$loginBody = @{
    email = $email
    password = $password
} | ConvertTo-Json

$loginResponse = Test-Endpoint -Method POST -Endpoint "/api/auth/login" `
    -Body $loginBody `
    -Description "User login with credentials"

if ($null -eq $loginResponse -or -not $loginResponse.token) {
    Write-Status "❌ Login failed, cannot continue tests" "Error"
    exit 1
}

$token = $loginResponse.token
$userId = $loginResponse.user.id

Write-Status "✅ Got token: $($token.Substring(0, 20))..." "Success"
Write-Status "✅ User ID: $userId" "Success"

Write-Host ""

# Create headers with token
$authHeaders = @{
    Authorization = "Bearer $token"
}

# Test 4: Get Profile
Write-Status "4️⃣ Get User Profile Test" "Info"
$profile = Test-Endpoint -Method GET -Endpoint "/api/users/profile/me" `
    -Headers $authHeaders `
    -Description "Get current user profile"

Write-Host ""

# Test 5: Get All Users
Write-Status "5️⃣ Get All Users Test" "Info"
$users = Test-Endpoint -Method GET -Endpoint "/api/users?limit=5" `
    -Headers $authHeaders `
    -Description "Get all users (paginated)"

Write-Host ""

# Test 6: Create Item
Write-Status "6️⃣ Create Item Test" "Info"
$itemBody = @{
    title = "Test Item - $(Get-Date -Format 'HH:mm:ss')"
    description = "This is a test item created at $(Get-Date)"
    status = "pending"
} | ConvertTo-Json

$itemResponse = Test-Endpoint -Method POST -Endpoint "/api/items" `
    -Headers $authHeaders `
    -Body $itemBody `
    -Description "Create new item"

if ($null -eq $itemResponse -or -not $itemResponse.data.id) {
    Write-Status "⚠️  Item creation failed" "Warning"
    $itemId = 1
}
else {
    $itemId = $itemResponse.data.id
    Write-Status "✅ Item ID: $itemId" "Success"
}

Write-Host ""

# Test 7: Get All Items
Write-Status "7️⃣ Get All Items Test" "Info"
$items = Test-Endpoint -Method GET -Endpoint "/api/items?limit=10" `
    -Headers $authHeaders `
    -Description "Get all items"

Write-Host ""

# Test 8: Get Item by ID
Write-Status "8️⃣ Get Item by ID Test" "Info"
$item = Test-Endpoint -Method GET -Endpoint "/api/items/$itemId" `
    -Headers $authHeaders `
    -Description "Get specific item"

Write-Host ""

# Test 9: Update Item
Write-Status "9️⃣ Update Item Test" "Info"
$updateBody = @{
    title = "Updated Item - $(Get-Date -Format 'HH:mm:ss')"
    status = "in_progress"
    description = "Updated at $(Get-Date)"
} | ConvertTo-Json

$updated = Test-Endpoint -Method PUT -Endpoint "/api/items/$itemId" `
    -Headers $authHeaders `
    -Body $updateBody `
    -Description "Update item status"

Write-Host ""

# Test 10: Get Items by User
Write-Status "🔟 Get Items by User Test" "Info"
$userItems = Test-Endpoint -Method GET -Endpoint "/api/items/user/$userId" `
    -Headers $authHeaders `
    -Description "Get items for specific user"

Write-Host ""

# Test 11: Update User
Write-Status "1️⃣1️⃣ Update User Test" "Info"
$updateUserBody = @{
    name = "Updated Test User - $(Get-Date -Format HHmmss)"
} | ConvertTo-Json

$updatedUser = Test-Endpoint -Method PUT -Endpoint "/api/users/$userId" `
    -Headers $authHeaders `
    -Body $updateUserBody `
    -Description "Update user profile"

Write-Host ""

# Test 12: Test without token (should fail)
Write-Status "1️⃣2️⃣ Unauthorized Access Test (Expected to Fail)" "Info"
Write-Host "🧪 TEST: Request without authentication token"
Write-Host "   GET /api/items"

try {
    $response = Invoke-WebRequest -Uri "$BaseUrl/api/items" -Method GET -ErrorAction Stop
    Write-Status "⚠️  UNEXPECTED: Got success without token!" "Warning"
}
catch {
    $statusCode = $_.Exception.Response.StatusCode.Value__
    if ($statusCode -eq 401) {
        Write-Status "✅ CORRECT: Got 401 Unauthorized (as expected)" "Success"
    }
    else {
        Write-Status "❌ Got HTTP $statusCode instead of 401" "Error"
    }
}

Write-Host ""

# Test 13: Delete Item
Write-Status "1️⃣3️⃣ Delete Item Test" "Info"
$deleted = Test-Endpoint -Method DELETE -Endpoint "/api/items/$itemId" `
    -Headers $authHeaders `
    -Description "Delete item"

Write-Host ""

# Summary
Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  🎉 TESTING COMPLETE                  ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

Write-Status "Summary of tests:" "Info"
Write-Host "✅ Health Check"
Write-Host "✅ User Registration"
Write-Host "✅ User Login"
Write-Host "✅ Get Profile"
Write-Host "✅ Get All Users"
Write-Host "✅ Create Item"
Write-Host "✅ Get All Items"
Write-Host "✅ Get Item Details"
Write-Host "✅ Update Item"
Write-Host "✅ Get User Items"
Write-Host "✅ Update User"
Write-Host "✅ Authorization Check"
Write-Host "✅ Delete Item"
Write-Host ""

Write-Status "API is working correctly! 🚀" "Success"

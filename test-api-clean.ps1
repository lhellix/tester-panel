# PowerShell API Test Suite
param([string]$BaseUrl = "http://localhost:3000")

$success = 0
$failed = 0

function Test-API {
    param([string]$Name, [string]$Method, [string]$Endpoint, [hashtable]$Headers, [string]$Body)
    
    Write-Host ""
    Write-Host "[$($success + $failed + 1)] $Name" -ForegroundColor Cyan
    Write-Host "$Method $Endpoint" -ForegroundColor Gray
    
    try {
        $params = @{
            Uri = "$BaseUrl$Endpoint"
            Method = $Method
            UseBasicParsing = $true
        }
        if ($Headers) { $params["Headers"] = $Headers }
        if ($Body) { 
            $params["Body"] = $Body
            $params["ContentType"] = "application/json"
        }
        
        $response = Invoke-WebRequest @params -ErrorAction Stop
        Write-Host "[OK] HTTP $($response.StatusCode)" -ForegroundColor Green
        $content = $response.Content | ConvertFrom-Json
        return $content
    }
    catch {
        $code = $_.Exception.Response.StatusCode.Value__
        Write-Host "[FAIL] HTTP $code" -ForegroundColor Red
        return $null
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "API Testing Suite                      " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. Health Check
$health = Test-API "Health Check" GET "/api/health"
if ($health) { $success++ } else { $failed++ }

# 2. Register
$registerBody = @{
    email = "test$(Get-Random)@example.com"
    password = "TestPass123!"
    name = "Test User"
} | ConvertTo-Json

$register = Test-API "Register User" POST "/api/auth/register" @{} $registerBody
if ($register -and $register.token) { $success++; $token = $register.token; $email = $register.user.email } else { $failed++; $token = "" }

# 3. Login
$loginBody = @{ email = $email; password = "TestPass123!" } | ConvertTo-Json
$login = Test-API "Login" POST "/api/auth/login" @{} $loginBody
if ($login -and $login.token) { $success++; $token = $login.token; $userId = $login.user.id } else { $failed++ }

# 4. Get Profile
$profile = Test-API "Get Profile" GET "/api/users/profile/me" @{"Authorization" = "Bearer $token"}
if ($profile) { $success++ } else { $failed++ }

# 5. Get All Users
$users = Test-API "Get All Users" GET "/api/users" @{"Authorization" = "Bearer $token"}
if ($users) { $success++ } else { $failed++ }

# 6. Create Item
$itemBody = @{
    title = "Test Item $(Get-Random)"
    description = "Test Description"
    status = "pending"
} | ConvertTo-Json

$item = Test-API "Create Item" POST "/api/items" @{"Authorization" = "Bearer $token"} $itemBody
if ($item -and $item.data.id) { $success++; $itemId = $item.data.id } else { $failed++; $itemId = 1 }

# 7. Get All Items
$items = Test-API "Get All Items" GET "/api/items" @{"Authorization" = "Bearer $token"}
if ($items) { $success++ } else { $failed++ }

# 8. Get Item
$getItem = Test-API "Get Item by ID" GET "/api/items/$itemId" @{"Authorization" = "Bearer $token"}
if ($getItem) { $success++ } else { $failed++ }

# 9. Update Item
$updateBody = @{
    title = "Updated Item"
    status = "in_progress"
} | ConvertTo-Json

$update = Test-API "Update Item" PUT "/api/items/$itemId" @{"Authorization" = "Bearer $token"} $updateBody
if ($update) { $success++ } else { $failed++ }

# 10. Get User Items
$userItems = Test-API "Get User Items" GET "/api/items/user/$userId" @{"Authorization" = "Bearer $token"}
if ($userItems) { $success++ } else { $failed++ }

# 11. Unauthorized Test
Write-Host ""
Write-Host "[11] Unauthorized Access (should fail)" -ForegroundColor Cyan
Write-Host "GET /api/items" -ForegroundColor Gray
try {
    $unauth = Invoke-WebRequest "$BaseUrl/api/items" -Method GET -UseBasicParsing -ErrorAction Stop
    Write-Host "[FAIL] Should have been 401" -ForegroundColor Red
    $failed++
} catch {
    if ($_.Exception.Response.StatusCode.Value__ -eq 401) {
        Write-Host "[OK] HTTP 401 (Correct)" -ForegroundColor Green
        $success++
    } else {
        Write-Host "[FAIL] Got $($_.Exception.Response.StatusCode.Value__)" -ForegroundColor Red
        $failed++
    }
}

# 12. Delete Item
$delete = Test-API "Delete Item" DELETE "/api/items/$itemId" @{"Authorization" = "Bearer $token"}
if ($delete) { $success++ } else { $failed++ }

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Test Results" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Passed:  $success" -ForegroundColor Green
Write-Host "Failed:  $failed" -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Red" })
Write-Host ""

if ($failed -eq 0) {
    Write-Host "All tests passed! API is working correctly." -ForegroundColor Green
} else {
    Write-Host "Some tests failed. Check the details above." -ForegroundColor Yellow
}

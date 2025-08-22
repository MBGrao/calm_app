# Comprehensive Authentication Test Suite
$baseUrl = "http://localhost:3000/api/v1"

Write-Host "=== CALM APP AUTHENTICATION TEST SUITE ===" -ForegroundColor Green
Write-Host ""

# Test 1: Valid Registration
Write-Host "Test 1: Valid Registration" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/auth/signup" -Method POST -ContentType "application/json" -Body '{"email":"testuser@example.com","password":"password123","confirmPassword":"password123","firstName":"Test","lastName":"User"}'
    Write-Host "✅ Registration successful: $($response.StatusCode)" -ForegroundColor Green
    $responseData = $response.Content | ConvertFrom-Json
    Write-Host "   Access Token: $($responseData.accessToken.Substring(0,20))..." -ForegroundColor Gray
} catch {
    Write-Host "❌ Registration failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 2: Duplicate Email Registration
Write-Host "Test 2: Duplicate Email Registration" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/auth/signup" -Method POST -ContentType "application/json" -Body '{"email":"testuser@example.com","password":"password123","confirmPassword":"password123","firstName":"Test","lastName":"User"}'
    Write-Host "❌ Should have failed with duplicate email" -ForegroundColor Red
} catch {
    $errorResponse = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorResponse)
    $errorContent = $reader.ReadToEnd() | ConvertFrom-Json
    if ($errorContent.statusCode -eq 409) {
        Write-Host "✅ Correctly rejected duplicate email: $($errorContent.message)" -ForegroundColor Green
    } else {
        Write-Host "❌ Unexpected error: $($errorContent.message)" -ForegroundColor Red
    }
}

Write-Host ""

# Test 3: Password Mismatch
Write-Host "Test 3: Password Mismatch" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/auth/signup" -Method POST -ContentType "application/json" -Body '{"email":"test2@example.com","password":"password123","confirmPassword":"different","firstName":"Test","lastName":"User"}'
    Write-Host "❌ Should have failed with password mismatch" -ForegroundColor Red
} catch {
    $errorResponse = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorResponse)
    $errorContent = $reader.ReadToEnd() | ConvertFrom-Json
    if ($errorContent.statusCode -eq 400) {
        Write-Host "✅ Correctly rejected password mismatch: $($errorContent.message)" -ForegroundColor Green
    } else {
        Write-Host "❌ Unexpected error: $($errorContent.message)" -ForegroundColor Red
    }
}

Write-Host ""

# Test 4: Invalid Email Format
Write-Host "Test 4: Invalid Email Format" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/auth/signup" -Method POST -ContentType "application/json" -Body '{"email":"invalid-email","password":"password123","confirmPassword":"password123","firstName":"Test","lastName":"User"}'
    Write-Host "❌ Should have failed with invalid email" -ForegroundColor Red
} catch {
    $errorResponse = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorResponse)
    $errorContent = $reader.ReadToEnd() | ConvertFrom-Json
    Write-Host "✅ Correctly rejected invalid email: $($errorContent.message)" -ForegroundColor Green
}

Write-Host ""

# Test 5: Missing Required Fields
Write-Host "Test 5: Missing Required Fields" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/auth/signup" -Method POST -ContentType "application/json" -Body '{"email":"test3@example.com","password":"password123"}'
    Write-Host "❌ Should have failed with missing fields" -ForegroundColor Red
} catch {
    $errorResponse = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorResponse)
    $errorContent = $reader.ReadToEnd() | ConvertFrom-Json
    Write-Host "✅ Correctly rejected missing fields: $($errorContent.message)" -ForegroundColor Green
}

Write-Host ""

# Test 6: Valid Login
Write-Host "Test 6: Valid Login" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/auth/signin" -Method POST -ContentType "application/json" -Body '{"email":"testuser@example.com","password":"password123"}'
    Write-Host "✅ Login successful: $($response.StatusCode)" -ForegroundColor Green
    $responseData = $response.Content | ConvertFrom-Json
    Write-Host "   Access Token: $($responseData.accessToken.Substring(0,20))..." -ForegroundColor Gray
    $accessToken = $responseData.accessToken
} catch {
    Write-Host "❌ Login failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 7: Invalid Login Credentials
Write-Host "Test 7: Invalid Login Credentials" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/auth/signin" -Method POST -ContentType "application/json" -Body '{"email":"testuser@example.com","password":"wrongpassword"}'
    Write-Host "❌ Should have failed with wrong password" -ForegroundColor Red
} catch {
    $errorResponse = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorResponse)
    $errorContent = $reader.ReadToEnd() | ConvertFrom-Json
    if ($errorContent.statusCode -eq 401) {
        Write-Host "✅ Correctly rejected wrong password: $($errorContent.message)" -ForegroundColor Green
    } else {
        Write-Host "❌ Unexpected error: $($errorContent.message)" -ForegroundColor Red
    }
}

Write-Host ""

# Test 8: Non-existent User Login
Write-Host "Test 8: Non-existent User Login" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/auth/signin" -Method POST -ContentType "application/json" -Body '{"email":"nonexistent@example.com","password":"password123"}'
    Write-Host "❌ Should have failed with non-existent user" -ForegroundColor Red
} catch {
    $errorResponse = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorResponse)
    $errorContent = $reader.ReadToEnd() | ConvertFrom-Json
    if ($errorContent.statusCode -eq 401) {
        Write-Host "✅ Correctly rejected non-existent user: $($errorContent.message)" -ForegroundColor Green
    } else {
        Write-Host "❌ Unexpected error: $($errorContent.message)" -ForegroundColor Red
    }
}

Write-Host ""

# Test 9: Get Current User (if login was successful)
if ($accessToken) {
    Write-Host "Test 9: Get Current User" -ForegroundColor Yellow
    try {
        $response = Invoke-WebRequest -Uri "$baseUrl/auth/me" -Method GET -Headers @{"Authorization"="Bearer $accessToken"}
        Write-Host "✅ Get current user successful: $($response.StatusCode)" -ForegroundColor Green
        $responseData = $response.Content | ConvertFrom-Json
        Write-Host "   User: $($responseData.user.email)" -ForegroundColor Gray
    } catch {
        Write-Host "❌ Get current user failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""

# Test 10: Logout
if ($accessToken) {
    Write-Host "Test 10: Logout" -ForegroundColor Yellow
    try {
        $response = Invoke-WebRequest -Uri "$baseUrl/auth/logout" -Method POST -Headers @{"Authorization"="Bearer $accessToken"}
        Write-Host "✅ Logout successful: $($response.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Logout failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=== TEST SUITE COMPLETED ===" -ForegroundColor Green 
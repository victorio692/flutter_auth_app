<?php

use App\Http\Controllers\AuthController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Public routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// CORS preflight routes (harus public)
Route::options('/register', function () {
    return response()->json();
});
Route::options('/login', function () {
    return response()->json();
});

// Test route (public)
Route::get('/test', function () {
    return response()->json(['message' => 'CORS working!']);
});

// Protected routes (require authentication)
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);
});
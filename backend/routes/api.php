<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\{
    AuthController, KotaController, KategoriController,
    TempatWisataController, FavoritController
};

// ------------------------
// ROUTE TANPA TOKEN (Publik)
// ------------------------
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// ------------------------
// ROUTE DENGAN TOKEN (auth:sanctum)
// ------------------------
Route::middleware(['auth:sanctum'])->group(function () {

    // === AUTH ===
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    // === KOTA ===
    Route::get('/kota', [KotaController::class, 'index']);     // lihat semua kota
    Route::get('/kota/{id}', [KotaController::class, 'show']); // lihat detail kota
    Route::post('/kota', [KotaController::class, 'store']);    // tambah kota
    Route::put('/kota/{id}', [KotaController::class, 'update']); // ubah kota
    Route::delete('/kota/{id}', [KotaController::class, 'destroy']); // hapus kota

    // === KATEGORI ===
    Route::get('/kategori', [KategoriController::class, 'index']);
    Route::get('/kategori/{id}', [KategoriController::class, 'show']);
    Route::post('/kategori', [KategoriController::class, 'store']);
    Route::put('/kategori/{id}', [KategoriController::class, 'update']);
    Route::delete('/kategori/{id}', [KategoriController::class, 'destroy']);

    // === TEMPAT WISATA ===
    Route::get('/wisata', [TempatWisataController::class, 'index']);
    Route::get('/wisata/{id}', [TempatWisataController::class, 'show']);
    Route::post('/wisata', [TempatWisataController::class, 'store']);
    Route::put('/wisata/{id}', [TempatWisataController::class, 'update']);
    Route::delete('/wisata/{id}', [TempatWisataController::class, 'destroy']);

    // === FAVORIT ===
    Route::get('/favorit', [FavoritController::class, 'index']); // lihat semua favorit milik user
    Route::post('/favorit', [FavoritController::class, 'store']); // tambah ke favorit
    Route::delete('/favorit/{id_wisata}', [FavoritController::class, 'destroy']); // hapus favorit
});

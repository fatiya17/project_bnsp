<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Favorit;
use Illuminate\Support\Facades\Validator;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use App\Models\TempatWisata;

class FavoritController extends BaseController
{
    /**
     * Menampilkan semua favorit milik user yang sedang login
     */
    public function index()
    {
        /** @var \App\Models\User $user */ // <-- PERBAIKAN 1 (Untuk Editor)
        $user = Auth::user();
        $favorit = $user->favoritWisata()->with(['kota', 'kategori'])->get(); 

        return $this->sendSuccess('Data favorit berhasil diambil.', $favorit);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Menambahkan Favorit baru (Simpan ke Favorit)
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'tempat_wisata_id' => 'required|integer|exists:tempat_wisata,id',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validasi Gagal.', $validator->errors(), 422);
        }

        /** @var \App\Models\User $user */ // <-- PERBAIKAN 2 (Untuk Editor)
        $user = Auth::user();

        // syncWithoutDetaching mencegah duplikat jika sudah ada
        $user->favoritWisata()->syncWithoutDetaching($request->tempat_wisata_id); 

        return $this->sendSuccess('Berhasil ditambahkan ke favorit.', null, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Menghapus Favorit
     */
    public function destroy($id_wisata)
    {
        // Validasi apakah $id_wisata ada
        if (!TempatWisata::find($id_wisata)) {
            return $this->sendError('Tempat wisata tidak ditemukan.', null, 404);
        }

        /** @var \App\Models\User $user */ // <-- PERBAIKAN 3 (Untuk Editor)
        $user = Auth::user();

        // detach akan menghapus relasi di tabel pivot
        $user->favoritWisata()->detach($id_wisata); 

        return $this->sendSuccess('Berhasil dihapus dari favorit.');
    }
}

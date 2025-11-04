<?php

namespace App\Http\Controllers;

use App\Models\TempatWisata;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class TempatWisataController extends BaseController
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = TempatWisata::with(['kota', 'kategori']);

        // "Tampilkan data wisata berdasarkan kota yang dipilih"
        if ($request->has('kota_id')) {
            $validator = Validator::make($request->only('kota_id'), [
                'kota_id' => 'integer|exists:kota,id'
            ]);

            if ($validator->fails()) {
                return $this->sendError('Filter kota_id tidak valid.', $validator->errors(), 422);
            }

            $query->where('kota_id', $request->kota_id);
        }

        $wisata = $query->get();
        return $this->sendSuccess('Data tempat wisata berhasil diambil.', $wisata);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama_wisata' => 'required|string|max:45',
            'deskripsi'   => 'nullable|string',
            'alamat'      => 'nullable|string|max:255',
            'url_gambar'  => 'nullable|url|max:255',
            'kota_id'     => 'required|integer|exists:kota,id',
            'kategori_id' => 'required|integer|exists:kategori,id',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validasi Gagal.', $validator->errors(), 422);
        }

        $wisata = TempatWisata::create($validator->validated());
        $wisata->load(['kota', 'kategori']); // Muat relasi untuk response
        return $this->sendSuccess('Tempat wisata berhasil ditambahkan.', $wisata, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(TempatWisata $tempatWisata)
    {
        $tempatWisata->load(['kota', 'kategori']);
        return $this->sendSuccess('Detail tempat wisata berhasil diambil.', $tempatWisata);
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
    public function update(Request $request, TempatWisata $tempatWisata)
    {
        $validator = Validator::make($request->all(), [
            'nama_wisata' => 'sometimes|required|string|max:45',
            'deskripsi'   => 'nullable|string',
            'alamat'      => 'nullable|string|max:255',
            'url_gambar'  => 'nullable|url|max:255',
            'kota_id'     => 'sometimes|required|integer|exists:kota,id',
            'kategori_id' => 'sometimes|required|integer|exists:kategori,id',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validasi Gagal.', $validator->errors(), 422);
        }

        $tempatWisata->update($validator->validated());
        $tempatWisata->load(['kota', 'kategori']);
        return $this->sendSuccess('Tempat wisata berhasil diperbarui.', $tempatWisata);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(TempatWisata $tempatWisata)
    {
        // Opsional: Hapus dulu dari favorit semua user
        $tempatWisata->disukaiOleh()->detach();

        $tempatWisata->delete();
        return $this->sendSuccess('Tempat wisata berhasil dihapus.');
    }
}

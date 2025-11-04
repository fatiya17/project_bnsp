<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Kategori;
use Illuminate\Support\Facades\Validator;

class KategoriController extends BaseController
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $kategori = Kategori::all();
        return $this->sendSuccess('Data kategori berhasil diambil', $kategori);
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
            'nama_kategori' => 'required|string|max:45|unique:kategori,nama_kategori',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validasi Gagal.', $validator->errors(), 422);
        }

        $kategori = Kategori::create($validator->validated());
        return $this->sendSuccess('Kategori berhasil ditambahkan.', $kategori, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Kategori $kategori)
    {
        return $this->sendSuccess('Detail kategori berhasil diambil.', $kategori);
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
    public function update(Request $request, Kategori $kategori)
    {
        $validator = Validator::make($request->all(), [
            'nama_kategori' => 'required|string|max:45|unique:kategori,nama_kategori,' . $kategori->id . ',id',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validasi Gagal.', $validator->errors(), 422);
        }

        $kategori->update($validator->validated());
        return $this->sendSuccess('Kategori berhasil diperbarui.', $kategori);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Kategori $kategori)
    {
        if ($kategori->tempatWisata()->exists()) {
            return $this->sendError('Kategori tidak bisa dihapus karena memiliki tempat wisata terkait.', null, 409);
        }

        $kategori->delete();
        return $this->sendSuccess('Kategori berhasil dihapus.');
    }
}

<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Kota;
use Illuminate\Support\Facades\Validator;

class KotaController extends BaseController
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $kota = Kota::all();
        return $this->sendSuccess('Data kota berhasil diambil', $kota);
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
            'nama_kota' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validasi Gagal.', $validator->errors(), 422);
        }

        Kota::create([
            'nama_kota' => $request->nama_kota,
        ]);
        return $this->sendSuccess('Kota berhasil ditambahkan.', null, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Kota $kota)
    {
        return $this->sendSuccess('Detail kota berhasil diambil.', $kota);
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
    public function update(Request $request, Kota $kota)
    {
        $validator = Validator::make($request->all(), [
            'nama_kota' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validasi Gagal.', $validator->errors(), 422);
        }

        Kota::create([
            'nama_kota' => $request->nama_kota,
        ]);
        return $this->sendSuccess('Kota berhasil diperbarui.', null, 201);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}

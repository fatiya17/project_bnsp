<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use App\Models\Kota;
use App\Models\Kategori;

class TempatWisata extends Model
{
    use HasFactory;

    protected $table = 'tempat_wisata';

    protected $fillable = [
        'nama_wisata',
        'deskripsi',
        'alamat',
        'url_gambar',
        'kota_id',
        'kategori_id',
    ];

    public $timestamps = false; 

    public function kota()
    {
        // Baris ini sekarang akan berfungsi
        return $this->belongsTo(Kota::class, 'kota_id', 'id');
    }

    public function kategori()
    {
        // Baris ini sekarang akan berfungsi
        return $this->belongsTo(Kategori::class, 'kategori_id', 'id');
    }

    /**
     * User yang mem-favoritkan tempat wisata ini.
     */
    public function disukaiOleh()
    {
        return $this->belongsToMany(User::class, 'favorit', 'tempat_wisata_id', 'users_id');
    }
}
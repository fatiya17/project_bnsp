<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Favorit extends Model
{
    use HasFactory;

    protected $table = 'favorit';
    protected $fillable = ['users_id', 'tempat_wisata_id'];
    public $timestamps = false;

    /**
     * Relasi ke User (atau Pengguna)
     */
    public function user()
    {
        return $this->belongsTo(User::class, 'users_id');
        // return $this->belongsTo(Pengguna::class, 'users_id');
    }

    /**
     * Relasi ke Tempat Wisata
     */
    public function tempatWisata()
    {
        return $this->belongsTo(TempatWisata::class, 'tempat_wisata_id');
    }
}
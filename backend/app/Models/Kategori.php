<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Kategori extends Model
{
    use HasFactory;

    protected $table = 'kategori';
    protected $fillable = ['nama_kategori'];
    
    public $timestamps = false; 

    public function tempatWisata()
    {
        return $this->hasMany(TempatWisata::class, 'kategori_id', 'id');
    }
}

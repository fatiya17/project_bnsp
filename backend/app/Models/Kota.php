<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Kota extends Model
{
    use HasFactory;

    protected $table = 'kota';
    protected $fillable = ['nama_kota'];
    
    public $timestamps = false; 

    public function tempatWisata()
    {
        return $this->hasMany(TempatWisata::class, 'kota_id', 'id');
    }
}

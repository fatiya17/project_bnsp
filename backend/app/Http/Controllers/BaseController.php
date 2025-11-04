<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Resources\ApiResource;
use Illuminate\Http\JsonResponse;

class BaseController extends Controller
{
    /**
     * Kirim response sukses.
     *
     * @param string $message
     * @param mixed $data
     * @param int $code
     * @return ApiResource
     */
    public function sendSuccess(string $message, $data = null, int $code = 200)
    {
        // set status code di response, ApiResource akan membungkus datanya
        return (new ApiResource(true, $message, $data))->response()->setStatusCode($code);
    }

    /**
     * Kirim response error.
     *
     * @param string $message
     * @param mixed $errorData
     * @param int $code
     * @return JsonResponse
     */
    public function sendError(string $message, $errorData = null, int $code = 400)
    {
        // Menggunakan ApiResource untuk format error
        return (new ApiResource(false, $message, $errorData))->response()->setStatusCode($code);
    }
}

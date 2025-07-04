<?php

use App\Http\Controllers\Api\ProductController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// Public API routes
Route::prefix('v1')->group(function () {
    // Products API
    Route::apiResource('products', ProductController::class);
    
    // Categories API
    Route::get('categories', function () {
        $categories = \App\Models\Category::with('children')->whereNull('parent_id')->get();
        return response()->json([
            'success' => true,
            'message' => 'Categories retrieved successfully',
            'data' => $categories
        ]);
    });
    
    // Single category with products
    Route::get('categories/{category}', function (\App\Models\Category $category) {
        $category->load(['products' => function ($query) {
            $query->where('is_active', true);
        }]);
        
        return response()->json([
            'success' => true,
            'message' => 'Category retrieved successfully',
            'data' => $category
        ]);
    });
    
    // Search products
    Route::get('search/products', function (Request $request) {
        $query = $request->get('q');
        $products = \App\Models\Product::where('name', 'like', "%{$query}%")
            ->orWhere('description', 'like', "%{$query}%")
            ->where('is_active', true)
            ->with('category')
            ->paginate(10);
            
        return response()->json([
            'success' => true,
            'message' => 'Search results retrieved successfully',
            'data' => $products
        ]);
    });
    
    // Featured products
    Route::get('products/featured', function () {
        $products = \App\Models\Product::where('is_featured', true)
            ->where('is_active', true)
            ->with('category')
            ->take(8)
            ->get();
            
        return response()->json([
            'success' => true,
            'message' => 'Featured products retrieved successfully',
            'data' => $products
        ]);
    });
    
    // Products by category
    Route::get('categories/{category}/products', function (\App\Models\Category $category) {
        $products = $category->products()
            ->where('is_active', true)
            ->with('category')
            ->paginate(10);
            
        return response()->json([
            'success' => true,
            'message' => 'Category products retrieved successfully',
            'data' => $products
        ]);
    });
});

// Admin API routes (protected)
Route::middleware(['auth:sanctum', 'admin'])->prefix('v1/admin')->group(function () {
    // Admin product management
    Route::apiResource('products', ProductController::class)->except(['index', 'show']);
    
    // Admin statistics
    Route::get('stats', function () {
        return response()->json([
            'success' => true,
            'data' => [
                'total_products' => \App\Models\Product::count(),
                'total_categories' => \App\Models\Category::count(),
                'total_orders' => \App\Models\Order::count(),
                'total_users' => \App\Models\User::count(),
                'recent_orders' => \App\Models\Order::with('user')->latest()->take(5)->get(),
                'low_stock_products' => \App\Models\Product::where('stock_quantity', '<', 10)->get()
            ]
        ]);
    });
});

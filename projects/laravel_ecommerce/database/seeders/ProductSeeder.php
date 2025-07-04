<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Product;
use App\Models\Category;

class ProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $smartphones = Category::where('slug', 'smartphones')->first();
        $laptops = Category::where('slug', 'laptops')->first();
        $clothing = Category::where('slug', 'clothing')->first();
        $books = Category::where('slug', 'books')->first();

        $products = [
            [
                'name' => 'iPhone 15 Pro',
                'description' => 'Latest iPhone with advanced features',
                'slug' => 'iphone-15-pro',
                'sku' => 'IP15PRO001',
                'price' => 999.99,
                'sale_price' => 899.99,
                'stock_quantity' => 50,
                'category_id' => $smartphones->id,
                'is_active' => true,
                'is_featured' => true,
                'weight' => 0.2,
                'dimensions' => '146.6 x 70.6 x 7.65 mm',
            ],
            [
                'name' => 'Samsung Galaxy S24',
                'description' => 'Premium Android smartphone',
                'slug' => 'samsung-galaxy-s24',
                'sku' => 'SGS24001',
                'price' => 849.99,
                'stock_quantity' => 30,
                'category_id' => $smartphones->id,
                'is_active' => true,
                'is_featured' => true,
                'weight' => 0.18,
                'dimensions' => '147 x 70.6 x 7.6 mm',
            ],
            [
                'name' => 'MacBook Pro 16"',
                'description' => 'Professional laptop for creative work',
                'slug' => 'macbook-pro-16',
                'sku' => 'MBP16001',
                'price' => 2499.99,
                'stock_quantity' => 20,
                'category_id' => $laptops->id,
                'is_active' => true,
                'is_featured' => true,
                'weight' => 2.1,
                'dimensions' => '355.7 x 248.1 x 16.8 mm',
            ],
            [
                'name' => 'Classic T-Shirt',
                'description' => 'Comfortable cotton t-shirt',
                'slug' => 'classic-t-shirt',
                'sku' => 'CTS001',
                'price' => 29.99,
                'sale_price' => 19.99,
                'stock_quantity' => 100,
                'category_id' => $clothing->id,
                'is_active' => true,
                'is_featured' => false,
                'weight' => 0.2,
            ],
            [
                'name' => 'Programming Book',
                'description' => 'Learn programming fundamentals',
                'slug' => 'programming-book',
                'sku' => 'PB001',
                'price' => 49.99,
                'stock_quantity' => 75,
                'category_id' => $books->id,
                'is_active' => true,
                'is_featured' => false,
                'weight' => 0.5,
            ],
        ];

        foreach ($products as $product) {
            Product::create($product);
        }
    }
}

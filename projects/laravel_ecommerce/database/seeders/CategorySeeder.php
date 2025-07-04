<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Category;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            [
                'name' => 'Electronics',
                'description' => 'Electronic devices and gadgets',
                'slug' => 'electronics',
                'is_active' => true,
                'sort_order' => 1,
            ],
            [
                'name' => 'Clothing',
                'description' => 'Fashion and apparel',
                'slug' => 'clothing',
                'is_active' => true,
                'sort_order' => 2,
            ],
            [
                'name' => 'Books',
                'description' => 'Books and literature',
                'slug' => 'books',
                'is_active' => true,
                'sort_order' => 3,
            ],
            [
                'name' => 'Home & Garden',
                'description' => 'Home improvement and garden supplies',
                'slug' => 'home-garden',
                'is_active' => true,
                'sort_order' => 4,
            ],
            [
                'name' => 'Sports',
                'description' => 'Sports equipment and accessories',
                'slug' => 'sports',
                'is_active' => true,
                'sort_order' => 5,
            ],
        ];

        foreach ($categories as $category) {
            Category::create($category);
        }

        // Create subcategories
        $electronics = Category::where('slug', 'electronics')->first();
        $subcategories = [
            [
                'name' => 'Smartphones',
                'description' => 'Mobile phones and accessories',
                'slug' => 'smartphones',
                'parent_id' => $electronics->id,
                'is_active' => true,
                'sort_order' => 1,
            ],
            [
                'name' => 'Laptops',
                'description' => 'Portable computers',
                'slug' => 'laptops',
                'parent_id' => $electronics->id,
                'is_active' => true,
                'sort_order' => 2,
            ],
        ];

        foreach ($subcategories as $subcategory) {
            Category::create($subcategory);
        }
    }
}

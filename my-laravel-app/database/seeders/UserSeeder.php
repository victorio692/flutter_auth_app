<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run()
    {
        // Hapus user yang sudah ada jika perlu
        User::where('email', 'test@example.com')->delete();

        // Buat user test
        User::create([
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => Hash::make('password123'),
        ]);

        $this->command->info('Test user created: test@example.com / password123');
    }
}
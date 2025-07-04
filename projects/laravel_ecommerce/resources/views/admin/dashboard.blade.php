@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <h4>{{ __('Admin Dashboard') }}</h4>
                </div>

                <div class="card-body">
                    <div class="alert alert-success" role="alert">
                        {{ __('Welcome to Admin Panel!') }}
                        <strong>{{ Auth::user()->name }}</strong>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <div class="card bg-primary text-white">
                                <div class="card-body">
                                    <h5>Total Products</h5>
                                    <h2>{{ $stats['total_products'] }}</h2>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card bg-success text-white">
                                <div class="card-body">
                                    <h5>Total Categories</h5>
                                    <h2>{{ $stats['total_categories'] }}</h2>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card bg-warning text-white">
                                <div class="card-body">
                                    <h5>Total Orders</h5>
                                    <h2>{{ $stats['total_orders'] }}</h2>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card bg-info text-white">
                                <div class="card-body">
                                    <h5>Total Users</h5>
                                    <h2>{{ $stats['total_users'] }}</h2>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row mt-4">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h5>Recent Products</h5>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-sm">
                                            <thead>
                                                <tr>
                                                    <th>Name</th>
                                                    <th>Price</th>
                                                    <th>Stock</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                @foreach($recent_products as $product)
                                                <tr>
                                                    <td>{{ $product->name }}</td>
                                                    <td>${{ number_format($product->price, 2) }}</td>
                                                    <td>{{ $product->stock_quantity }}</td>
                                                </tr>
                                                @endforeach
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h5>Recent Orders</h5>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-sm">
                                            <thead>
                                                <tr>
                                                    <th>Order #</th>
                                                    <th>Customer</th>
                                                    <th>Total</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                @foreach($recent_orders as $order)
                                                <tr>
                                                    <td>{{ $order->order_number }}</td>
                                                    <td>{{ $order->user->name ?? 'Guest' }}</td>
                                                    <td>${{ number_format($order->total_amount, 2) }}</td>
                                                    <td>
                                                        <span class="badge badge-{{ $order->status == 'completed' ? 'success' : ($order->status == 'pending' ? 'warning' : 'secondary') }}">
                                                            {{ ucfirst($order->status) }}
                                                        </span>
                                                    </td>
                                                </tr>
                                                @endforeach
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row mt-4">
                        <div class="col-md-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5>Quick Actions</h5>
                                </div>
                                <div class="card-body">
                                    <div class="btn-group" role="group">
                                        <a href="#" class="btn btn-primary">Manage Products</a>
                                        <a href="#" class="btn btn-success">Manage Categories</a>
                                        <a href="#" class="btn btn-warning">View Orders</a>
                                        <a href="#" class="btn btn-info">Manage Users</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

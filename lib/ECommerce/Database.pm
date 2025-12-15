package ECommerce::Database;

# Database Module
# Handles database initialization, connections, and schema creation
# Supports both PostgreSQL (production) and SQLite (local development)

use strict;
use warnings;
use utf8;
use DBI;
use File::Path qw(make_path);
use File::Basename;
use ECommerce::Config;

sub new {
    my $class = shift;
    my $self = {
        db_path => $ECommerce::Config::DB_PATH,
        db_type => $ENV{DATABASE_URL} ? 'postgres' : 'sqlite',
    };
    return bless $self, $class;
}

sub connect {
    my $self = shift;
    
    my $dbh;
    
    if ($self->{db_type} eq 'postgres') {
        # PostgreSQL connection (for production - Render)
        my $database_url = $ENV{DATABASE_URL} or die "DATABASE_URL environment variable not set";
        
        $dbh = DBI->connect(
            $database_url,
            undef, undef,
            {
                RaiseError => 1,
                AutoCommit => 1,
                pg_enable_utf8 => 1,
            }
        ) or die "Cannot connect to PostgreSQL database: $DBI::errstr";
    } else {
        # SQLite connection (for local development)
        my $dir = dirname($self->{db_path});
        make_path($dir) unless -d $dir;
        
        $dbh = DBI->connect(
            "dbi:SQLite:dbname=$self->{db_path}",
            "", "",
            {
                RaiseError => 1,
                AutoCommit => 1,
                sqlite_unicode => 1,
            }
        ) or die "Cannot connect to SQLite database: $DBI::errstr";
    }
    
    return $dbh;
}

sub initialize_database {
    my $self = shift;
    
    my $dbh = $self->connect();
    
    # Enable foreign keys for SQLite
    if ($self->{db_type} eq 'sqlite') {
        $dbh->do("PRAGMA foreign_keys = ON");
    }
    
    # Create tables
    $self->create_tables($dbh);
    
    # Check if we need to populate sample data
    my $count = $dbh->selectrow_array("SELECT COUNT(*) FROM users");
    if ($count == 0) {
        $self->create_sample_data($dbh);
        print "Database initialized with sample data.\n";
    }
    
    $dbh->disconnect();
}

sub create_tables {
    my ($self, $dbh) = @_;
    
    my $is_postgres = $self->{db_type} eq 'postgres';
    
    # Define column types based on database
    my ($serial, $integer, $text, $real, $timestamp);
    if ($is_postgres) {
        $serial = 'SERIAL PRIMARY KEY';
        $integer = 'INTEGER';
        $text = 'TEXT';
        $real = 'NUMERIC(10,2)';
        $timestamp = 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP';
    } else {
        $serial = 'INTEGER PRIMARY KEY AUTOINCREMENT';
        $integer = 'INTEGER';
        $text = 'TEXT';
        $real = 'REAL';
        $timestamp = 'TEXT DEFAULT CURRENT_TIMESTAMP';
    }
    
    # Users table
    $dbh->do(qq{
        CREATE TABLE IF NOT EXISTS users (
            id $serial,
            username $text UNIQUE NOT NULL,
            email $text UNIQUE NOT NULL,
            password_hash $text NOT NULL,
            role $text NOT NULL DEFAULT 'customer',
            created_at $timestamp,
            last_login $text,
            is_active $integer DEFAULT 1
        )
    });
    
    # Customers table
    $dbh->do(qq{
        CREATE TABLE IF NOT EXISTS customers (
            id $serial,
            user_id $integer UNIQUE,
            first_name $text NOT NULL,
            last_name $text NOT NULL,
            phone $text,
            address $text,
            city $text,
            state $text,
            zip_code $text,
            country $text DEFAULT 'USA',
            created_at $timestamp,
            FOREIGN KEY (user_id) REFERENCES users(id)
        )
    });
    
    # Products table
    $dbh->do(qq{
        CREATE TABLE IF NOT EXISTS products (
            id $serial,
            name $text NOT NULL,
            description $text,
            sku $text UNIQUE NOT NULL,
            category $text NOT NULL,
            price $real NOT NULL,
            cost $real,
            stock_quantity $integer DEFAULT 0,
            reorder_level $integer DEFAULT 10,
            image_url $text,
            is_active $integer DEFAULT 1,
            created_at $timestamp,
            updated_at $timestamp
        )
    });
    
    # Orders table
    $dbh->do(qq{
        CREATE TABLE IF NOT EXISTS orders (
            id $serial,
            order_number $text UNIQUE NOT NULL,
            customer_id $integer NOT NULL,
            status $text DEFAULT 'pending',
            subtotal $real NOT NULL,
            tax $real DEFAULT 0,
            shipping $real DEFAULT 0,
            total $real NOT NULL,
            payment_method $text,
            payment_status $text DEFAULT 'pending',
            shipping_address $text,
            billing_address $text,
            notes $text,
            created_at $timestamp,
            updated_at $timestamp,
            FOREIGN KEY (customer_id) REFERENCES customers(id)
        )
    });
    
    # Order items table
    $dbh->do(qq{
        CREATE TABLE IF NOT EXISTS order_items (
            id $serial,
            order_id $integer NOT NULL,
            product_id $integer NOT NULL,
            product_name $text NOT NULL,
            product_sku $text NOT NULL,
            quantity $integer NOT NULL,
            unit_price $real NOT NULL,
            subtotal $real NOT NULL,
            FOREIGN KEY (order_id) REFERENCES orders(id),
            FOREIGN KEY (product_id) REFERENCES products(id)
        )
    });
    
    # Inventory transactions table
    $dbh->do(qq{
        CREATE TABLE IF NOT EXISTS inventory_transactions (
            id $serial,
            product_id $integer NOT NULL,
            quantity_change $integer NOT NULL,
            transaction_type $text NOT NULL,
            reference_id $integer,
            notes $text,
            created_at $timestamp,
            FOREIGN KEY (product_id) REFERENCES products(id)
        )
    });
}

sub create_sample_data {
    my ($self, $dbh) = @_;
    
    use Crypt::Bcrypt qw(bcrypt);
    use Digest::SHA qw(sha256);
    
    # Create default users
    my @users = (
        {username => 'admin', email => 'admin@example.com', password => 'admin123', role => 'admin'},
        {username => 'staff', email => 'staff@example.com', password => 'staff123', role => 'staff'},
        {username => 'customer', email => 'customer@example.com', password => 'customer123', role => 'customer'},
    );
    
    foreach my $user (@users) {
        # Generate a random salt
        my $salt = join('', map { chr(int(rand(256))) } 1..16);
        my $password_hash = bcrypt($user->{password}, '2b', 10, $salt);
        $dbh->do(
            "INSERT INTO users (username, email, password_hash, role) VALUES (?, ?, ?, ?)",
            undef,
            $user->{username}, $user->{email}, $password_hash, $user->{role}
        );
    }
    
    # Create sample customers
    my @customers = (
        {user_id => 3, first_name => 'John', last_name => 'Doe', phone => '555-0101', 
         address => '123 Main St', city => 'New York', state => 'NY', zip_code => '10001'},
        {user_id => undef, first_name => 'Jane', last_name => 'Smith', phone => '555-0102',
         address => '456 Oak Ave', city => 'Los Angeles', state => 'CA', zip_code => '90001'},
        {user_id => undef, first_name => 'Bob', last_name => 'Johnson', phone => '555-0103',
         address => '789 Pine Rd', city => 'Chicago', state => 'IL', zip_code => '60601'},
        {user_id => undef, first_name => 'Alice', last_name => 'Williams', phone => '555-0104',
         address => '321 Elm St', city => 'Houston', state => 'TX', zip_code => '77001'},
        {user_id => undef, first_name => 'Charlie', last_name => 'Brown', phone => '555-0105',
         address => '654 Maple Dr', city => 'Phoenix', state => 'AZ', zip_code => '85001'},
    );
    
    foreach my $customer (@customers) {
        $dbh->do(
            "INSERT INTO customers (user_id, first_name, last_name, phone, address, city, state, zip_code) 
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            undef,
            $customer->{user_id}, $customer->{first_name}, $customer->{last_name}, $customer->{phone},
            $customer->{address}, $customer->{city}, $customer->{state}, $customer->{zip_code}
        );
    }
    
    # Create sample products
    my @products = (
        {name => 'Laptop Pro 15"', description => 'High-performance laptop', sku => 'ELEC001', 
         category => 'Electronics', price => 1299.99, cost => 800.00, stock => 25},
        {name => 'Wireless Mouse', description => 'Ergonomic wireless mouse', sku => 'ELEC002',
         category => 'Electronics', price => 29.99, cost => 15.00, stock => 100},
        {name => 'Mechanical Keyboard', description => 'RGB mechanical keyboard', sku => 'ELEC003',
         category => 'Electronics', price => 89.99, cost => 45.00, stock => 50},
        {name => 'USB-C Hub', description => '7-in-1 USB-C hub', sku => 'ELEC004',
         category => 'Electronics', price => 49.99, cost => 25.00, stock => 75},
        {name => 'Webcam HD', description => '1080p HD webcam', sku => 'ELEC005',
         category => 'Electronics', price => 79.99, cost => 40.00, stock => 40},
        {name => 'T-Shirt Classic', description => 'Cotton t-shirt', sku => 'CLTH001',
         category => 'Clothing', price => 19.99, cost => 8.00, stock => 200},
        {name => 'Jeans Denim', description => 'Classic denim jeans', sku => 'CLTH002',
         category => 'Clothing', price => 59.99, cost => 30.00, stock => 150},
        {name => 'Hoodie Comfort', description => 'Comfortable hoodie', sku => 'CLTH003',
         category => 'Clothing', price => 45.99, cost => 22.00, stock => 80},
        {name => 'Programming Book', description => 'Learn Perl programming', sku => 'BOOK001',
         category => 'Books', price => 39.99, cost => 20.00, stock => 30},
        {name => 'Cookbook Deluxe', description => 'Professional cookbook', sku => 'BOOK002',
         category => 'Books', price => 29.99, cost => 15.00, stock => 45},
        {name => 'Coffee Maker', description => 'Automatic coffee maker', sku => 'HOME001',
         category => 'Home', price => 89.99, cost => 50.00, stock => 35},
        {name => 'Blender Pro', description => 'High-speed blender', sku => 'HOME002',
         category => 'Home', price => 69.99, cost => 35.00, stock => 40},
        {name => 'Yoga Mat', description => 'Non-slip yoga mat', sku => 'SPRT001',
         category => 'Sports', price => 24.99, cost => 12.00, stock => 60},
        {name => 'Dumbbells Set', description => '10kg dumbbell set', sku => 'SPRT002',
         category => 'Sports', price => 49.99, cost => 25.00, stock => 30},
        {name => 'Board Game Classic', description => 'Family board game', sku => 'TOYS001',
         category => 'Toys', price => 34.99, cost => 18.00, stock => 50},
        {name => 'Puzzle 1000pc', description => '1000-piece puzzle', sku => 'TOYS002',
         category => 'Toys', price => 19.99, cost => 10.00, stock => 70},
        {name => 'Shampoo Premium', description => 'Professional shampoo', sku => 'BEAU001',
         category => 'Beauty', price => 14.99, cost => 7.00, stock => 120},
        {name => 'Face Cream', description => 'Moisturizing face cream', sku => 'BEAU002',
         category => 'Beauty', price => 24.99, cost => 12.00, stock => 90},
        {name => 'Car Phone Mount', description => 'Universal phone mount', sku => 'AUTO001',
         category => 'Automotive', price => 15.99, cost => 8.00, stock => 100},
        {name => 'Tire Pressure Gauge', description => 'Digital tire gauge', sku => 'AUTO002',
         category => 'Automotive', price => 12.99, cost => 6.00, stock => 85},
    );
    
    foreach my $product (@products) {
        $dbh->do(
            "INSERT INTO products (name, description, sku, category, price, cost, stock_quantity) 
             VALUES (?, ?, ?, ?, ?, ?, ?)",
            undef,
            $product->{name}, $product->{description}, $product->{sku}, $product->{category},
            $product->{price}, $product->{cost}, $product->{stock}
        );
    }
}

1;

__END__

=head1 NAME

ECommerce::Database - Database management module

=head1 SYNOPSIS

    use ECommerce::Database;
    
    my $db = ECommerce::Database->new();
    $db->initialize_database();
    
    my $dbh = $db->connect();

=head1 DESCRIPTION

This module handles all database operations including initialization,
schema creation, and sample data generation.

=head1 METHODS

=head2 new()

Creates a new Database object.

=head2 connect()

Establishes and returns a database connection.

=head2 initialize_database()

Initializes the database with tables and sample data if needed.

=head2 create_tables($dbh)

Creates all required database tables.

=head2 create_sample_data($dbh)

Populates database with sample users, customers, and products.

=head1 AUTHOR

E-Commerce System Team

=cut

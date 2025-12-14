# System Architecture

## E-Commerce Order Processing System - Perl

---

## Table of Contents

- [Overview](#overview)
- [Architecture Pattern](#architecture-pattern)
- [Technology Stack](#technology-stack)
- [System Components](#system-components)
- [Request Flow](#request-flow)
- [Database Schema](#database-schema)
- [Security Architecture](#security-architecture)
- [File Organization](#file-organization)
- [Design Patterns](#design-patterns)

---

## Overview

This is a full-stack e-commerce system built with **Perl** using the **Mojolicious web framework**. The system follows the **MVC (Model-View-Controller)** architecture pattern with clear separation of concerns, role-based access control, and secure authentication.

### Key Features

- ✅ Clean MVC architecture
- ✅ Role-based access control (Admin/Staff/Customer)
- ✅ RESTful routing
- ✅ Session management
- ✅ SQLite embedded database
- ✅ Bcrypt password hashing
- ✅ Server-side rendering with embedded Perl templates
- ✅ Modular CSS architecture
- ✅ AJAX support for cart operations

---

## Architecture Pattern

### MVC Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                     Browser (Client)                     │
└───────────────────────┬─────────────────────────────────┘
                        │ HTTP Request
                        ▼
┌─────────────────────────────────────────────────────────┐
│               Mojolicious Application                    │
│                      (app.pl)                            │
│  ┌──────────────────────────────────────────────────┐  │
│  │   Routes (routes/*.pl)                            │  │
│  │   - shared_routes.pl (login, dashboard)          │  │
│  │   - admin_routes.pl (admin/staff only)           │  │
│  │   - customer_routes.pl (customer only)           │  │
│  └──────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────┐  │
│  │   Helpers (app.pl)                                │  │
│  │   - is_logged_in, current_user, has_role         │  │
│  │   - get_cart, add_to_cart, clear_cart            │  │
│  └──────────────────────────────────────────────────┘  │
└───────────────────────┬─────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────┐
│              Controllers (lib/ECommerce/Controllers/)    │
│  ┌─────────────────────────────────────────────────┐   │
│  │  Auth.pm - Login, Registration, Authorization   │   │
│  └─────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────┐   │
│  │  Admin/ - Admin Controllers                      │   │
│  │    - DashboardController.pm                      │   │
│  │    - ProductController.pm                        │   │
│  │    - OrderController.pm                          │   │
│  │    - CustomerController.pm                       │   │
│  │    - ReportController.pm                         │   │
│  └─────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────┐   │
│  │  Customer/ - Customer Controllers                │   │
│  │    - DashboardController.pm                      │   │
│  │    - ProductController.pm                        │   │
│  │    - CartController.pm                           │   │
│  │    - OrderController.pm                          │   │
│  │    - AccountController.pm                        │   │
│  └─────────────────────────────────────────────────┘   │
└───────────────────────┬─────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────┐
│              Models (lib/ECommerce/Models/)              │
│  ┌──────────────┐  ┌───────────────┐  ┌─────────────┐ │
│  │   User.pm    │  │  Product.pm   │  │  Order.pm   │ │
│  │ - login      │  │ - CRUD ops    │  │ - create    │ │
│  │ - register   │  │ - search      │  │ - update    │ │
│  │ - auth       │  │ - inventory   │  │ - track     │ │
│  └──────────────┘  └───────────────┘  └─────────────┘ │
│  ┌──────────────┐                                       │
│  │ Customer.pm  │                                       │
│  │ - profile    │                                       │
│  │ - CRUD       │                                       │
│  └──────────────┘                                       │
└───────────────────────┬─────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────┐
│           Database Layer (lib/ECommerce/Database.pm)     │
│  - Connection management (DBI)                           │
│  - Schema initialization                                 │
│  - Sample data generation                                │
└───────────────────────┬─────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────┐
│                 SQLite Database                          │
│                (data/ecommerce.db)                       │
│  Tables: users, customers, products, orders,             │
│          order_items, inventory_transactions             │
└─────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│            Views (templates/*.html.ep)                   │
│  ┌──────────────────────────────────────────────────┐  │
│  │  layouts/ - Page layouts                          │  │
│  │    - default.html.ep (main layout)               │  │
│  │    - auth.html.ep (login/register layout)        │  │
│  └──────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────┐  │
│  │  admin/ - Admin views                             │  │
│  │  customer/ - Customer views                       │  │
│  └──────────────────────────────────────────────────┘  │
└───────────────────────┬─────────────────────────────────┘
                        │ HTML Response
                        ▼
┌─────────────────────────────────────────────────────────┐
│                     Browser (Client)                     │
└─────────────────────────────────────────────────────────┘
```

---

## Technology Stack

### Backend

| Technology        | Version | Purpose                |
| ----------------- | ------- | ---------------------- |
| **Perl**          | 5.16+   | Core language          |
| **Mojolicious**   | 9.0+    | Web framework          |
| **DBI**           | 1.643+  | Database interface     |
| **DBD::SQLite**   | 1.70+   | SQLite driver          |
| **Crypt::Bcrypt** | 0.011+  | Password hashing       |
| **JSON**          | 4.0+    | JSON encoding/decoding |
| **Time::Piece**   | 1.33+   | Date/time handling     |
| **Dotenv**        | Latest  | Environment variables  |

### Frontend

| Technology               | Purpose                        |
| ------------------------ | ------------------------------ |
| **HTML5**                | Markup                         |
| **CSS3**                 | Styling (modular architecture) |
| **JavaScript (Vanilla)** | Client-side logic, AJAX        |
| **Embedded Perl (EP)**   | Server-side templating         |

### Database

- **SQLite 3** - Embedded relational database

---

## System Components

### 1. Application Layer (`app.pl`)

**Purpose**: Main application entry point and configuration.

**Responsibilities**:

- Initialize Mojolicious app
- Configure sessions (secret key, expiration)
- Load environment variables (.env)
- Initialize database
- Define application helpers
- Load route modules
- Configure Hypnotoad (production server)

**Key Helpers**:

```perl
is_logged_in()          # Check if user has active session
current_user()          # Get current user data
has_role($role)         # Check user role
get_cart()              # Get cart from session
get_cart_count()        # Count cart items
add_to_cart($item)      # Add item to cart
clear_cart()            # Empty cart
format_number($num)     # Format numbers with commas
```

### 2. Routes Layer (`routes/*.pl`)

**Purpose**: Define URL routing and access control.

#### `shared_routes.pl`

- Login (`/`, `/login`)
- Logout (`/logout`)
- Registration (`/register`)
- Dashboard (role-based redirect: `/dashboard`)
- Product listing (`/products`)
- Order viewing (`/orders`, `/orders/:id`)

#### `admin_routes.pl`

- Product management (`/products/add`, `/products/:id/edit`, `/products/:id/delete`)
- Order management (`/orders/:id/update-status`, `/orders/:id/delete`)
- Customer management (`/customers`, `/customers/:id/delete`)
- Reports (`/reports`)

#### `customer_routes.pl`

- Cart (`/cart`, `/cart/add`, `/cart/remove`)
- Checkout (`/checkout`)
- Order cancellation (`/orders/:id/cancel`)
- Account (`/account`, `/account/update`, `/account/delete`)

### 3. Controller Layer (`lib/ECommerce/Controllers/`)

**Purpose**: Handle HTTP requests, coordinate between models and views.

#### Auth Controller (`Auth.pm`)

- `login($username, $password)` - Authenticate user
- `register(...)` - Create new user account
- `is_admin($role)` - Check admin role
- `is_staff($role)` - Check staff role
- `is_customer($role)` - Check customer role

#### Admin Controllers

| Controller              | Responsibilities                   |
| ----------------------- | ---------------------------------- |
| **DashboardController** | Show metrics, statistics, charts   |
| **ProductController**   | CRUD operations, inventory, search |
| **OrderController**     | View orders, update status, delete |
| **CustomerController**  | View customers, manage accounts    |
| **ReportController**    | Generate sales/inventory reports   |

#### Customer Controllers

| Controller              | Responsibilities                    |
| ----------------------- | ----------------------------------- |
| **DashboardController** | Show order history, recommendations |
| **ProductController**   | Browse catalog, search, filter      |
| **CartController**      | Add/remove items, view cart         |
| **OrderController**     | Checkout, view orders, cancel       |
| **AccountController**   | Update profile, manage account      |

### 4. Model Layer (`lib/ECommerce/Models/)

**Purpose**: Data access and business logic.

#### User Model (`User.pm`)

```perl
create_user($username, $email, $password, $role)
get_user_by_username($username)
get_user_by_id($user_id)
verify_password($username, $password)
update_last_login($user_id)
get_all_users()
update_user_role($user_id, $new_role)
deactivate_user($user_id)
```

#### Product Model (`Product.pm`)

```perl
create_product(%params)
get_all_products($active_only)
get_product_by_id($product_id)
get_product_by_sku($sku)
update_product($product_id, %params)
delete_product($product_id)
update_stock($product_id, $quantity_change)
search_products($query)
get_products_by_category($category)
get_categories()
get_low_stock_products()
```

#### Order Model (`Order.pm`)

```perl
create_order(%params)
create_order_from_cart($customer_id, $cart, $params)
get_all_orders()
get_order_by_id($order_id)
get_orders_by_customer($customer_id)
update_order_status($order_id, $status)
cancel_order($order_id)
get_order_items($order_id)
```

#### Customer Model (`Customer.pm`)

```perl
create_customer(%params)
get_customer_by_id($customer_id)
get_customer_by_user_id($user_id)
get_all_customers()
update_customer($customer_id, %params)
delete_customer($customer_id)
```

### 5. Configuration (`lib/ECommerce/Config.pm`)

**Purpose**: Centralized configuration.

**Settings**:

```perl
$DB_PATH = 'data/ecommerce.db'

%APP_CONFIG = (
    app_name => 'E-Commerce Order Processing System',
    version => '1.0.0',
    currency => 'USD',
    currency_symbol => '$',
    tax_rate => 0.08,  # 8%
    shipping_rate => 5.00,
    free_shipping_threshold => 100.00,
    items_per_page => 20,
)

@ORDER_STATUS = qw(pending processing shipped delivered cancelled refunded)
@PAYMENT_METHODS = qw(credit_card debit_card paypal cash_on_delivery bank_transfer)
@PRODUCT_CATEGORIES = qw(Electronics Clothing Books Home Sports Toys Food Beauty Automotive Other)
@USER_ROLES = qw(admin staff customer)
```

### 6. Database Layer (`lib/ECommerce/Database.pm`)

**Purpose**: Database management and initialization.

**Methods**:

```perl
new()                      # Create database object
connect()                  # Get database connection
initialize_database()      # Setup tables and sample data
create_tables($dbh)        # Create schema
create_sample_data($dbh)   # Insert default data
```

---

## Database Schema

### Entity Relationship Diagram

```
┌─────────────┐         ┌──────────────┐
│    users    │◄────────│   customers  │
│             │ 1     1 │              │
│ - id (PK)   │         │ - id (PK)    │
│ - username  │         │ - user_id(FK)│
│ - email     │         │ - first_name │
│ - password  │         │ - last_name  │
│ - role      │         │ - phone      │
└─────────────┘         │ - address    │
                        └──────┬───────┘
                               │
                             1 │
                               │
                        ┌──────▼───────┐
                        │    orders    │
                        │              │
                        │ - id (PK)    │
                        │ - order_num  │
                        │ - customer_id│
                        │ - status     │
                        │ - total      │
                        └──────┬───────┘
                               │
                             1 │
                               │ *
                        ┌──────▼────────┐
                        │  order_items  │
                        │               │
                        │ - id (PK)     │
                        │ - order_id(FK)│
                        │ - product_id  │
                        │ - quantity    │
                        │ - unit_price  │
                        └───────┬───────┘
                                │
                              * │
                                │ 1
                        ┌───────▼──────┐
                        │   products   │
                        │              │
                        │ - id (PK)    │
                        │ - name       │
                        │ - sku        │
                        │ - price      │
                        │ - stock_qty  │
                        └──────────────┘
```

### Tables

#### 1. users

**Purpose**: User authentication and role management

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'customer',
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    last_login TEXT,
    is_active INTEGER DEFAULT 1
);
```

**Fields**:

- `id`: Unique user identifier
- `username`: Unique username (login)
- `email`: Unique email address
- `password_hash`: Bcrypt hashed password
- `role`: User role (admin/staff/customer)
- `created_at`: Account creation timestamp
- `last_login`: Last successful login
- `is_active`: Account status (1=active, 0=deactivated)

#### 2. customers

**Purpose**: Customer profile and contact information

```sql
CREATE TABLE customers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER UNIQUE,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    phone TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT,
    country TEXT DEFAULT 'USA',
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

**Fields**:

- `id`: Unique customer identifier
- `user_id`: Link to users table (optional, can be NULL for guest customers)
- `first_name`, `last_name`: Customer name
- `phone`: Contact number
- `address`, `city`, `state`, `zip_code`, `country`: Shipping/billing address
- `created_at`: Profile creation timestamp

#### 3. products

**Purpose**: Product catalog and inventory

```sql
CREATE TABLE products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    sku TEXT UNIQUE NOT NULL,
    category TEXT NOT NULL,
    price REAL NOT NULL,
    cost REAL,
    stock_quantity INTEGER DEFAULT 0,
    reorder_level INTEGER DEFAULT 10,
    image_url TEXT,
    is_active INTEGER DEFAULT 1,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```

**Fields**:

- `id`: Unique product identifier
- `name`: Product name
- `description`: Product description
- `sku`: Stock Keeping Unit (unique identifier)
- `category`: Product category
- `price`: Selling price
- `cost`: Cost price (for profit calculation)
- `stock_quantity`: Current inventory level
- `reorder_level`: Minimum stock before reorder alert
- `image_url`: Product image path
- `is_active`: Product availability (1=active, 0=discontinued)
- `created_at`, `updated_at`: Timestamps

#### 4. orders

**Purpose**: Order records and tracking

```sql
CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_number TEXT UNIQUE NOT NULL,
    customer_id INTEGER NOT NULL,
    status TEXT DEFAULT 'pending',
    subtotal REAL NOT NULL,
    tax REAL DEFAULT 0,
    shipping REAL DEFAULT 0,
    total REAL NOT NULL,
    payment_method TEXT,
    payment_status TEXT DEFAULT 'pending',
    shipping_address TEXT,
    billing_address TEXT,
    notes TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);
```

**Fields**:

- `id`: Unique order identifier
- `order_number`: Human-readable order number (ORD-YYYYMMDD-XXXXX)
- `customer_id`: Link to customers table
- `status`: Order status (pending/processing/shipped/delivered/cancelled/refunded)
- `subtotal`, `tax`, `shipping`, `total`: Order amounts
- `payment_method`: Payment type (credit_card/debit_card/paypal/etc.)
- `payment_status`: Payment state
- `shipping_address`, `billing_address`: Delivery information
- `notes`: Special instructions
- `created_at`, `updated_at`: Timestamps

#### 5. order_items

**Purpose**: Individual items in each order

````sql
CREATE TABLE order_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    product_name TEXT NOT NULL,
    product_sku TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price REAL NOT NULL,

```sql
CREATE TABLE products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    sku TEXT UNIQUE NOT NULL,
    category TEXT NOT NULL,
    price REAL NOT NULL,
    cost REAL,
    stock_quantity INTEGER DEFAULT 0,
    reorder_level INTEGER DEFAULT 10,
    image_url TEXT,
    is_active INTEGER DEFAULT 1,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);
````

### Orders Table

```sql
CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_number TEXT UNIQUE NOT NULL,
    customer_id INTEGER NOT NULL,
    status TEXT DEFAULT 'pending',
    subtotal REAL NOT NULL,
    tax REAL DEFAULT 0,
    shipping REAL DEFAULT 0,
    total REAL NOT NULL,
    payment_method TEXT,
    payment_status TEXT DEFAULT 'pending',
    shipping_address TEXT,
    billing_address TEXT,
    notes TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);
```

### Order Items Table

```sql
CREATE TABLE order_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    product_name TEXT NOT NULL,
    product_sku TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price REAL NOT NULL,
    subtotal REAL NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);
```

**Fields**:

- `id`: Unique item identifier
- `order_id`: Link to orders table
- `product_id`: Link to products table
- `product_name`, `product_sku`: Snapshot of product info at time of order
- `quantity`: Number of units ordered
- `unit_price`: Price per unit at time of order
- `subtotal`: quantity × unit_price

#### 6. inventory_transactions

**Purpose**: Audit trail for inventory changes

```sql
CREATE TABLE inventory_transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    quantity_change INTEGER NOT NULL,
    transaction_type TEXT NOT NULL,
    reference_id INTEGER,
    notes TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id)
);
```

**Fields**:

- `id`: Unique transaction identifier
- `product_id`: Link to products table
- `quantity_change`: Change in stock (positive=increase, negative=decrease)
- `transaction_type`: Type of transaction (sale/restock/adjustment/return)
- `reference_id`: Related record ID (order_id for sales)
- `notes`: Additional information
- `created_at`: Transaction timestamp

### Database Relationships

```
users (1) ←→ (1) customers
customers (1) ←→ (*) orders
orders (1) ←→ (*) order_items
products (1) ←→ (*) order_items
products (1) ←→ (*) inventory_transactions
```

### Indexes

Foreign keys are automatically indexed by SQLite. Additional indexes recommended for:

- `users.username` (unique)
- `users.email` (unique)
- `products.sku` (unique)
- `orders.order_number` (unique)
- `orders.status` (for filtering)
- `products.category` (for filtering)

---

## Request Flow

### Complete Request Lifecycle

1. **Client Request** → Browser sends HTTP request to `http://localhost:3000/products`

2. **Mojolicious Routing** → Routes request to appropriate handler

   ```perl
   $app->routes->get('/products' => sub { ... })
   ```

3. **Authentication Check** → Verify user session

   ```perl
   return $c->redirect_to('/') unless $c->is_logged_in;
   ```

4. **Authorization Check** → Verify role permissions

   ```perl
   return $c->redirect_to('/dashboard') if $c->has_role('customer');
   ```

5. **Controller Processing** → Execute business logic

   ```perl
   my $products = $product_model->get_all_products();
   ```

6. **Model Operation** → Query database

   ```perl
   my $dbh = $self->{db}->connect();
   my $sth = $dbh->prepare("SELECT * FROM products WHERE is_active = 1");
   $sth->execute();
   ```

7. **Data Processing** → Format and prepare data

   ```perl
   $c->stash(products => $products);
   ```

8. **View Rendering** → Generate HTML from template

   ```perl
   $c->render(template => 'admin/products_admin');
   ```

9. **Response** → Send HTML to client with appropriate headers

### Example: Add to Cart Flow

```
[Browser]
   │
   │ POST /cart/add
   │ product_id=5, quantity=2
   │
   ▼
[app.pl Router]
   │
   │ Route: /cart/add
   │
   ▼
[CartController]
   │
   │ 1. Validate product_id and quantity
   │ 2. Get product from database
   │ 3. Check stock availability
   │ 4. Add to session cart
   │ 5. Return JSON (if AJAX) or redirect
   │
   ▼
[ProductModel]
   │
   │ get_product_by_id($product_id)
   │ Query: SELECT * FROM products WHERE id = ?
   │
   ▼
[Database]
   │
   │ Return product data
   │
   ▼
[Session]
   │
   │ Update cart array:
   │ cart => [{product_id => 5, quantity => 2, ...}]
   │
   ▼
[Response]
   │
   │ JSON: {success: 1, cart_count: 3}
   │ or Redirect: /cart with flash message
   │
   ▼
[Browser]
   │
   │ Update cart badge (AJAX)
   │ or Display flash message
```

---

## Security Architecture

```sql
CREATE TABLE inventory_transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    quantity_change INTEGER NOT NULL,
    transaction_type TEXT NOT NULL,
    reference_id INTEGER,
    notes TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id)
);
```

## Data Flow

### Order Placement Flow

1. **Customer adds product to cart**

   - Session stores cart items
   - Quantity validated against stock

   Implementation notes:

   - Add-to-Cart is implemented to support both traditional POSTs and AJAX: when the client submits with `X-Requested-With: XMLHttpRequest` the Cart controller returns JSON (for example `{ success => 1, product_name => 'Name', cart_count => 3 }`) and does not set the server-side flash; non-AJAX submissions fall back to setting flash and redirecting.

   - The session cart is stored as an arrayref of item hashrefs. Each item may include `product_id`, `product_name`, `quantity`, `unit_price`, and `image_url`. Older cart entries are enriched with `image_url` when the cart is viewed so templates can render images with a `public/images/placeholder.svg` fallback.

2. **Customer views cart**

   - Calculate subtotal
   - Apply tax (8%)
   - Calculate shipping ($5 or FREE over $100)
   - Display total

3. **Customer checks out**

   - Validate cart items
   - Check stock availability
   - Create order record
   - Create order items
   - Update inventory
   - Record inventory transactions
   - Clear cart

4. **Order confirmation**
   - Generate order number
   - Display order details
   - Send to order history

## Security Architecture

### Authentication

- Bcrypt password hashing (cost: 10)
- Session-based authentication
- Secure session cookies
- Login/logout functionality

### Authorization

- Role-based access control (RBAC)
- Three roles: admin, staff, customer
- Route protection
- View-level permissions

### Data Protection

- Prepared SQL statements
- Input validation
- XSS prevention via templating
- CSRF protection (Mojolicious built-in)

### Session Management

- Server-side sessions
- Configurable expiration (1 hour default)
- Secure session storage
- Session invalidation on logout

## Request Flow

1. **Client Request** → Browser sends HTTP request
2. **Routing** → Mojolicious routes to handler
3. **Authentication Check** → Verify session
4. **Authorization Check** → Verify role permissions
5. **Controller** → Process business logic
6. **Model** → Database operations
7. **View** → Render template
8. **Response** → Send HTML to client

## Component Interaction

```
┌─────────────┐
│   Browser   │
└──────┬──────┘
       │
       ↓
┌─────────────┐
│   app.pl    │ ← Routes & Helpers
└──────┬──────┘
       │
       ↓
┌─────────────┐
│ Controllers │ ← Auth.pm
└──────┬──────┘
       │
       ↓
┌─────────────┐
│   Models    │ ← User, Product, Order, Customer
└──────┬──────┘
       │
       ↓
┌─────────────┐
│  Database   │ ← SQLite
└─────────────┘
```

## Design Patterns

### 1. MVC Pattern

- **Model**: Data and business logic
- **View**: Presentation layer
- **Controller**: Request handling

### 2. Repository Pattern

- Models act as repositories
- Encapsulate data access
- Abstract database operations

### 3. Singleton Pattern

- Database connections
- Configuration settings

### 4. Session State Pattern

- Shopping cart
- User authentication
- Temporary data storage

## Performance Considerations

### Database Optimization

- Indexed foreign keys
- Prepared statements
- Transaction management
- Connection pooling

### Caching Strategy

- Session-based cart caching
- Template compilation caching

### Scalability

- Hypnotoad multi-worker support
- Stateless request handling
- Horizontal scaling capability

## Configuration Management

### Development

```perl
perl app.pl daemon
```

### Production

```perl
hypnotoad app.pl
```

### Settings

- Tax rate: 8%
- Shipping: $5.00 (FREE over $100)
- Session timeout: 1 hour
- Workers: 4 (production)

## Error Handling

### Application Level

- Try/catch blocks
- Graceful degradation
- User-friendly error messages

### Database Level

- Transaction rollback
- Constraint validation
- Foreign key enforcement

### View Level

- Flash messages
- Inline validation
- Error alerts

## Monitoring & Logging

### Access Logs

- Request tracking
- Response times
- Error logging

### Application Logs

- Database operations
- Authentication events
- Business logic errors

## Deployment Architecture

### Single Server

```
┌──────────────────┐
│   Web Browser    │
└────────┬─────────┘
         │
    HTTP Request
         │
         ↓
┌──────────────────┐
│   Hypnotoad      │ (4 workers)
│   (Port 3000)    │
└────────┬─────────┘
         │
         ↓
┌──────────────────┐
│  SQLite Database │
│  (ecommerce.db)  │
└──────────────────┘

### Static assets and client behavior

- Static assets (CSS, JS, images) are served from `public/`. The project includes component CSS (for modal/toast styles) in `public/css/components/` and small client-side scripts in `public/js/` to handle the responsive hamburger menu, toast positioning, and AJAX form interception.
- Server-rendered flash messages remain in the layout for non-AJAX flows; AJAX Add-to-Cart uses the client-side toast for user feedback.
```

### Reverse Proxy (Production)

```
┌──────────────────┐
│   Web Browser    │
└────────┬─────────┘
         │
         ↓
┌──────────────────┐
│  Nginx/Apache    │ (Port 80/443)
└────────┬─────────┘
         │
         ↓
┌──────────────────┐
│   Hypnotoad      │ (Port 3000)
└────────┬─────────┘
         │
         ↓
┌──────────────────┐
│  SQLite Database │
└──────────────────┘
```

## Testing Strategy

### Unit Testing

- Model methods
- Controller logic
- Utility functions

### Integration Testing

- Route handlers
- Database operations
- Session management

### System Testing

- End-to-end workflows
- User scenarios
- Performance testing

## Maintenance

### Database Backup

```bash
cp data/ecommerce.db data/ecommerce.db.backup
```

### Log Rotation

- Configure system log rotation
- Archive old logs
- Monitor disk space

### Updates

- Keep dependencies updated
- Test before deploying
- Backup before changes

---

**Architecture Version**: 1.0.0  
**Last Updated**: December 2, 2025

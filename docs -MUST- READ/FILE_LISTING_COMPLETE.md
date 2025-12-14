# Complete File Listing

**E-Commerce Order Processing System - Perl**

A comprehensive reference documenting every file in the project, its purpose, and relationships.

---

## Table of Contents

- [Root Directory](#root-directory)
- [lib/ECommerce](#libecommerce)
- [routes](#routes)
- [templates](#templates)
- [public](#public)
- [data](#data)
- [docs](#docs)

---

## Root Directory

### app.pl (114 lines)

**Purpose**: Main application entry point and configuration

**Description**:

- Initializes Mojolicious Lite application
- Loads environment variables from `.env` file via Dotenv
- Configures session management (secret key, 1-hour expiration)
- Initializes SQLite database on startup
- Defines application helpers for common operations
- Loads route modules (shared, admin, customer)
- Configures Hypnotoad for production deployment

**Key Helpers**:

- `is_logged_in()` - Check if user has active session
- `current_user()` - Get current user information
- `has_role($role)` - Verify user role
- `get_cart()` - Retrieve shopping cart from session
- `get_cart_count()` - Count distinct products in cart
- `add_to_cart($item)` - Add item to session cart
- `clear_cart()` - Empty shopping cart
- `format_number($number)` - Format numbers with commas

**Dependencies**:

- Mojolicious::Lite
- ECommerce::Database
- ECommerce::Config
- Mojo::JSON
- Dotenv

### cpanfile (17 lines)

**Purpose**: Perl dependency declaration

**Description**:
Lists all required CPAN modules with minimum versions. Used by `cpanm --installdeps .` for automatic installation.

**Dependencies Listed**:

- Mojolicious >= 9.0
- DBI >= 1.643
- DBD::SQLite >= 1.70
- Crypt::Bcrypt >= 0.011
- JSON >= 4.0
- Time::Piece >= 1.33
- File::Basename, File::Spec
- Digest::SHA >= 6.0
- MIME::Base64
- Data::Dumper
- List::Util >= 1.50
- Dotenv

### .env (optional file)

**Purpose**: Environment variables configuration

**Description**:
Optional file for production configuration. Not version-controlled.

**Example Contents**:

```env
MOJOLICIOUS_SECRET_KEY=your-secret-key-here
DB_PATH=data/ecommerce.db
```

---

## lib/ECommerce

### Config.pm (123 lines)

**Purpose**: Centralized application configuration

**Description**:
Contains all application settings, constants, and configuration parameters used throughout the system.

**Exports**:

- `$VERSION` - Application version (1.0.0)
- `$BASE_DIR` - Project root directory
- `$DB_PATH` - Database file path (data/ecommerce.db)
- `%APP_CONFIG` - Application settings
  - `app_name`, `version`, `currency`
  - `tax_rate` - 8% sales tax
  - `shipping_rate` - $5.00 flat rate
  - `free_shipping_threshold` - $100.00
  - `items_per_page` - 20 items
- `@ORDER_STATUS` - Valid order statuses (pending, processing, shipped, delivered, cancelled, refunded)
- `@PAYMENT_METHODS` - Payment options (credit_card, debit_card, paypal, cash_on_delivery, bank_transfer)
- `@PRODUCT_CATEGORIES` - Product categories (Electronics, Clothing, Books, etc.)
- `@USER_ROLES` - User roles (admin, staff, customer)
- `%COLORS` - Theme colors (primary, secondary, success, warning, danger, etc.)

**Documentation**: Includes POD documentation

### Database.pm (322 lines)

**Purpose**: Database management and initialization

**Description**:
Handles all database operations including connection management, schema creation, and sample data generation.

**Methods**:

- `new()` - Create database object
- `connect()` - Establish database connection with SQLite
- `initialize_database()` - Setup database on first run
- `create_tables($dbh)` - Create all 6 tables with proper constraints
- `create_sample_data($dbh)` - Insert default users, customers, and products

**Database Tables Created**:

1. `users` - User authentication (id, username, email, password_hash, role, created_at, last_login, is_active)
2. `customers` - Customer profiles (id, user_id, first_name, last_name, phone, address, city, state, zip_code, country)
3. `products` - Product catalog (id, name, description, sku, category, price, cost, stock_quantity, reorder_level, image_url, is_active)
4. `orders` - Order records (id, order_number, customer_id, status, subtotal, tax, shipping, total, payment_method, shipping_address, notes)
5. `order_items` - Order line items (id, order_id, product_id, product_name, product_sku, quantity, unit_price, subtotal)
6. `inventory_transactions` - Inventory audit trail (id, product_id, quantity_change, transaction_type, reference_id, notes)

**Sample Data Created**:

- 3 default users (admin, staff, customer) with bcrypt-hashed passwords
- 5 sample customers with addresses
- 20 sample products across various categories

**Documentation**: Includes POD documentation

---

## lib/ECommerce/Models

Models handle all database operations and business logic.

### User.pm (210 lines)

**Purpose**: User authentication and account management

**Methods**:

- `new()` - Constructor
- `create_user($username, $email, $password, $role)` - Create new user account
- `get_user_by_username($username)` - Find user by username
- `get_user_by_id($user_id)` - Find user by ID
- `verify_password($username, $password)` - Verify login credentials using bcrypt
- `update_last_login($user_id)` - Update last login timestamp
- `get_all_users()` - List all users (for admin)
- `update_user_role($user_id, $new_role)` - Change user role
- `deactivate_user($user_id)` - Disable user account

**Security**:

- Uses Crypt::Bcrypt with cost factor 10
- Random salt generation for each password
- Handles duplicate username/email gracefully

**Documentation**: POD format

### Customer.pm (195 lines)

**Purpose**: Customer profile management

**Methods**:

- `new()` - Constructor
- `create_customer(%params)` - Create customer profile
- `get_customer_by_id($customer_id)` - Find customer by ID
- `get_customer_by_user_id($user_id)` - Find customer by linked user
- `get_all_customers()` - List all customers
- `update_customer($customer_id, %params)` - Update profile
- `delete_customer($customer_id)` - Soft delete customer
- `get_customer_orders($customer_id)` - Get customer's order history
- `get_customer_stats($customer_id)` - Get customer statistics

**Documentation**: POD format

### Product.pm (329 lines)

**Purpose**: Product catalog and inventory management

**Methods**:

- `new()` - Constructor
- `create_product(%params)` - Add new product
- `get_all_products($active_only)` - List products
- `get_product_by_id($product_id)` - Find by ID
- `get_product_by_sku($sku)` - Find by SKU
- `update_product($product_id, %params)` - Update product
- `delete_product($product_id)` - Soft delete (set is_active=0)
- `update_stock($product_id, $quantity_change)` - Adjust inventory
- `search_products($query)` - Search by name/description
- `get_products_by_category($category)` - Filter by category
- `get_categories()` - List all categories
- `get_low_stock_products()` - Products below reorder level
- `get_out_of_stock_products()` - Products with zero stock

**Features**:

- SKU uniqueness validation
- Stock level tracking
- Inventory transaction logging
- Search and filtering

**Documentation**: POD format

### Order.pm (423 lines)

**Purpose**: Order processing and management

**Methods**:

- `new()` - Constructor
- `generate_order_number()` - Create unique order number (ORD-YYYYMMDD-XXXXX)
- `create_order(%params)` - Create new order
- `create_order_from_cart($customer_id, $cart, $params)` - Convert cart to order
- `get_all_orders()` - List all orders
- `get_order_by_id($order_id)` - Find order by ID
- `get_order_by_number($order_number)` - Find by order number
- `get_orders_by_customer($customer_id)` - Customer's orders
- `get_orders_by_status($status)` - Filter by status
- `update_order_status($order_id, $status)` - Change order status
- `cancel_order($order_id)` - Cancel pending order
- `delete_order($order_id)` - Delete order (admin only)
- `get_order_items($order_id)` - Get order line items
- `calculate_order_totals($cart)` - Calculate subtotal, tax, shipping, total

**Features**:

- Transactional order creation
- Automatic inventory deduction
- Tax calculation (8%)
- Shipping calculation ($5 or FREE over $100)
- Order number generation
- Stock validation

**Documentation**: POD format

---

## lib/ECommerce/Controllers

Controllers handle HTTP requests and coordinate between models and views.

### Auth.pm (153 lines)

**Purpose**: Authentication and authorization

**Methods**:

- `new()` - Constructor
- `login($username, $password)` - Authenticate user
- `register($username, $email, $password, $role, ...)` - Create new account
- `is_admin($role)` - Check if user is admin
- `is_staff($role)` - Check if user is staff or admin
- `is_customer($role)` - Check if user is customer

**Features**:

- Bcrypt password verification
- Session initialization
- User registration with validation
- Automatic customer profile creation for customer role

**Documentation**: POD format

---

## lib/ECommerce/Controllers/Admin

Admin-only controllers (staff and admin access).

### DashboardController.pm (~150 lines)

**Purpose**: Admin dashboard with metrics and analytics

**Features**:

- Total revenue calculation
- Order count by status
- Product statistics
- Low stock alerts
- Recent orders list
- Customer count

### ProductController.pm (220 lines)

**Purpose**: Product management (CRUD operations)

**Methods**:

- `list_products($c)` - Display product list with search/filter
- `show_add_form($c)` - Show add product form
- `create_product($c)` - Handle product creation
- `show_edit_form($c)` - Show edit product form
- `update_product($c)` - Handle product update
- `delete_product($c)` - Soft delete product

**Features**:

- Auto-generate SKU based on category
- Image upload support
- Stock management
- Category filtering
- Search functionality
- Pagination

### OrderController.pm (~180 lines)

**Purpose**: Order management and tracking

**Methods**:

- `list_orders($c)` - Display all orders
- `view_order($c)` - Show order details
- `update_status($c)` - Change order status
- `delete_order($c)` - Delete order (admin only)

**Features**:

- Filter by status
- Search by order number
- View order items
- Update order status
- Order deletion with confirmation

### CustomerController.pm (~140 lines)

**Purpose**: Customer account management

**Methods**:

- `list_customers($c)` - Display customer list
- `view_customer($c)` - Show customer details
- `delete_customer($c)` - Delete customer account

**Features**:

- Search customers
- View order history per customer
- Customer statistics

### ReportController.pm (~200 lines)

**Purpose**: Generate business reports and analytics

**Methods**:

- `show_reports($c)` - Display reports dashboard
- `generate_sales_report()` - Sales summary
- `generate_inventory_report()` - Stock levels
- `generate_customer_report()` - Customer analytics

**Features**:

- Sales by period
- Revenue charts
- Inventory valuation
- Low stock report
- Customer insights

---

## lib/ECommerce/Controllers/Customer

Customer-facing controllers.

### DashboardController.pm (~120 lines)

**Purpose**: Customer dashboard

**Features**:

- Recent orders
- Order status tracking
- Quick links to cart and catalog

### ProductController.pm (~150 lines)

**Purpose**: Product browsing for customers

**Methods**:

- `list_products($c)` - Show product catalog
- `view_product($c)` - Show product details

**Features**:

- Category filtering
- Search products
- Pagination
- Add to cart integration

### CartController.pm (~180 lines)

**Purpose**: Shopping cart management

**Methods**:

- `view_cart($c)` - Display cart contents
- `add_to_cart($c)` - Add product to cart (supports AJAX)
- `remove_from_cart($c)` - Remove item from cart
- `update_quantity($c)` - Change item quantity

**Features**:

- Session-based cart
- AJAX support for add-to-cart
- Real-time cart count updates
- Stock validation
- Cart total calculation

### OrderController.pm (~200 lines)

**Purpose**: Customer order operations

**Methods**:

- `checkout($c)` - Process order from cart
- `view_orders($c)` - Show order history
- `view_order($c)` - Show order details
- `cancel_order($c)` - Cancel pending order

**Features**:

- Checkout process
- Order confirmation
- Order tracking
- Cancel pending orders

### AccountController.pm (~150 lines)

**Purpose**: Customer account management

**Methods**:

- `show_account($c)` - Display account page
- `update_account($c)` - Update profile
- `delete_account($c)` - Delete account

**Features**:

- Update contact information
- Update shipping address
- Change password
- Account deletion

---

## routes

Route definitions separating concerns by user role.

### shared_routes.pl (187 lines)

**Purpose**: Routes accessible by all user roles

**Routes**:

- `GET /` - Login page (or redirect to dashboard if logged in)
- `POST /login` - Handle login
- `GET /logout` - Logout and clear session
- `GET /register` - Registration form
- `POST /register` - Handle registration
- `GET /dashboard` - Role-based dashboard redirect
- `GET /products` - Product listing (role-based view)
- `GET /products/:id` - Product details
- `GET /orders` - Order listing (role-based)
- `GET /orders/:id` - Order details

### admin_routes.pl (98 lines)

**Purpose**: Admin and staff only routes

**Routes**:

- `GET /products/add` - Add product form
- `POST /products/add` - Create product
- `GET /products/:id/edit` - Edit product form
- `POST /products/:id/edit` - Update product
- `POST /products/:id/delete` - Delete product
- `POST /orders/:id/update-status` - Update order status
- `POST /orders/:id/delete` - Delete order
- `GET /customers` - Customer list
- `POST /customers/:id/delete` - Delete customer
- `GET /reports` - Reports dashboard

**Access Control**: Redirects to dashboard if user is customer

### customer_routes.pl (79 lines)

**Purpose**: Customer only routes

**Routes**:

- `GET /cart` - View shopping cart
- `POST /cart/add` - Add to cart
- `POST /cart/remove` - Remove from cart
- `POST /checkout` - Place order
- `POST /orders/:id/cancel` - Cancel order
- `GET /account` - Account page
- `POST /account/update` - Update account
- `POST /account/delete` - Delete account

**Access Control**: Requires login, customer role only

---

## templates

Embedded Perl (EP) templates for server-side rendering.

### layouts

#### default.html.ep (295 lines)

**Purpose**: Main application layout

**Features**:

- Responsive navigation header
- Role-based menu items (admin/customer)
- Cart badge with count
- Flash message display
- Footer
- JavaScript functions:
  - `toggleDropdown()` - Kebab menu handling
  - Sticky header on scroll
  - Dropdown positioning logic

**Includes**:

- All CSS files
- Navigation bar
- Flash alerts
- Footer

#### auth.html.ep

**Purpose**: Minimal layout for login/register pages

**Features**:

- Centered content
- No navigation
- Branding

### admin

Admin panel templates.

#### dashboard_admin.html.ep (~250 lines)

**Purpose**: Admin dashboard

**Features**:

- Metric cards (revenue, orders, products, customers)
- Recent orders table
- Low stock alerts
- Quick action buttons

#### products_admin.html.ep (~200 lines)

**Purpose**: Product management page

**Features**:

- Product table with pagination
- Search and filter
- Sort options (in stock, low stock, out of stock)
- Add/edit/delete actions
- Stock level indicators

#### product_add.html.ep (~150 lines)

**Purpose**: Add new product form

**Fields**:

- Name, description, category
- Price, cost
- Stock quantity, reorder level
- Image URL
- Auto-generated SKU

#### product_edit.html.ep (~150 lines)

**Purpose**: Edit existing product form

**Similar to product_add.html.ep with pre-filled values**

#### orders_admin.html.ep (~180 lines)

**Purpose**: Order management page

**Features**:

- Orders table with filters
- Search by order number
- Sort by status/date
- View/update/delete actions
- Status badges

#### order_detail_admin.html.ep (~200 lines)

**Purpose**: Detailed order view

**Features**:

- Order information
- Customer details
- Order items table
- Status update
- Order actions (update status, delete)

#### customers.html.ep (~150 lines)

**Purpose**: Customer management page

**Features**:

- Customer table
- Search functionality
- View customer details
- Delete customer

#### reports.html.ep (~250 lines)

**Purpose**: Reports and analytics

**Features**:

- Sales reports
- Inventory reports
- Customer reports
- Charts and graphs
- Export options

### customer

Customer-facing templates.

#### dashboard_customer.html.ep (~150 lines)

**Purpose**: Customer dashboard

**Features**:

- Welcome message
- Recent orders
- Quick links
- Order status summary

#### products_customer.html.ep (~180 lines)

**Purpose**: Product catalog for customers

**Features**:

- Product grid/list
- Category filter
- Search
- Add to cart button
- Product images
- Price display

#### cart.html.ep (~200 lines)

**Purpose**: Shopping cart

**Features**:

- Cart items table
- Quantity adjustment
- Remove item button
- Cart summary (subtotal, tax, shipping, total)
- Checkout button
- Continue shopping link

#### orders_customer.html.ep (~150 lines)

**Purpose**: Customer order history

**Features**:

- Orders table
- Order status
- View details link
- Cancel order option (pending only)

#### order_detail_customer.html.ep (~180 lines)

**Purpose**: Customer order details

**Features**:

- Order information
- Shipping address
- Order items
- Order total
- Tracking information
- Cancel order button (if pending)

#### account.html.ep (~200 lines)

**Purpose**: Customer account management

**Features**:

- Profile information form
- Contact details
- Shipping address
- Update button
- Delete account button

#### register.html.ep (~150 lines)

**Purpose**: Customer registration form

**Fields**:

- Username, email, password
- First name, last name
- Phone
- Address
- Registration button

### login.html.ep (~100 lines)

**Purpose**: Login page

**Features**:

- Username/password fields
- Login button
- Link to registration
- Error messages

---

## public

Static assets (CSS, images, JavaScript).

### css

Modular CSS architecture with separate concerns.

#### style.css (50 lines)

**Purpose**: Main stylesheet that imports all others

**Imports** (in order):

1. base/reset.css
2. base/variables.css
3. base/typography.css
4. components/\*.css
5. layout/\*.css
6. pages/\*.css
7. utilities/\*.css

#### base/

##### reset.css (~80 lines)

- CSS reset
- Box-sizing
- Remove default margins/padding

##### variables.css (~50 lines)

- CSS custom properties (colors, spacing, fonts, shadows, transitions, border-radius)

##### typography.css (~60 lines)

- Font definitions
- Heading styles
- Paragraph styles
- Link styles

#### components/

##### alerts.css (~80 lines)

- Alert boxes (success, error, warning, info)
- Flash message styling

##### badges.css (~50 lines)

- Status badges
- Order status colors
- Pill badges

##### buttons.css (~120 lines)

- Button styles
- Primary, secondary, danger buttons
- Button sizes
- Hover/active states

##### cards.css (~250 lines)

- Card containers
- Metric cards (dashboard)
- Card headers
- Card shadows and hover effects

##### dropdown.css (~107 lines)

- Dropdown menus
- Kebab menu styling
- Fixed positioning for dropdowns
- Dropdown animations

##### forms.css (~180 lines)

- Input fields
- Select dropdowns
- Textareas
- Form labels
- Form validation styles
- Search boxes

##### modal.css (~100 lines)

- Modal overlays
- Modal content
- Toast notifications
- Modal animations

##### pagination.css (~70 lines)

- Pagination controls
- Page numbers
- Previous/Next buttons

##### tables.css (~78 lines)

- Table styling
- Table headers
- Row hover effects
- Responsive tables

#### layout/

##### container.css (~40 lines)

- Page containers
- Content wrappers
- Max-width constraints

##### footer.css (~50 lines)

- Footer styling
- Footer content
- Copyright text

##### header.css (~120 lines)

- Navigation header
- Logo
- Navigation links
- Cart badge
- Sticky header
- Mobile menu (hamburger)

#### pages/

##### cart.css (~80 lines)

- Cart-specific styles
- Cart item cards
- Cart summary

##### login.css (~100 lines)

- Login/register form styling
- Centered form layout

##### orders.css (~90 lines)

- Order list styling
- Order cards
- Status indicators

##### products.css (~120 lines)

- Product grid
- Product cards
- Product images
- Add to cart button

#### utilities/

##### animations.css (~60 lines)

- Fade in/out
- Slide animations
- Dropdown animations
- Loading spinners

##### helpers.css (~80 lines)

- Utility classes
- Margin/padding helpers
- Text alignment
- Display helpers

##### responsive.css (~150 lines)

- Mobile breakpoints
- Tablet styles
- Desktop optimizations
- Responsive navigation

### images/

#### placeholder.svg

- Default product image
- Used when product has no image

**Additional Images**:
Product images stored here (uploaded or referenced).

---

## data

Database and utility scripts.

### ecommerce.db

**Purpose**: SQLite database file (auto-generated)

**Created**: On first application run
**Size**: ~100KB with sample data
**Tables**: 6 tables (users, customers, products, orders, order_items, inventory_transactions)

### sqlite_explorer.pl (~150 lines)

**Purpose**: Interactive SQLite database explorer

**Usage**:

```bash
perl data/sqlite_explorer.pl data/ecommerce.db
```

**Features**:

- List all tables
- View table schema
- Browse table data
- Execute SQL queries
- Interactive shell

### update_images.pl (~80 lines)

**Purpose**: Utility to update product image URLs in database

**Usage**:

```bash
perl data/update_images.pl
```

**Features**:

- Batch update product images
- Validate image paths
- Set placeholder for missing images

---

## docs -MUST- READ

Comprehensive documentation.

### README.md

**Purpose**: Main project documentation

**Contents**:

- Quick start guide
- Features overview
- Installation instructions
- System architecture overview
- Technology stack
- Project structure
- User roles
- Documentation index

### INSTALLATION.md

**Purpose**: Detailed installation guide

**Contents**:

- System requirements
- Platform-specific installation (Windows, Linux, macOS)
- Dependency installation
- Configuration
- Running the application
- Troubleshooting
- Verification steps

### ARCHITECTURE.md

**Purpose**: System architecture documentation

**Contents**:

- MVC architecture explanation
- Technology stack details
- System components
- Database schema with ERD
- Request flow diagrams
- Security architecture
- Design patterns
- Performance considerations

### API_DOCUMENTATION.md

**Purpose**: API reference

**Contents**:

- All routes documented
- Request/response formats
- Authentication requirements
- Example requests
- Error codes

### USER_GUIDE.md

**Purpose**: End-user manual

**Contents**:

- How to use the system
- Admin features
- Customer features
- Step-by-step guides
- Screenshots
- Tips and tricks

### FILE_LISTING.md (this file)

**Purpose**: Complete file reference

**Contents**:

- Every file documented
- Purpose and description
- Relationships
- Dependencies

### PROJECT_SUMMARY.md

**Purpose**: Project overview

**Contents**:

- Project objectives
- Scope
- Implementation details
- Technologies used
- Achievements

### COMPLETION_SUMMARY.md

**Purpose**: Development milestone summary

**Contents**:

- Features implemented
- Testing completed
- Known issues
- Future enhancements

---

## File Count Summary

| Category            | Count                                                                                                      |
| ------------------- | ---------------------------------------------------------------------------------------------------------- |
| **Root Files**      | 3 (app.pl, cpanfile, .env)                                                                                 |
| **Library Files**   | 15 (Config, Database, 4 Models, Auth, 5 Admin Controllers, 5 Customer Controllers)                         |
| **Route Files**     | 3 (shared, admin, customer)                                                                                |
| **Template Files**  | 20 (2 layouts, 8 admin, 9 customer, login)                                                                 |
| **CSS Files**       | 23 (1 main, 3 base, 9 components, 3 layout, 4 pages, 3 utilities)                                          |
| **Utility Scripts** | 2 (sqlite_explorer.pl, update_images.pl)                                                                   |
| **Documentation**   | 8 (README, INSTALLATION, ARCHITECTURE, API, USER_GUIDE, FILE_LISTING, PROJECT_SUMMARY, COMPLETION_SUMMARY) |
| **Database**        | 1 (ecommerce.db - auto-generated)                                                                          |

**Total**: ~75 files

---

## Dependency Graph

```
app.pl
 ├── lib/ECommerce/Config.pm
 ├── lib/ECommerce/Database.pm
 │    └── lib/ECommerce/Config.pm
 ├── routes/shared_routes.pl
 │    ├── Controllers/Auth.pm
 │    ├── Controllers/Admin/* (5 files)
 │    └── Controllers/Customer/* (5 files)
 ├── routes/admin_routes.pl
 │    └── Controllers/Admin/* (5 files)
 └── routes/customer_routes.pl
      └── Controllers/Customer/* (5 files)

Controllers
 ├── Auth.pm
 │    ├── Models/User.pm
 │    └── Models/Customer.pm
 ├── Admin/DashboardController.pm
 │    ├── Models/Product.pm
 │    ├── Models/Order.pm
 │    └── Models/Customer.pm
 ├── Admin/ProductController.pm
 │    └── Models/Product.pm
 ├── Admin/OrderController.pm
 │    └── Models/Order.pm
 ├── Admin/CustomerController.pm
 │    └── Models/Customer.pm
 ├── Admin/ReportController.pm
 │    ├── Models/Product.pm
 │    ├── Models/Order.pm
 │    └── Models/Customer.pm
 ├── Customer/CartController.pm
 │    └── Models/Product.pm
 ├── Customer/OrderController.pm
 │    ├── Models/Order.pm
 │    └── Models/Product.pm
 └── Customer/AccountController.pm
      └── Models/Customer.pm

Models
 ├── User.pm → Database.pm
 ├── Customer.pm → Database.pm
 ├── Product.pm → Database.pm
 └── Order.pm → Database.pm, Product.pm
```

---

## Key Relationships

### Authentication Flow

```
Login (template) → Auth.pm → User.pm → Database
```

### Product Management Flow

```
Products Admin (template) → ProductController.pm → Product.pm → Database
```

### Order Flow

```
Cart (template) → CartController.pm → Product.pm → Database
Checkout → OrderController.pm → Order.pm → Product.pm → Database
```

### View Rendering Flow

```
Controller → Stash Data → Template (EP) → Layout → HTML Response
```

---

**Document Version**: 2.0  
**Last Updated**: December 15, 2025  
**Total Lines of Code**: ~10,000+ lines (Perl, HTML, CSS)

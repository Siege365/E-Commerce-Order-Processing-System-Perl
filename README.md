# E-Commerce Order Processing System (Perl)

A full-featured e-commerce order processing system built with **Perl** and the **Mojolicious** web framework. This system demonstrates modern web development practices in Perl with a clean MVC architecture, role-based access control, and comprehensive business logic.

> **⚠️ SECURITY WARNING**: This project includes default credentials and configurations for **development/testing purposes only**. See [SECURITY.md](SECURITY.md) for production deployment guidelines.

## 🚀 Quick Start

```powershell
# 1. Install dependencies
cpanm --installdeps .

# 2. Configure environment (IMPORTANT)
# Copy .env.example to .env and update with secure values
cp .env.example .env

# 3. Run the application
perl app.pl daemon

# 4. Open browser
# Navigate to http://localhost:3000
```

**Default Login Credentials (⚠️ CHANGE IN PRODUCTION):**

- **Admin**: username: `admin`, password: `admin123`
- **Staff**: username: `staff`, password: `staff123`
- **Customer**: username: `customer`, password: `customer123`

**📖 Read [SECURITY.md](SECURITY.md) before deploying to production!**

---

## 📋 Table of Contents

- [Features](#features)
- [System Architecture](#system-architecture)
- [Technology Stack](#technology-stack)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [User Roles](#user-roles)
- [Documentation](#documentation)
- [Development](#development)

---

## ✨ Features

### Admin/Staff Features

- 📊 **Dashboard**: Real-time metrics, charts, and system analytics
- 📦 **Product Management**: Add, edit, delete, and manage inventory
- 📋 **Order Management**: View, update status, and track orders
- 👥 **Customer Management**: View and manage customer accounts
- 📈 **Reports**: Sales reports, inventory analysis, customer insights
- 🔍 **Search & Filter**: Advanced search across all entities
- 📄 **Export**: Download reports in various formats

### Customer Features

- 🛒 **Shopping Cart**: Add/remove products, quantity management
- 🛍️ **Product Catalog**: Browse and search products by category
- 📦 **Order History**: View past orders and track status
- 👤 **Account Management**: Update profile and shipping information
- 💳 **Checkout**: Secure checkout with multiple payment options
- ❌ **Order Cancellation**: Cancel pending orders

### General Features

- 🔐 **Authentication & Authorization**: Secure login with bcrypt password hashing
- 🎨 **Responsive Design**: Mobile-friendly interface
- 💾 **SQLite Database**: Lightweight, embedded database
- 📱 **Session Management**: Secure session handling
- 🎯 **Role-Based Access Control**: Admin, Staff, and Customer roles
- 🌈 **Modern UI**: Clean, professional design with smooth animations

---

## 🏗️ System Architecture

### MVC Architecture

```
┌─────────────────────────────────────────────────────┐
│                   Mojolicious App                   │
│                     (app.pl)                        │
└─────────────────────────────────────────────────────┘
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
        ▼                 ▼                 ▼
   ┌─────────┐      ┌──────────┐     ┌─────────┐
   │ Routes  │      │  Views   │     │ Helpers │
   │         │      │          │     │         │
   └─────────┘      └──────────┘     └─────────┘
        │
        ▼
   ┌─────────────────────────────┐
   │      Controllers            │
   │  - Admin Controllers        │
   │  - Customer Controllers     │
   │  - Auth Controller          │
   └─────────────────────────────┘
        │
        ▼
   ┌─────────────────────────────┐
   │         Models              │
   │  - User Model               │
   │  - Product Model            │
   │  - Order Model              │
   │  - Customer Model           │
   └─────────────────────────────┘
        │
        ▼
   ┌─────────────────────────────┐
   │    Database Layer           │
   │  - SQLite Database          │
   │  - Connection Management    │
   │  - Schema Initialization    │
   └─────────────────────────────┘
```

### Request Flow

1. **Browser** → HTTP Request
2. **Mojolicious Router** → Routes request to controller
3. **Controller** → Validates input, calls model
4. **Model** → Queries database, returns data
5. **Controller** → Processes data, passes to view
6. **View (Template)** → Renders HTML
7. **Mojolicious** → Sends response
8. **Browser** → Displays page

---

## 🛠️ Technology Stack

### Backend

- **Perl 5** - Core language
- **Mojolicious 9.0+** - Modern web framework
- **DBI** - Database interface
- **DBD::SQLite** - SQLite driver
- **Crypt::Bcrypt** - Password hashing
- **Time::Piece** - Date/time handling

### Frontend

- **HTML5** - Structure
- **CSS3** - Styling with custom properties
- **JavaScript (Vanilla)** - Client-side logic
- **Embedded Perl (EP Templates)** - Server-side rendering

### Database

- **SQLite 3** - Embedded relational database

### Development Tools

- **cpanm** - CPAN module installer
- **Dotenv** - Environment variable management

---

## 📦 Installation

### Prerequisites

**Windows (Strawberry Perl):**

```powershell
# Install Strawberry Perl from https://strawberryperl.com/
# Already includes cpanm
```

**Linux/macOS:**

```bash
# Install Perl (usually pre-installed)
perl -v

# Install cpanm
curl -L https://cpanmin.us | perl - App::cpanminus
```

### Step-by-Step Installation

1. **Clone the Repository**

```powershell
git clone <repository-url>
cd E-Commerce-Order-Processing-System-Perl
```

2. **Install Dependencies**

```powershell
cpanm --installdeps .
```

This installs:

- Mojolicious (Web framework)
- DBI & DBD::SQLite (Database)
- Crypt::Bcrypt (Password hashing)
- JSON, Time::Piece, Digest::SHA
- Dotenv (Environment variables)

3. **Optional: Configure Environment Variables**

```powershell
# Create .env file (optional)
echo "MOJOLICIOUS_SECRET_KEY=your-secret-key-here" > .env
```

4. **Configure Environment (IMPORTANT FOR SECURITY)**

```powershell
# Copy example environment file
cp .env.example .env

# Edit .env and set secure values:
# - Generate secure MOJOLICIOUS_SECRET_KEY
# - Change default passwords (or remove default users in production)
```

5. **Run the Application**

```powershell
# Development mode (with auto-reload)
perl app.pl daemon

# Production mode (with Hypnotoad - requires configuration)
perl app.pl prefork
```

6. **Access the Application**

```
http://localhost:3000
```

### Database Initialization

The database (`data/ecommerce.db`) is **automatically created** on first run with:

- Schema creation (tables, indexes, foreign keys)
- Sample data (users, products, customers)
- **⚠️ 3 default users with weak passwords** (admin, staff, customer)
- 20 sample products across various categories

**🔒 IMPORTANT**: Delete or change default user passwords before production deployment!

---

## 📁 Project Structure

```
E-Commerce-Order-Processing-System-Perl/
│
├── app.pl                          # Main application entry point
├── cpanfile                        # Perl dependencies
├── .env                            # Environment variables (optional)
│
├── lib/                            # Application libraries
│   └── ECommerce/
│       ├── Config.pm               # Application configuration
│       ├── Database.pm             # Database management
│       │
│       ├── Models/                 # Data models (business logic)
│       │   ├── User.pm             # User authentication & management
│       │   ├── Customer.pm         # Customer profile management
│       │   ├── Product.pm          # Product catalog management
│       │   └── Order.pm            # Order processing logic
│       │
│       └── Controllers/            # Request handlers
│           ├── Auth.pm             # Login, logout, registration
│           │
│           ├── Admin/              # Admin-only controllers
│           │   ├── DashboardController.pm
│           │   ├── ProductController.pm
│           │   ├── OrderController.pm
│           │   ├── CustomerController.pm
│           │   └── ReportController.pm
│           │
│           └── Customer/           # Customer-only controllers
│               ├── DashboardController.pm
│               ├── ProductController.pm
│               ├── CartController.pm
│               ├── OrderController.pm
│               └── AccountController.pm
│
├── routes/                         # Route definitions
│   ├── shared_routes.pl            # Shared routes (login, dashboard)
│   ├── admin_routes.pl             # Admin/staff routes
│   └── customer_routes.pl          # Customer routes
│
├── templates/                      # HTML templates (Embedded Perl)
│   ├── login.html.ep               # Login page
│   │
│   ├── layouts/                    # Page layouts
│   │   ├── default.html.ep         # Main layout wrapper
│   │   └── auth.html.ep            # Authentication layout
│   │
│   ├── admin/                      # Admin views
│   │   ├── dashboard_admin.html.ep
│   │   ├── products_admin.html.ep
│   │   ├── product_add.html.ep
│   │   ├── product_edit.html.ep
│   │   ├── orders_admin.html.ep
│   │   ├── order_detail_admin.html.ep
│   │   ├── customers.html.ep
│   │   └── reports.html.ep
│   │
│   └── customer/                   # Customer views
│       ├── dashboard_customer.html.ep
│       ├── products_customer.html.ep
│       ├── cart.html.ep
│       ├── orders_customer.html.ep
│       ├── order_detail_customer.html.ep
│       ├── account.html.ep
│       └── register.html.ep
│
├── public/                         # Static assets
│   ├── css/                        # Stylesheets
│   │   ├── style.css               # Main stylesheet entry
│   │   ├── base/                   # Base styles (reset, typography, variables)
│   │   ├── components/             # Component styles (buttons, cards, forms, etc.)
│   │   ├── layout/                 # Layout styles (header, footer, container)
│   │   ├── pages/                  # Page-specific styles
│   │   └── utilities/              # Utility classes (animations, helpers, responsive)
│   │
│   └── images/                     # Product images
│
├── data/                           # Database and utilities
│   ├── ecommerce.db                # SQLite database (auto-generated)
│   ├── sqlite_explorer.pl          # Database exploration tool
│   └── update_images.pl            # Image management utility
│
└── docs -MUST- READ/               # Documentation
    ├── README.md                   # This file
    ├── INSTALLATION.md             # Detailed installation guide
    ├── ARCHITECTURE.md             # System architecture details
    ├── API_DOCUMENTATION.md        # API reference
    ├── USER_GUIDE.md               # User manual
    ├── FILE_LISTING.md             # Complete file listing
    ├── PROJECT_SUMMARY.md          # Project overview
    └── COMPLETION_SUMMARY.md       # Development completion summary
```

### Key Directories Explained

#### `lib/ECommerce/`

Core application logic following MVC pattern:

- **Models**: Database operations and business logic
- **Controllers**: Handle HTTP requests, coordinate between models and views
- **Config.pm**: Centralized configuration (database path, app settings)
- **Database.pm**: Database connection, schema, and initialization

#### `routes/`

Route definitions separating concerns:

- **shared_routes.pl**: Login, logout, dashboard routing (role-based)
- **admin_routes.pl**: Admin/staff-only routes (product/order management)
- **customer_routes.pl**: Customer-only routes (cart, checkout, account)

#### `templates/`

Embedded Perl templates:

- **layouts**: Wrapper templates with navigation, header, footer
- **admin**: Admin panel views
- **customer**: Customer-facing views

#### `public/css/`

Modular CSS architecture:

- **base**: Foundation (CSS variables, reset, typography)
- **components**: Reusable UI components
- **layout**: Page structure
- **pages**: Page-specific styles
- **utilities**: Helper classes

---

## 👥 User Roles

### Admin

**Full system access:**

- View and manage all products, orders, customers
- Generate reports and analytics
- Delete records
- Update order statuses
- Access all administrative functions

### Staff

**Limited administrative access:**

- View and manage products and orders
- Update order statuses
- View customers
- Limited report access
- Cannot delete critical data

### Customer

**Shopping and account management:**

- Browse product catalog
- Add products to cart
- Place orders
- View order history
- Manage account profile
- Cancel pending orders

---

## 📚 Documentation

Comprehensive documentation is available in the `docs -MUST- READ/` folder:

| Document                       | Description                                                             |
| ------------------------------ | ----------------------------------------------------------------------- |
| **[SECURITY.md](SECURITY.md)** | **🔒 Security guidelines, best practices, and vulnerability reporting** |
| **INSTALLATION.md**            | Complete installation guide with troubleshooting                        |
| **ARCHITECTURE.md**            | Detailed system architecture and design patterns                        |
| **API_DOCUMENTATION.md**       | Complete API reference for all routes                                   |
| **USER_GUIDE.md**              | Step-by-step user manual for all features                               |
| **FILE_LISTING_COMPLETE.md**   | Detailed file structure with descriptions                               |
| **PROJECT_SUMMARY.md**         | Project overview and objectives                                         |
| **COMPLETION_SUMMARY.md**      | Development milestone summary                                           |

---

## 🔧 Development

### Running in Development Mode

```powershell
# Start with auto-reload
morbo app.pl

# Or use daemon mode
perl app.pl daemon
```

### Database Management

**View Database:**

```powershell
perl data/sqlite_explorer.pl data/ecommerce.db
```

**Reset Database:**

```powershell
rm data/ecommerce.db
perl app.pl daemon  # Will recreate with sample data
```

**Update Product Images:**

```powershell
perl data/update_images.pl
```

### Adding New Features

1. **Create Model** (if needed):

```perl
# lib/ECommerce/Models/NewModel.pm
package ECommerce::Models::NewModel;
# Add database operations
```

2. **Create Controller**:

```perl
# lib/ECommerce/Controllers/Admin/NewController.pm
package ECommerce::Controllers::Admin::NewController;
# Add request handlers
```

3. **Add Routes**:

```perl
# routes/admin_routes.pl
$app->routes->get('/new-feature' => sub {
    my $c = shift;
    $controller->handle_request($c);
});
```

4. **Create Template**:

```html
<!-- templates/admin/new_feature.html.ep -->
% layout 'default'; % title 'New Feature';
<h1>New Feature</h1>
```

### Code Style

- Follow Perl Best Practices
- Use strict and warnings
- Proper error handling with eval/try-catch
- Clear variable naming
- Comment complex logic
- POD documentation for modules

---

## 🗄️ Database Schema

### Tables

1. **users** - User authentication

   - id, username, email, password_hash, role, created_at, last_login, is_active

2. **customers** - Customer profiles

   - id, user_id (FK), first_name, last_name, phone, address, city, state, zip_code, country

3. **products** - Product catalog

   - id, name, description, sku, category, price, cost, stock_quantity, reorder_level, image_url, is_active

4. **orders** - Order records

   - id, order_number, customer_id (FK), status, subtotal, tax, shipping, total, payment_method, payment_status, shipping_address, billing_address, notes

5. **order_items** - Order line items

   - id, order_id (FK), product_id (FK), product_name, product_sku, quantity, unit_price, subtotal

6. **inventory_transactions** - Inventory audit trail
   - id, product_id (FK), quantity_change, transaction_type, reference_id, notes

---

## 🔐 Security Features

- ✅ **Bcrypt Password Hashing** - Industry-standard password security
- ✅ **Session Management** - Secure session handling with expiration
- ✅ **Role-Based Access Control** - Fine-grained permission system
- ✅ **SQL Injection Prevention** - Parameterized queries
- ✅ **CSRF Protection** - Session-based request validation
- ✅ **Input Validation** - Server-side validation of all inputs

---

## 🚀 Deployment

### Production Deployment

1. **Set Secret Key**:

```powershell
$env:MOJOLICIOUS_SECRET_KEY="your-random-secret-key-minimum-32-chars"
```

2. **Run with Hypnotoad** (production server):

```powershell
hypnotoad app.pl
```

3. **Configure Workers** (in app.pl):

```perl
app->config(hypnotoad => {
    listen => ['http://*:3000'],
    workers => 4,
    pid_file => 'app.pid'
});
```

### Performance Tips

- Enable database indexing (already configured)
- Use connection pooling for high traffic
- Enable Hypnotoad for multi-worker deployment
- Configure caching for static assets
- Use reverse proxy (nginx) for production

---

## 🐛 Troubleshooting

### Common Issues

**"Can't locate Module.pm in @INC"**

```powershell
# Install missing module
cpanm Module::Name
```

**Database locked error**

```powershell
# Close all connections and restart
rm data/ecommerce.db.lock
```

**Port already in use**

```powershell
# Change port in app.pl or kill existing process
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

---

## 🔒 Security

**⚠️ Important**: This application includes default credentials and test configurations.

Before production deployment:

- Review [SECURITY.md](SECURITY.md) for comprehensive security guidelines
- Change all default passwords
- Configure environment variables in `.env`
- Generate secure secret keys
- Enable HTTPS/TLS
- Implement rate limiting
- Regular security updates

**Never deploy with default credentials or configurations!**

---

## 📄 License

This project is licensed under the **MIT License** - see [LICENSE](LICENSE) file for details.

Developed for educational purposes as part of CS15 Final Project.

---

## 👨‍💻 Authors

Developed as a comparative study: **Python vs Perl for E-Commerce Systems**

---

## 🙏 Acknowledgments

- Mojolicious Framework Team
- Perl Community
- CS15 Course Staff

---

## 📞 Support

For issues or questions:

1. Check documentation in `docs -MUST- READ/`
2. Review code comments and POD documentation
3. Examine error logs in terminal output

---

**Happy Coding! 🎉**

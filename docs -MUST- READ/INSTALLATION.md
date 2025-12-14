# Installation Guide

Complete installation and setup guide for the E-Commerce Order Processing System (Perl).

---

## Table of Contents

- [System Requirements](#system-requirements)
- [Windows Installation](#windows-installation)
- [Linux Installation](#linux-installation)
- [macOS Installation](#macos-installation)
- [Dependency Installation](#dependency-installation)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [Troubleshooting](#troubleshooting)
- [Verification](#verification)

---

## System Requirements

### Minimum Requirements

- **Perl**: Version 5.16 or higher
- **RAM**: 512 MB
- **Disk Space**: 100 MB (including dependencies)
- **Browser**: Modern browser (Chrome, Firefox, Edge, Safari)

### Recommended Requirements

- **Perl**: Version 5.32 or higher
- **RAM**: 1 GB
- **Disk Space**: 500 MB
- **OS**: Windows 10/11, Ubuntu 20.04+, macOS 10.15+

---

## Windows Installation

### 1. Install Strawberry Perl

Strawberry Perl is a Perl distribution for Windows that includes cpanm and development tools.

**Download and Install:**

1. Visit: https://strawberryperl.com/
2. Download the latest MSI installer (64-bit recommended)
3. Run the installer with default settings
4. Verify installation:

```powershell
perl -v
# Should show: This is perl 5, version XX...

cpanm --version
# Should show: cpanm version X.XXXX
```

### 2. Clone or Download the Project

**Option A: Using Git**

```powershell
cd "C:\Users\<YourUsername>\Documents"
git clone <repository-url>
cd E-Commerce-Order-Processing-System-Perl
```

**Option B: Download ZIP**

1. Download ZIP from repository
2. Extract to your desired location
3. Open PowerShell in the extracted folder

### 3. Install Dependencies

```powershell
# Navigate to project directory
cd "path\to\E-Commerce-Order-Processing-System-Perl"

# Install all dependencies from cpanfile
cpanm --installdeps .
```

**Dependencies installed:**

- Mojolicious (>= 9.0)
- DBI (>= 1.643)
- DBD::SQLite (>= 1.70)
- Crypt::Bcrypt (>= 0.011)
- JSON (>= 4.0)
- Time::Piece (>= 1.33)
- File::Basename, File::Spec
- Digest::SHA (>= 6.0)
- MIME::Base64
- Data::Dumper
- List::Util (>= 1.50)
- Dotenv

**Installation time**: 5-10 minutes depending on internet speed.

### 4. Run Application (Development)

Start the development server:

```powershell
perl app.pl daemon
```

**Expected output:**

```
Database initialized with sample data.
[Mon Jan 1 12:00:00 2025] [info] Listening at "http://*:3000"
Server available at http://127.0.0.1:3000
```

### 5. Access in Browser

Open your browser and navigate to:

```
http://localhost:3000
```

**Test login:**

- Username: `admin`
- Password: `admin123`

---

## Linux Installation

### 1. Install Perl and Build Tools

Most Linux distributions come with Perl pre-installed.

**Ubuntu/Debian:**

```bash
sudo apt update
sudo apt install perl build-essential libssl-dev zlib1g-dev
```

**CentOS/RHEL/Fedora:**

```bash
sudo yum install perl perl-core gcc make openssl-devel zlib-devel
```

**Arch Linux:**

```bash
sudo pacman -S perl base-devel
```

### 2. Install cpanm

```bash
# Download and install cpanminus
curl -L https://cpanmin.us | perl - App::cpanminus

# Verify installation
cpanm --version
```

### 3. Clone the Repository

```bash
cd ~/Documents
git clone <repository-url>
cd E-Commerce-Order-Processing-System-Perl
```

### 4. Install Dependencies

```bash
# Install all dependencies
cpanm --installdeps .
```

### 5. Run the Application

```bash
perl app.pl daemon
```

### 6. Access in Browser

```
http://localhost:3000
```

---

## macOS Installation

### 1. Install Homebrew (if not installed)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install Perl (latest version)

macOS comes with Perl, but you can install a newer version:

```bash
# Install Perl via Homebrew
brew install perl

# Add to PATH (add to ~/.zshrc or ~/.bash_profile)
echo 'export PATH="/usr/local/opt/perl/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify
perl -v
```

### 3. Install cpanm

```bash
curl -L https://cpanmin.us | perl - App::cpanminus
```

### 4. Clone and Install

```bash
cd ~/Documents
git clone <repository-url>
cd E-Commerce-Order-Processing-System-Perl

# Install dependencies
cpanm --installdeps .
```

### 5. Run the Application

```bash
perl app.pl daemon
```

### 6. Access in Browser

```
http://localhost:3000
```

---

## Dependency Installation

### Manual Installation (if cpanfile fails)

If `cpanm --installdeps .` fails, install modules individually:

```powershell
cpanm Mojolicious
cpanm DBI
cpanm DBD::SQLite
cpanm Crypt::Bcrypt
cpanm JSON
cpanm Time::Piece
cpanm Digest::SHA
cpanm Dotenv
```

### Force Installation (if tests fail)

Some modules may fail tests but still work:

```powershell
cpanm --force Dotenv
cpanm --force Crypt::Bcrypt
```

---

## Configuration

### Environment Variables (Optional)

Create a `.env` file in the project root:

```env
# Mojolicious Secret Key (recommended for production)
MOJOLICIOUS_SECRET_KEY=your-super-secret-key-at-least-32-characters-long

# Database Path (optional, defaults to data/ecommerce.db)
DB_PATH=data/ecommerce.db

# Application Settings
APP_ENV=development
```

**Generate a secure secret key:**

```powershell
# PowerShell
$key = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object {[char]$_})
echo "MOJOLICIOUS_SECRET_KEY=$key"
```

---

## Running the Application

### Development Mode

**Option 1: daemon mode (simple)**

```powershell
perl app.pl daemon
```

**Option 2: morbo (auto-reload on file changes)**

```powershell
morbo app.pl
```

### Production Mode

**Hypnotoad (multi-worker production server):**

```powershell
# Start
hypnotoad app.pl

# Stop
hypnotoad -s app.pl
```

### Custom Port

```powershell
# Run on custom port
perl app.pl daemon -l http://*:8080
```

---

## Verification

### 1. Test Application

```powershell
perl app.pl daemon
```

Expected output should include:

```
Database initialized with sample data.
[info] Listening at "http://*:3000"
```

### 2. Test in Browser

1. Navigate to `http://localhost:3000`
2. Login with `admin` / `admin123`
3. You should see the admin dashboard

### 3. Verify Default Data

**Test accounts:**

- **Admin**: `admin` / `admin123`
- **Staff**: `staff` / `staff123`
- **Customer**: `customer` / `customer123`

**Sample data:**

- 20 products across various categories
- 5 sample customers
- All database tables initialized

---

## Troubleshooting

### Issue: "Can't locate Mojolicious.pm in @INC"

**Solution:**

```powershell
cpanm Mojolicious
```

### Issue: "Can't locate Dotenv.pm in @INC"

**Solution:**

```powershell
cpanm --force Dotenv
```

### Issue: "Can't connect to database"

**Solution:**

```powershell
# Ensure data directory exists
mkdir data -Force

# Remove corrupted database
rm data/ecommerce.db -ErrorAction SilentlyContinue

# Restart application (will recreate)
perl app.pl daemon
```

### Issue: "Port 3000 already in use"

**Solution:**

**Windows:**

```powershell
# Find process using port 3000
netstat -ano | findstr :3000

# Kill process (replace <PID> with actual PID)
taskkill /PID <PID> /F
```

**Linux/macOS:**

```bash
# Find and kill process
lsof -ti:3000 | xargs kill -9

# Or use different port
perl app.pl daemon -l http://*:8080
```

### Issue: "Crypt::Bcrypt installation fails"

**Solution:**

**Windows (Strawberry Perl):**

```powershell
# Use force install
cpanm --force Crypt::Bcrypt
```

**Linux:**

```bash
# Install development packages
sudo apt install build-essential libssl-dev

# Then install module
cpanm Crypt::Bcrypt
```

**macOS:**

```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install module
cpanm Crypt::Bcrypt
```

### Issue: "Database is locked"

**Solution:**

```powershell
# Remove lock files
rm data/ecommerce.db-shm -ErrorAction SilentlyContinue
rm data/ecommerce.db-wal -ErrorAction SilentlyContinue

# Restart application
perl app.pl daemon
```

### Issue: Permission Denied (Linux/macOS)

**Solution:**

```bash
# Make scripts executable
chmod +x app.pl
chmod +x data/*.pl

# Or run with perl explicitly
perl app.pl daemon
```

---

## Database Reset

If you need to start fresh:

```powershell
# Stop the application (Ctrl+C)

# Remove database
rm data/ecommerce.db

# Restart application (will recreate with sample data)
perl app.pl daemon
```

---

## Next Steps

After successful installation:

1. Read [USER_GUIDE.md](USER_GUIDE.md) for usage instructions
2. Read [ARCHITECTURE.md](ARCHITECTURE.md) to understand the system
3. Read [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for API details
4. Start developing or testing the application!

---

## Support

If you encounter issues not covered here:

1. Check error messages carefully
2. Verify all dependencies are installed
3. Check file permissions
4. Ensure ports are available
5. Review CPAN build logs: `~/.cpanm/build.log`

---

**Installation Complete! 🎉**

Your E-Commerce Order Processing System is ready to use.

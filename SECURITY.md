# Security Policy

## Supported Versions

Currently supported versions of the E-Commerce Order Processing System:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Security Best Practices

### Before Deployment

**⚠️ CRITICAL: This application includes default credentials and configurations intended for development/testing only.**

#### 1. Change Default Credentials

The system ships with default test accounts. **YOU MUST** change or delete these before production deployment:

- **Admin**: `admin` / `admin123`
- **Staff**: `staff` / `staff123`
- **Customer**: `customer` / `customer123`

#### 2. Configure Secret Keys

Generate a strong secret key for Mojolicious sessions:

```bash
# Generate a secure random key
perl -e 'use Mojo::Util qw(secure_random); use MIME::Base64; print MIME::Base64::encode_base64(secure_random(32), "")'
```

Add to your `.env` file:

```bash
MOJOLICIOUS_SECRET_KEY=your-generated-secure-key-here
```

**Never** use the default `dev-secret-key-change-in-production` in production.

#### 3. Environment Configuration

1. Copy `.env.example` to `.env`
2. Update all values with production credentials
3. Set restrictive file permissions: `chmod 600 .env` (Linux/macOS)
4. **Never commit `.env` to version control** (already in `.gitignore`)

#### 4. Database Security

- Change database location from default `data/ecommerce.db`
- Set appropriate file permissions (chmod 600)
- Use encrypted filesystem for sensitive data
- Implement regular backup strategy
- Consider migrating to PostgreSQL/MySQL for production

#### 5. HTTPS/TLS Configuration

This application runs HTTP by default. For production:

```bash
# Use a reverse proxy like nginx or Apache with TLS
# Or configure Mojolicious with TLS certificates
hypnotoad app.pl  # Production server with TLS support
```

#### 6. Additional Security Measures

- [ ] Enable rate limiting for login attempts
- [ ] Implement CSRF protection (Mojolicious built-in, ensure enabled)
- [ ] Configure Content Security Policy headers
- [ ] Set up logging and monitoring
- [ ] Regular dependency updates (`cpanm --installdeps .`)
- [ ] Run in restricted user account (not root)
- [ ] Configure firewall rules
- [ ] Enable session timeout (configured: 1 hour)

### Security Features Implemented

✅ **Password Hashing**: Crypt::Bcrypt with cost factor 10  
✅ **Session Management**: Secure cookie-based sessions  
✅ **Role-Based Access Control**: Admin, Staff, Customer roles  
✅ **SQL Injection Protection**: Prepared statements via DBI  
✅ **XSS Prevention**: Mojolicious template auto-escaping  
✅ **Authentication**: Login required for protected routes  
✅ **Input Validation**: Form validation on registration/login

### Known Development-Only Features

⚠️ **Not Production-Ready Without Changes:**

1. Default test credentials in `lib/ECommerce/Database.pm`
2. Default secret key fallback in `app.pl`
3. SQLite database (consider PostgreSQL/MySQL)
4. No rate limiting on authentication endpoints
5. No email verification for user registration
6. No two-factor authentication (2FA)

## Reporting a Vulnerability

If you discover a security vulnerability, please report it responsibly:

### Reporting Process

1. **DO NOT** open a public GitHub issue
2. Email security concerns to: **[INSERT YOUR SECURITY EMAIL HERE]**
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact assessment
   - Suggested fix (if available)

### Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Fix Timeline**: Based on severity
  - Critical: 24-48 hours
  - High: 7 days
  - Medium: 30 days
  - Low: Next release cycle

### Disclosure Policy

- We follow coordinated vulnerability disclosure
- Public disclosure after fix is deployed (typically 90 days)
- Security advisories published via GitHub Security Advisories
- Credit given to reporters (unless anonymity requested)

## Security Updates

Subscribe to security advisories:

- GitHub Watch → Custom → Security alerts
- Check CHANGELOG.md for security-related updates
- Follow release notes for security patches

## Compliance Notes

This is an educational/demonstration project. For production use in regulated industries:

- Review PCI DSS requirements for payment processing
- Implement GDPR compliance for EU users
- Follow OWASP Top 10 guidelines
- Conduct security audit and penetration testing
- Implement comprehensive logging and audit trails

## Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Mojolicious Security Guide](https://docs.mojolicious.org/Mojolicious/Guides/Cookbook#SECURITY)
- [Perl Security Best Practices](https://perldoc.perl.org/perlsec)
- [CPAN Security Advisories](https://security.metacpan.org/)

---

**Last Updated**: December 15, 2025

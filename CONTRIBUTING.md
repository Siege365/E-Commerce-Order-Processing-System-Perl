# Contributing to E-Commerce Order Processing System

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)

## Code of Conduct

### Our Pledge

We pledge to make participation in this project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

**Positive behavior includes:**

- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

**Unacceptable behavior includes:**

- Trolling, insulting/derogatory comments, and personal attacks
- Public or private harassment
- Publishing others' private information without permission
- Other conduct which could reasonably be considered inappropriate

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally
3. Set up the development environment
4. Create a branch for your changes
5. Make your changes
6. Test your changes
7. Submit a pull request

## Development Setup

### Prerequisites

- Perl 5.16 or higher
- cpanm (CPAN Minus)
- SQLite 3
- Git

### Initial Setup

```bash
# Clone your fork
git clone https://github.com/YOUR-USERNAME/E-Commerce-Order-Processing-System-Perl.git
cd E-Commerce-Order-Processing-System-Perl

# Add upstream remote
git remote add upstream https://github.com/ORIGINAL-OWNER/E-Commerce-Order-Processing-System-Perl.git

# Install dependencies
cpanm --installdeps .

# Configure environment
cp .env.example .env
# Edit .env with your development settings

# Run the application
perl app.pl daemon
```

### Development Dependencies

```bash
# Install testing modules
cpanm Test::More Test::Mojo Test::Exception Test::Deep

# Install code quality tools
cpanm Perl::Critic Perl::Tidy
```

## How to Contribute

### Types of Contributions

We welcome many types of contributions:

- **Bug fixes**: Fix issues in existing code
- **New features**: Add new functionality
- **Documentation**: Improve or add documentation
- **Tests**: Add or improve test coverage
- **Code quality**: Refactoring, performance improvements
- **UI/UX**: Design improvements, accessibility

### Contribution Workflow

1. **Check existing issues**: Look for existing issues or create a new one
2. **Discuss major changes**: Open an issue to discuss significant changes before coding
3. **Create a branch**: Use descriptive branch names
   ```bash
   git checkout -b feature/add-payment-gateway
   git checkout -b fix/cart-quantity-bug
   git checkout -b docs/update-installation-guide
   ```
4. **Make your changes**: Follow coding standards
5. **Test thoroughly**: Ensure all tests pass
6. **Commit with clear messages**: Write descriptive commit messages
7. **Push to your fork**: Push your branch to your GitHub fork
8. **Open a Pull Request**: Submit PR with clear description

## Coding Standards

### Perl Style Guidelines

Follow these Perl best practices:

```perl
# Use strict and warnings
use strict;
use warnings;

# Descriptive variable names
my $customer_name = $user->name;  # Good
my $cn = $user->name;             # Bad

# Proper indentation (4 spaces)
sub calculate_total {
    my ($self, $items) = @_;

    my $total = 0;
    foreach my $item (@$items) {
        $total += $item->{price} * $item->{quantity};
    }

    return $total;
}

# Error handling
eval {
    $db->transaction(sub {
        # Database operations
    });
};
if ($@) {
    warn "Transaction failed: $@";
    return;
}

# Documentation with POD
=head2 calculate_total

Calculates the total price for a list of items.

    my $total = $order->calculate_total(\@items);

Returns the total as a decimal value.

=cut
```

### Code Organization

- **MVC Pattern**: Keep models, views, and controllers separate
- **Single Responsibility**: Each module should have one clear purpose
- **DRY Principle**: Don't repeat yourself - reuse code
- **Clear Naming**: Use descriptive names for variables, functions, modules

### File Structure

```
lib/ECommerce/
├── Models/           # Business logic, database operations
├── Controllers/      # Request handling, route logic
└── Helpers/          # Utility functions, shared code
```

## Testing Guidelines

### Writing Tests

Create tests in the `t/` directory:

```perl
# t/models/product.t
use strict;
use warnings;
use Test::More tests => 5;
use Test::Mojo;
use FindBin;
use lib "$FindBin::Bin/../lib";

use ECommerce::Models::Product;

my $product = ECommerce::Models::Product->new();

# Test product creation
my $result = $product->create({
    name => 'Test Product',
    price => 99.99,
    stock => 10
});
ok($result, 'Product created successfully');

# Test product retrieval
my $retrieved = $product->get($result->{id});
is($retrieved->{name}, 'Test Product', 'Product name matches');
is($retrieved->{price}, 99.99, 'Product price matches');
```

### Running Tests

```bash
# Run all tests
prove -l t/

# Run specific test file
perl t/models/product.t

# Run with verbose output
prove -lv t/
```

### Test Coverage

- Aim for at least 80% code coverage
- Test edge cases and error conditions
- Test both success and failure scenarios

## Pull Request Process

### Before Submitting

- [ ] Code follows project style guidelines
- [ ] All tests pass
- [ ] New tests added for new features
- [ ] Documentation updated
- [ ] Commit messages are clear and descriptive
- [ ] Branch is up to date with main

### PR Description Template

```markdown
## Description

Brief description of changes

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Code refactoring
- [ ] Other (specify)

## Testing

Describe testing performed

## Screenshots (if applicable)

Add screenshots for UI changes

## Related Issues

Fixes #123
```

### Review Process

1. Automated checks run (if configured)
2. Code review by maintainers
3. Address feedback
4. Approval from maintainer(s)
5. Merge into main branch

### After Merge

- Delete your branch
- Update your fork
- Close related issues

## Reporting Bugs

### Before Reporting

1. Check existing issues
2. Verify it's not a configuration problem
3. Test with latest version

### Bug Report Template

```markdown
**Description**
Clear description of the bug

**Steps to Reproduce**

1. Go to '...'
2. Click on '...'
3. See error

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Environment**

- OS: [e.g. Windows 10, Ubuntu 20.04]
- Perl Version: [e.g. 5.32]
- Browser: [e.g. Chrome 96]

**Screenshots**
If applicable

**Additional Context**
Any other relevant information
```

## Suggesting Enhancements

### Enhancement Template

```markdown
**Feature Description**
Clear description of the proposed feature

**Use Case**
Why is this feature needed?

**Proposed Solution**
How would you implement this?

**Alternatives Considered**
Other approaches you've thought about

**Additional Context**
Mockups, examples, etc.
```

## Development Best Practices

### Security

- Never commit sensitive data (passwords, API keys)
- Use environment variables for configuration
- Validate all user input
- Use prepared statements for SQL queries
- Follow [SECURITY.md](SECURITY.md) guidelines

### Performance

- Optimize database queries
- Use indexes appropriately
- Cache frequently accessed data
- Minimize external API calls

### Documentation

- Comment complex logic
- Update README for new features
- Use POD documentation for modules
- Keep docs in sync with code

## Questions?

- Open an issue for discussion
- Check existing documentation
- Review code examples in the project

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing!** 🎉

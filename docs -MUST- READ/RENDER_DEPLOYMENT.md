# Render.com Deployment Guide

This guide will walk you through deploying your E-Commerce Order Processing System on Render.com with PostgreSQL database.

## Prerequisites

- GitHub account with your repository pushed
- Render.com account (free tier available)
- Git installed locally

## Why PostgreSQL for Render?

Render's free tier has **ephemeral storage** - any files saved to disk (like SQLite databases) are deleted when the service spins down due to inactivity. PostgreSQL provides persistent storage that survives service restarts.

The application automatically detects which database to use:

- **Local Development**: SQLite (file-based, no setup needed)
- **Production (Render)**: PostgreSQL (via `DATABASE_URL` environment variable)

## Step 1: Push Your Code to GitHub

```powershell
# Make sure all changes are committed
git add .
git commit -m "Ready for Render deployment"
git push origin main
```

## Step 2: Create PostgreSQL Database on Render

1. Go to [Render Dashboard](https://dashboard.render.com/)
2. Click **"New +"** → **"PostgreSQL"**
3. Configure database:
   - **Name**: `ecommerce-db` (or your preferred name)
   - **Database**: `ecommerce` (default is fine)
   - **User**: `admin` (default is fine)
   - **Region**: Choose closest to you
   - **PostgreSQL Version**: Latest (15 or 16)
   - **Instance Type**: Select **Free** tier
4. Click **"Create Database"**
5. Wait for provisioning (1-2 minutes)
6. **IMPORTANT**: Copy the **Internal Database URL** from the database dashboard
   - Format: `postgresql://user:password@dpg-xxxxx-a/database`
   - You'll need this for your web service

## Step 3: Create Web Service on Render

1. In Render Dashboard, click **"New +"** → **"Web Service"**
2. Connect to your GitHub repository:
   - Click **"Connect account"** if first time
   - Select your repository: `E-Commerce-Order-Processing-System-Perl`
3. Configure web service:
   - **Name**: `ecommerce-system` (or your preferred subdomain)
   - **Region**: Same as your database
   - **Branch**: `main`
   - **Root Directory**: Leave empty
   - **Runtime**: **Docker**
   - **Instance Type**: Select **Free** tier

## Step 4: Add Environment Variables

In the **Environment** section, add these variables:

| Key                      | Value                                     | Notes                           |
| ------------------------ | ----------------------------------------- | ------------------------------- |
| `DATABASE_URL`           | (Paste Internal Database URL from Step 2) | Must start with `postgresql://` |
| `MOJOLICIOUS_SECRET_KEY` | (Generate secure random string)           | See below for generation        |
| `MOJO_MODE`              | `production`                              | Sets production mode            |
| `PORT`                   | `10000`                                   | Render's default port           |

### Generating Secure Secret Key

Run this locally to generate a secure key:

```powershell
perl -e "use Mojo::Util qw(secure_random_bytes); print unpack('H*', secure_random_bytes(32))"
```

Or use this simpler version:

```powershell
perl -e "print join('', map { ('a'..'z','A'..'Z',0..9)[rand 62] } 1..64)"
```

## Step 5: Deploy

1. Click **"Create Web Service"**
2. Render will:
   - Clone your repository
   - Build Docker image from your Dockerfile
   - Install Perl dependencies from cpanfile
   - Start the application
3. First deployment takes 5-10 minutes
4. Watch the logs for any errors

## Step 6: Initialize Database

Once deployed, the application will automatically:

- Connect to PostgreSQL via `DATABASE_URL`
- Create all necessary tables
- Insert sample data (admin, staff, customer users)

You can verify by accessing your app at: `https://your-service-name.onrender.com`

## Step 7: Test Your Application

1. **Visit login page**: `https://your-service-name.onrender.com`
2. **Login as admin**:
   - Username: `admin`
   - Password: `admin123`
3. **Verify dashboard loads**
4. **Test functionality**: Add products, create orders, etc.

## Default User Accounts

The system creates three sample users:

| Role     | Username | Password    | Email                  |
| -------- | -------- | ----------- | ---------------------- |
| Admin    | admin    | admin123    | admin@ecommerce.com    |
| Staff    | staff    | staff123    | staff@ecommerce.com    |
| Customer | customer | customer123 | customer@ecommerce.com |

**⚠️ IMPORTANT**: Change these passwords immediately after first login!

## Troubleshooting

### Database Connection Errors

If you see `Can't connect to database`:

1. Verify `DATABASE_URL` environment variable is set correctly
2. Check it uses **Internal Database URL** (not External)
3. Ensure database and web service are in **same region**
4. Restart the web service

### Module Not Found Errors

If you see `Can't locate DBD/Pg.pm`:

1. Check that `cpanfile` includes `DBD::Pg >= 3.14.0`
2. Rebuild the service (Manual Deploy → Clear build cache & deploy)

### Port Binding Errors

If you see `Can't bind to port`:

1. Ensure `PORT` environment variable is set to `10000`
2. Check Dockerfile exposes port 10000
3. Verify `app.pl` uses `$ENV{PORT} || 3000`

### Service Keeps Spinning Down

Free tier services spin down after 15 minutes of inactivity. This is normal. They spin back up automatically when accessed (takes ~30 seconds).

To keep it alive:

- Upgrade to paid tier ($7/month)
- Use a monitoring service to ping it every 10 minutes
- Accept the spin-down behavior for portfolio projects

## Monitoring and Logs

- **View Logs**: Render Dashboard → Your Service → Logs tab
- **Metrics**: Dashboard shows CPU, memory usage
- **Shell Access**: Dashboard → Shell tab (paid plans only)

## Updating Your Deployment

When you push changes to GitHub:

```powershell
git add .
git commit -m "Update features"
git push origin main
```

Render will **automatically** rebuild and redeploy your service.

To disable auto-deploy:

- Dashboard → Settings → Build & Deploy → Turn off "Auto-Deploy"

## Database Management

### View Database Data

1. Render Dashboard → Your PostgreSQL service
2. Click **"Connect"** → Copy connection string
3. Use a PostgreSQL client:
   - **pgAdmin**: GUI tool for Windows/Mac/Linux
   - **DBeaver**: Universal database tool
   - **psql**: Command-line tool

### Backup Database

Free tier includes automatic backups, but they're not downloadable. To backup:

```powershell
# Install PostgreSQL client tools first
# Then run:
pg_dump "postgresql://user:pass@dpg-xxxxx-a.oregon-postgres.render.com:5432/database" > backup.sql
```

### Reset Database

If you need to reset:

1. Dashboard → PostgreSQL service → Info tab
2. Click **"Delete Database"**
3. Create new PostgreSQL database
4. Update `DATABASE_URL` in web service
5. Restart web service to recreate tables

## Cost Considerations

**Free Tier Limits**:

- Web Service: 750 hours/month (enough for 1 service running 24/7)
- PostgreSQL: 90 days, then deleted (for testing only)
- Service spins down after 15 minutes inactivity
- Limited to 512MB RAM

**Upgrading** (when ready for production):

- Web Service: $7/month (always running, no spin-down)
- PostgreSQL: $7/month (persistent beyond 90 days)

## Custom Domain (Optional)

To use your own domain:

1. Dashboard → Your Service → Settings
2. Scroll to **Custom Domain**
3. Click **"Add Custom Domain"**
4. Follow DNS setup instructions

## Security Best Practices

1. **Change default passwords** immediately after first login
2. **Use strong MOJOLICIOUS_SECRET_KEY** (64+ characters)
3. **Don't commit .env file** to git
4. **Enable HTTPS** (Render provides free SSL certificates)
5. **Monitor logs** for suspicious activity

## Next Steps

- Set up monitoring with UptimeRobot or similar
- Configure custom domain
- Add more features to your application
- Consider upgrading to paid tier when traffic increases

## Support

- **Render Docs**: https://render.com/docs
- **Render Community**: https://community.render.com/
- **This Project**: Open an issue on GitHub

---

**Congratulations!** Your E-Commerce Order Processing System is now live on Render.com! 🎉

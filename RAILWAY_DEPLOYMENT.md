# Railway.app Deployment Guide

## Quick Start

1. **Sign up at [railway.app](https://railway.app)**
   - No credit card required initially
   - $5/month free credit

2. **Connect your GitHub repository**
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Choose your E-Commerce-Order-Processing-System-Perl repo

3. **Configure Environment Variables**
   - Go to Variables tab
   - Add: `MOJO_MODE=production`
   - Add: `MOJOLICIOUS_SECRET_KEY=your-secret-key-here`

4. **Deploy**
   - Railway auto-detects `railway.json` and `Dockerfile`
   - Deploy starts automatically
   - Your app will be live at: `https://your-app-name.up.railway.app`

## Features

- ✅ Free tier with $5/month credit
- ✅ Persistent storage for SQLite database
- ✅ Auto-deploy on GitHub push
- ✅ Custom subdomain
- ✅ No credit card required initially

## Database

Your SQLite database (`data/ecommerce.db`) will persist across deployments.

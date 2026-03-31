# Deploy Guide

This project can be made live globally for free. The simplest fit for the current codebase is a Node web service host, because the app serves both:

- a Fastify backend
- an HTML UI page from the same server

## Recommended Option

Use **Render** first.

Why:

- it supports full Node web services directly
- the app can run exactly as-is after build
- it gives you a public HTTPS URL
- the free tier is enough for demos and sharing

Important limitation:

- Render free services can sleep when idle, so the first request after inactivity can be slow

Source:

- Render free services docs: https://render.com/docs/free
- Render free overview: https://render.com/free

## Also Works

Use **Koyeb** if you want another free option with global deployment support.

Source:

- Koyeb docs: https://www.koyeb.com/docs
- Koyeb quick start: https://www.koyeb.com/docs/deploy

## Before Deploying

This repo is now deployment-ready with:

- `npm run build`
- `npm start`
- `PORT` support in the server

The app will listen on the host-provided port automatically.

## 1. Push To GitHub

Create a GitHub repository and push this project:

```bash
git init
git add .
git commit -m "Initial mock data generator"
git branch -M main
git remote add origin <your-github-repo-url>
git push -u origin main
```

## 2. Deploy On Render

### Render setup

1. Sign in at `https://render.com`
2. Click `New +`
3. Choose `Web Service`
4. Connect your GitHub account
5. Select this repository

### Render service configuration

Use these values:

- Name: `mock-data-generator`
- Environment: `Node`
- Region: choose the closest one to your users
- Branch: `main`
- Build Command: `npm install && npm run build`
- Start Command: `npm start`

### Environment variables

No required environment variables are needed for the current app.

### After deploy

Render will give you a public URL like:

```text
https://mock-data-generator.onrender.com
```

Open that URL and the web UI should load.

## 3. Make It Sharable

Once deployed, you can share the public Render URL directly.

If you want a nicer domain:

1. Buy or use a domain you already own
2. Add it in the Render dashboard
3. Point DNS records as Render instructs

For a completely free setup, just use the default Render subdomain.

## 4. Deploy On Koyeb Instead

If you prefer Koyeb:

1. Sign in at `https://www.koyeb.com`
2. Create a new App from GitHub
3. Select this repository
4. Use:

- Build command: `npm install && npm run build`
- Run command: `npm start`

Koyeb will also give you a public URL after deployment.

## Notes About File Output

This app writes generated files into the local `output/` directory on the server.

That works for simple demos, but on free hosting you should assume local storage is temporary or ephemeral. That means:

- generated Excel and SQL files may disappear after a restart or redeploy
- do not treat hosted local storage as permanent

For demo and shareable use, this is usually acceptable because the user can download the generated files immediately.

If you want more robust hosting later, the next step is:

- generate files in memory and stream them directly to the browser
- or upload outputs to object storage

## Best Practice For Public Sharing

For a public demo, I recommend this setup:

1. Deploy on Render free web service
2. Share the Render public URL
3. Accept cold starts on the free tier
4. Let users generate and download files immediately

## If Deployment Fails

Check these first:

- Node version on host supports modern ESM and current dependencies
- Build command is `npm install && npm run build`
- Start command is `npm start`
- The app is listening on `process.env.PORT`

## Current Free-Plan Notes

These can change over time, so verify before deploying:

- Render currently documents free web services for hobby/testing use
- Koyeb currently documents a free instance
- Vercel has a free Hobby plan, but this project is a better fit for a persistent Node service host than a serverless-first setup

Sources:

- Render: https://render.com/docs/free
- Koyeb: https://www.koyeb.com/docs
- Vercel Hobby: https://vercel.com/docs/plans/hobby

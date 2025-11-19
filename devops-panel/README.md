# DevOps Control Panel

A Next.js 15 DevOps control panel with VLN styling, featuring deployment monitoring, milestone tracking, and GitHub Actions integration.

## Features

- **Authentication**: Secure session-based authentication with bcrypt password hashing
- **Dashboard**: Real-time status cards for system health, deployments, and milestones
- **Milestone Tracking**: Visual progress bars for project milestones
- **Deployment Monitoring**: Integration with Vercel API for deployment status
- **GitHub Actions**: Monitor workflow runs and build status
- **Quick Actions**: Execute DevOps scripts directly from the panel
- **VLN Styling**: Beautiful sage green dark theme matching vln.gg

## Getting Started

### Prerequisites

- Node.js 18+ or pnpm
- Git
- (Optional) GitHub Personal Access Token
- (Optional) Vercel API Token

### Installation

1. Install dependencies:

```bash
pnpm install
```

2. Copy environment file:

```bash
cp .env.example .env
```

3. Configure your `.env` file:

```env
DEVOPS_USERNAME=admin
DEVOPS_PASSWORD=your_secure_password
SESSION_SECRET=generate_a_random_32_character_string
```

4. (Optional) Generate password hash for production:

```bash
node -e "const bcrypt = require('bcryptjs'); console.log(bcrypt.hashSync('your_password', 10));"
```

### Development

Run the development server:

```bash
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) to see the panel.

### Building for Production

```bash
pnpm build
pnpm start
```

## Deployment to Vercel

### 1. Install Vercel CLI

```bash
npm i -g vercel
```

### 2. Link to Vercel Project

```bash
cd devops-panel
vercel link
```

### 3. Set Environment Variables

```bash
vercel env add DEVOPS_USERNAME
vercel env add DEVOPS_PASSWORD_HASH
vercel env add SESSION_SECRET
vercel env add GITHUB_TOKEN
vercel env add VERCEL_TOKEN
```

### 4. Deploy

```bash
vercel --prod
```

### 5. Configure Custom Domain (Optional)

```bash
vercel domains add dev.vln.gg
```

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `DEVOPS_USERNAME` | Admin username | Yes |
| `DEVOPS_PASSWORD` | Admin password (dev only) | Yes* |
| `DEVOPS_PASSWORD_HASH` | Bcrypt hash of password | Yes* |
| `SESSION_SECRET` | 32+ character secret for sessions | Yes |
| `GITHUB_TOKEN` | GitHub Personal Access Token | No |
| `VERCEL_TOKEN` | Vercel API Token | No |
| `DEVOPS_SCRIPTS_PATH` | Path to DevOps scripts | No |

*Either `DEVOPS_PASSWORD` or `DEVOPS_PASSWORD_HASH` is required.

## API Routes

- `POST /api/auth/login` - Authenticate user
- `POST /api/auth/logout` - End session
- `GET /api/auth/session` - Check session status
- `GET /api/milestones` - Fetch milestone progress
- `GET /api/deployments` - Fetch Vercel deployments
- `GET /api/github` - Fetch GitHub Actions status

## Security Features

- Session-based authentication with iron-session
- Bcrypt password hashing
- HTTP-only secure cookies
- CSRF protection
- Security headers (X-Frame-Options, X-Content-Type-Options)
- Protected API routes

## Project Structure

```
devops-panel/
├── app/
│   ├── api/
│   │   ├── auth/
│   │   ├── deployments/
│   │   ├── github/
│   │   └── milestones/
│   ├── login/
│   ├── layout.tsx
│   ├── page.tsx
│   └── globals.css
├── components/
│   ├── devops/
│   │   ├── deployment-list.tsx
│   │   ├── milestone-card.tsx
│   │   ├── quick-actions.tsx
│   │   └── status-card.tsx
│   └── ui/
│       ├── button.tsx
│       └── card.tsx
├── lib/
│   ├── auth/
│   │   ├── credentials.ts
│   │   └── session.ts
│   └── utils.ts
└── package.json
```

## Technologies

- **Next.js 15.5.6** - React framework
- **React 19** - UI library
- **TypeScript** - Type safety
- **Tailwind CSS** - Styling
- **Framer Motion** - Animations
- **iron-session** - Session management
- **bcryptjs** - Password hashing
- **Lucide Icons** - Icon library
- **Vercel Analytics** - Analytics

## Customization

### Colors

Edit `tailwind.config.ts` to customize the VLN color scheme.

### Dashboard Components

Add custom components in `components/devops/` and import them in `app/page.tsx`.

### API Integrations

Create new API routes in `app/api/` for additional integrations.

## License

MIT

# Single-SPA Microfrontend Application

A complete single-spa microfrontend architecture demonstrating multiple frameworks working together.

## Architecture

This application consists of 5 microfrontends:

- **Root Config** (Port 9001) - Main orchestrator using single-spa
- **Navbar** (Port 9002) - Navigation component (React/JavaScript)
- **Employees** (Port 9003) - Employee list page (React/TypeScript)
- **Home** (Port 9004) - Landing page (React/TypeScript)
- **Employee Details** (Port 4200) - Employee detail view (Angular)

## Quick Start

```bash
# Install dependencies
yarn install

# Start all microfrontends in development
yarn start

# Build for production
yarn build

# Serve production build
yarn serve
```

## Development

### Prerequisites
- Node.js 16.20.0 (use `nvm use` to switch to the correct version)
- NVM (Node Version Manager)
- Yarn package manager

### Project Structure
```
packages/
├── single-spa-root-config/    # Main orchestrator
├── single-spa-navbar/         # Navigation (React)
├── single-spa-home/           # Home page (React/TS)
├── single-spa-employees/      # Employee list (React/TS)
└── single-spa-employee-details/ # Employee details (Angular)
```

### Routes
- `/` - Home page
- `/employees` - Employee list
- `/employees/:id` - Employee details

### Individual Development
Each microfrontend can be developed independently:

```bash
# Navigate to specific package
cd packages/single-spa-[package-name]

# Install dependencies
yarn install

# Start development server
yarn start
```

## Technologies

- **Single-SPA** - Microfrontend orchestration
- **React 17** - UI framework for most microfrontends
- **Angular 9** - Employee details microfrontend
- **TypeScript** - Type safety
- **Webpack** - Module bundling
- **Lerna** - Monorepo management

## Deployment

Builds are automatically deployed to the `deploy/` directory with the correct structure for serving.

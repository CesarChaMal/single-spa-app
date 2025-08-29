# Single-SPA Microfrontend Application

A complete single-spa microfrontend architecture demonstrating multiple frameworks working together.

## Architecture

This application consists of 5 microfrontends:

| Microfrontend | Port | Technology | Description |
|---------------|------|------------|-------------|
| 📋 **Root Config** | 9001 | Single-SPA | Main orchestrator and application shell |
| 🗂️ **Navbar** | 9002 | React/JavaScript | Navigation component and routing |
| 👥 **Employees** | 9003 | React/TypeScript | Employee list and management |
| 🏠 **Home** | 9004 | React/TypeScript | Landing page and dashboard |
| 👤 **Employee Details** | 4200 | Angular 9 | Individual employee detail views |

### 🌐 Application URLs
- **Main Application**: http://localhost:9001
- **Individual Services**: Each microfrontend runs independently on its respective port

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

### 🛣️ Routes
- `/` - Home page (React/TypeScript)
- `/employees` - Employee list (React/TypeScript)
- `/employees/:id` - Employee details (Angular)

### 🔧 Management Scripts
- `./microfrontend.sh` or `microfrontend.bat` - Start all services
- `./microfrontend.sh setup` - Setup Node.js and yarn
- `./microfrontend.sh clean` - Clean dependencies
- `./microfrontend.sh build` - Build for production
- `./microfrontend.sh stop` - Stop all services
- `./microfrontend.sh individual` - Start individual service

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

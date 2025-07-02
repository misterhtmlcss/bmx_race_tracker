# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

BMX Race Tracker is a mobile-first web application for tracking moto (heat) progression during BMX races. It allows race officials to manage which moto is at the gate and in staging, providing real-time information to riders and spectators.

## Key Commands

### Development
```bash
# Initial setup
bin/setup

# Start development server (runs on port 3030)
bin/dev

# Run tests
bin/rails test

# Run system tests
bin/rails test:system

# Code quality checks
## Run before adding files to staging
bin/rubocop              # Ruby style guide enforcement
bin/rubocop -a           # Auto-fix violations
bin/brakeman             # Security vulnerability scanning
```

### Database
```bash
# Create and migrate database
bin/rails db:create
bin/rails db:migrate

# Reset database
bin/rails db:reset

# Run seeds
bin/rails db:seed
```

### Deployment
```bash
# Deploy with Kamal (requires configuration)
bin/kamal deploy
```

## Architecture Overview

This is a Rails 8.0.2 application using modern Rails patterns:

### Technology Stack
- **Rails 8.0.2** with SQLite database
- **Hotwire** (Turbo + Stimulus) for frontend interactivity
- **Import Maps** for JavaScript (no Node.js build process)
- **Propshaft** for asset handling
- **Solid Cache/Queue/Cable** for database-backed infrastructure

### Key Design Decisions
1. **Mobile-First**: The PRD specifies this is primarily for smartphone usage during races
2. **No External Dependencies**: Keep it simple with minimal JavaScript dependencies
3. **SQLite**: Appropriate for single-server deployment with moderate traffic
4. **Server runs on port 3030** (not default 3000)

### Core Features (from PRD)
1. **Dual Independent Counters**: Track motos at gate and in staging
2. **Touch-Optimized UI**: Large buttons, no accidental zooming
3. **Race Time Settings**: Registration deadline and race start time
4. **Data Persistence**: Race times in localStorage, counters reset on reload

### Validation Rules
- At Gate counter: minimum 0, must be less than Staging
- In Staging counter: minimum 1, must be greater than At Gate
- Error handling with alerts for invalid inputs

## Development Notes

### Testing Approach
- Use Rails default testing framework (Minitest)
- System tests with Capybara and headless Chrome
- Tests run in parallel by default

### Code Style
- RuboCop configured with Rails Omakase style guide
- Run `bin/rubocop` before committing

### Database Structure
- SQLite databases stored in `/storage/` directory
- Production uses multiple databases (main, cache, queue, cable)

### Frontend Approach
- Use Stimulus controllers for JavaScript behavior
- Turbo for page updates without full reloads
- Mobile-first CSS with touch-optimized targets (minimum 44px)
- Visual design specified in PRD (red for gate, orange for staging)

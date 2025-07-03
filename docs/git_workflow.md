# Git Workflow

## Branch Strategy

1. **Create feature branch**
   ```bash
   git checkout -b feature/description-of-feature
   ```

2. **Make changes**
   - Write code
   - Run linters
   - Test changes

3. **Stage and commit**
   ```bash
   git add -A
   git commit -m "type: description"
   ```

4. **Push to remote**
   ```bash
   git push -u origin feature/branch-name
   ```

5. **Create Pull Request**
   ```bash
   gh pr create --title "Feature: Description" --body "## Summary\n\nDescription of changes"
   ```

6. **Wait for review**
   - DO NOT merge
   - Address feedback if needed
   - Let reviewer merge

## Commit Message Convention

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc)
- `refactor:` - Code refactoring
- `test:` - Test changes
- `chore:` - Build process or auxiliary tool changes

## Before Creating PR

1. Run linter: `bin/rubocop`
2. Run tests: `bin/rails test`
3. Check for security issues: `bin/brakeman`
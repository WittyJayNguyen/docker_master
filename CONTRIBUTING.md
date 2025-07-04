# Contributing to Docker Multi-Project Environment

Thank you for your interest in contributing to this project! 🎉

## 🚀 Getting Started

1. **Fork the repository**
2. **Clone your fork**:
   ```bash
   git clone https://github.com/your-username/docker-multi-project.git
   cd docker-multi-project
   ```
3. **Set up the development environment**:
   ```bash
   # Windows
   .\scripts\setup.bat
   
   # macOS/Linux
   ./scripts/setup.sh
   ```

## 🔧 Development Workflow

### Making Changes

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
3. **Test your changes**:
   ```bash
   # Test the entire system
   ./scripts/start.sh
   ./scripts/database.sh status
   
   # Test specific components
   docker-compose logs service-name
   ```

4. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

5. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**

### Commit Message Convention

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

Examples:
```
feat: add Redis container support
fix: resolve MySQL connection timeout
docs: update installation instructions
chore: update Docker base images
```

## 🧪 Testing

### Manual Testing

1. **Test all services start correctly**:
   ```bash
   ./scripts/start.sh
   docker-compose ps
   ```

2. **Test database connections**:
   ```bash
   ./scripts/database.sh status
   ```

3. **Test web interfaces**:
   - Vue.js: http://localhost:3000
   - phpMyAdmin: http://localhost:8080
   - pgAdmin: http://localhost:8081

4. **Test cross-platform compatibility**:
   - Windows (PowerShell/CMD)
   - macOS (Terminal)
   - Linux (Bash)

### Automated Testing

We welcome contributions to add automated testing:
- Docker Compose validation
- Service health checks
- Integration tests
- Cross-platform script testing

## 📝 Documentation

### README Updates

When adding new features, please update:
- Feature descriptions
- Installation instructions
- Usage examples
- Troubleshooting section

### Code Comments

- Add comments for complex configurations
- Document environment variables
- Explain Docker networking setup
- Comment script logic

## 🐳 Docker Guidelines

### Dockerfile Best Practices

- Use official base images
- Minimize layers
- Use multi-stage builds when appropriate
- Set proper user permissions
- Add health checks

### Docker Compose Guidelines

- Use environment variables for configuration
- Implement proper service dependencies
- Add restart policies
- Use named volumes for persistent data

## 🔒 Security Considerations

- Don't commit sensitive data (passwords, keys)
- Use strong default passwords
- Implement proper file permissions
- Follow Docker security best practices

## 🌍 Cross-Platform Support

### Windows Support

- Provide `.bat` scripts alongside `.sh` scripts
- Test with PowerShell and CMD
- Consider Windows path separators
- Test with WSL 2

### macOS Support

- Test with latest macOS versions
- Consider Apple Silicon compatibility
- Test with Homebrew-installed Docker

### Linux Support

- Test with major distributions (Ubuntu, CentOS, etc.)
- Consider different Docker installation methods
- Test with different shell environments

## 📋 Issue Reporting

### Bug Reports

Please include:
- Operating system and version
- Docker version
- Docker Compose version
- Steps to reproduce
- Expected vs actual behavior
- Relevant logs

### Feature Requests

Please include:
- Use case description
- Proposed implementation
- Potential impact on existing features
- Alternative solutions considered

## 🎯 Areas for Contribution

We especially welcome contributions in these areas:

### High Priority
- [ ] SSL/HTTPS support with Let's Encrypt
- [ ] Redis container integration
- [ ] Automated backup scheduling
- [ ] Health check improvements

### Medium Priority
- [ ] Elasticsearch integration
- [ ] Monitoring with Prometheus/Grafana
- [ ] CI/CD pipeline examples
- [ ] Performance optimization

### Low Priority
- [ ] Additional PHP versions
- [ ] Alternative database engines
- [ ] Development tools integration
- [ ] Documentation translations

## 🤝 Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help others learn and grow
- Follow project guidelines

## 📞 Getting Help

- **Issues**: [GitHub Issues](https://github.com/your-repo/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-repo/discussions)
- **Documentation**: README.md

## 🏆 Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Project documentation

Thank you for contributing! 🚀

# University Course Scheduling System

A robust Rails application for managing university course schedules, student enrollments, and class sections.

## Features

- Student authentication and registration
- Course section management
- Schedule conflict detection
- PDF schedule export
- Real-time availability checking
- Performance monitoring with PgHero
- N+1 query detection with Prosopite

## Technology Stack

- Ruby 3.3.6
- Rails 8.0
- PostgreSQL 17
- Redis for caching
- Kubernetes for deployment
- Devise for authentication
- RSpec for testing

## Prerequisites

- Ruby 3.3.6
- PostgreSQL 17
- Redis
- Node.js
- Yarn
- Docker and Kubernetes (for deployment)

## Development Setup

1. Clone the repository:
```bash
git clone https://github.com/hivvvan/course_scheduling_system.git
cd course_scheduling_system
```

2. Install dependencies:
```bash
bundle install
yarn install
```

3. Setup database:
```bash
rails db:create
rails db:migrate
rails db:seed
```

4. Start the application:
```bash
rails server
```

5. Run tests:
```bash
bundle exec rspec
```

## Database Schema

- `students`: User accounts and authentication
- `teachers`: Faculty information
- `subjects`: Course subjects
- `sections`: Class sections with schedules
- `classrooms`: Room information
- `student_sections`: Enrollment join table

## Key Features Details

### Schedule Management

Students can:
- View available sections
- Enroll in sections
- Check for scheduling conflicts
- Download PDF schedules

### Time Slot Rules

- Sections are either 50 or 80 minutes
- Classes run between 7:30 AM and 10:00 PM
- Automatic conflict detection

### Performance Monitoring

Using PgHero:
```bash
# Access dashboard
open http://localhost:3000/pghero

# Capture query stats
rails pghero:capture_query_stats
```

### N+1 Query Detection

Using Prosopite in development:
```bash
# Monitor queries
tail -f log/prosopite.log
```

## Testing

Run the test suite:
```bash
bundle exec rspec
```

Run specific tests:
```bash
bundle exec rspec spec/models/section_spec.rb
```

## Kubernetes Deployment

1. Build Docker image:
```bash
docker build -t university-scheduler:latest .
```

2. Deploy to Kubernetes:
```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secrets.yaml
kubectl apply -f k8s/
```

## CI/CD

GitHub Actions workflows for:
- Automated testing
- Code linting
- Security checks
- Deployment

## Code Quality

- RuboCop for Ruby style enforcement
- Brakeman for security analysis
- SimpleCov for test coverage
- Prosopite for N+1 query detection

## Contributing

1. Fork the repository
2. Create your feature branch:
```bash
git checkout -b feature/my-new-feature
```
3. Commit your changes:
```bash
git commit -am 'Add some feature'
```
4. Push to the branch:
```bash
git push origin feature/my-new-feature
```
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.

## Author

Your Name <your.email@example.com>

## Acknowledgments

- Ruby on Rails team
- Devise authentication library
- PostgreSQL development team
- Contributors and reviewers
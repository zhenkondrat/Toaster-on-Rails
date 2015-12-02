README
======

It's students testing system created on Ruby on Rails.

Ruby 2.3

Rails 4.2.4

PostgreSQL 9.4

## Configuration:

1. Rename config/database_template.yml to config/database.yml and configurate:
  
  ```yaml
  Posgresql:
  
    postgresql_base: &postgresql_base
    adapter: postgresql
    host: localhost
    username: <username>
    password: <password>
    encoding: utf8
    reconnect: true
    pool: 5

2. Database initialization:

  ```Bash
  rake db:create
  rake db:migrate
  ```

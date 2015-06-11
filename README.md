README
======

It's students testing system created on Ruby on Rails.

Ruby 2.2.0

Rails 4.2

PostgreSQL or MySQL(change gem in gemlist if you like it more)

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
  
  MySQL:
  
    adapter: mysql2
    encoding: utf8
    pool: 10
    database: toaster_dev
    username: <username>
    password: <password>
    socket: /var/run/mysqld/mysqld.sock
    reconnect: true
  ```

2. Database initialization:

  ```Bash
  rake db:create
  rake db:migrate
  ```

3. Get invitecodes by:

   (run in rails console)
  ```Ruby
  InviteCode.generate!
  ```
  You should get something like:
  ```Ruby
  {:admin=>"IDZWBC", :teacher=>"ATZBXQ", :student=>"QXVBNX"}
  ```

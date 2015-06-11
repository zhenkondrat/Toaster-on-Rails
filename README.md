==README

It's students testing system which created on Ruby on Rails.

This README would normally document whatever steps are necessary to get the application up and running.

Ruby version 2.2.0

System dependencies

Rails 4.2
Postgresql or MySQL(change gem in gemlist if you like it more)

### Configuration:

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
```Ruby
InviteCode.generate!
```
(run in rails console)

You should get something like:
```Ruby
{:admin=>"IDZWBC", :teacher=>"ATZBXQ", :student=>"QXVBNX"}
```

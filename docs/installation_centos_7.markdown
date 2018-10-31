# Installation instructions for CentOS/RHEL 7

Download and unpack the source to a location of your choice:

    mkdir /usr/share/puppet-dashboard
    cd /usr/share/puppet-dashboard
    curl -L https://github.com/sodabrew/puppet-dashboard/archive/master.tar.gz | tar zx --strip-components=1

Puppet Dashboard needs a newer ruby version than the default system ruby
that comes with CentOS 7. So we need to use RVM: (https://tecadmin.net/install-ruby-2-2-on-centos-rhel/), 
or use the software collections for this:

    yum install centos-release-scl

Installl all the dependencies:

    yum install rh-ruby25-rubygem-bundler rh-ruby25-ruby-devel rh-ruby25-ruby libxml2-devel gcc gcc-c++

To make the ruby from the software collection available we open a new bash

    scl enable rh-ruby25 bash

Puppet Dashboard supports the MySQL and Postgres databases. This requires a few
different steps. Jump to the chapter for the database you want to use.

## Postgres

This steps are specific for a setup with the postgresql database. First we will
install the client and then tell bundler to install the required gems for postgres.

    yum install postgresql postgresql-devel
    bundle install --deployment --without mysql sqlite development test

Create the database yaml file in 'config/database.yml'

    production:
      adapter: postgresql
      host: localhost
      database: dashboard_production
      username: dashboard
      password: mypassword
      encoding: utf8

### Postgres server setup

If you already have a postgres or a database you may skip this step.

Install and setup the postgres server

    yum install postgresql-server postgresql-contrib
    PGSETUP_INITDB_OPTIONS="--auth-host=md5" postgresql-setup initdb
    systemctl start postgresql.service
    systemctl enable postgresql.service

Configure access to the database server

    su -c psql - postgres
    create role dashboard with createdb login password 'mypassword';
    \q

## MySQL

TBD

## Don't forget to edit the database.yml (DBname, user, pass), and install bundler

## Migrate the database and precompile assets

Set temporary environment variables for installation:

    export RAILS_ENV=production
    export SECRET_KEY_BASE=$(bundle exec rails secret)

Setup the database and precompile the assets

    bundle exec rails db:create
    bundle exec rails db:migrate
    bundle exec rails assets:precompile

## Manually start the Dashboard service

Manual startup to test the server

    export RAILS_SERVE_STATIC_FILES=true
    bundle exec rails server --port 80


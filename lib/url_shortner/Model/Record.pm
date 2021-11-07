package url_shortner::Model::Record;
use Mojo::SQLite;

use Moo::Role;
use strictures 2;

use url_shortner::Schema;

has handle => ( is => 'lazy' );
# Allow handle to be passed in the constuctor for Dependency Inversion:
sub _build_handle {
  return $url_shortner::Schema::handle;
}

has db => ( is => 'lazy' );
# Allow handle to be passed in the constuctor for Dependency Inversion:
sub _build_db {
  return $url_shortner::Schema::db;
}

1;

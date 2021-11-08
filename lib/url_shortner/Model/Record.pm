package url_shortner::Model::Record;
use Mojo::SQLite;

use Moo::Role;
use strictures 2;

use url_shortner::Schema;

=head1

INFO: By using the build_handle we can allow different values
to be passed in for our DB handler and connection.

=cut

has handle => ( is => 'lazy' );
sub _build_handle {
  return $url_shortner::Schema::handle;
}

has db => ( is => 'lazy' );
sub _build_db {
  return $url_shortner::Schema::db;
}

1;

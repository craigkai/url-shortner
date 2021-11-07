package url_shortner::Schema;

use Mojo::SQLite;

our $handle = Mojo::SQLite->new('urls.db');
our $db = $handle->db;

sub Create {
  my $self = shift;

  print "Using SQLLITE: ".$db->query('select sqlite_version() as version')->hash->{version}."\n";

  # Use migrations to create a table
  $handle->migrations->name('url_shortner')->from_string(<<EOF)->migrate;
-- 1 up
create table urls (id integer primary key autoincrement, content text, original text);
-- 1 down
drop table urls;
EOF
}

1;

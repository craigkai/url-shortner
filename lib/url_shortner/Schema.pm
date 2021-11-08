package url_shortner::Schema;

use Mojo::SQLite;
use File::Spec::Functions 'catfile';
use File::Temp;

our $handle;
our $db;

my $tempdir;

sub Create {
  my $self = shift;
  my $test = shift;

  if ($test) {
    $tempdir = File::Temp->newdir; # Deleted when object goes out of scope
    my $tempfile = catfile $tempdir, 'test.db';
    $handle = Mojo::SQLite->new->from_filename($tempfile);
  }
  else {
    $handle = Mojo::SQLite->new('urls.db');
  }
  $db = $handle->db;

  print "Using SQLLITE: ".$db->query('select sqlite_version() as version')->hash->{version}."\n";

  # Use migrations to create a table
  $handle->migrations->name('url_shortner')->from_string(<<EOF)->migrate;
-- 1 up
create table urls (id integer primary key autoincrement, shortened text, original text);
-- 1 down
drop table urls;
EOF
}

sub Cleanup {
  my $self = shift;
  
}

1;

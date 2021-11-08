package url_shortner::Model::URL;

use Moo;
use strictures 2;
use namespace::clean;
use Digest::SHA 'sha1_hex';

with 'url_shortner::Model::Record';

has shortened => ( is => 'rw' );
has original => ( is => 'rw' );

=head2 Create C<URL>

Create a new shortened URL. Adds to database then returns a tuple:

[ret, msg]

If success then you can access new values via the object.

=cut

sub Create {
  my $self  = shift;
  my $value = shift;

my $all = $self->db->query('select * from urls')->hashes;

  # If our URL is already in db, just return the existing link
  my $exists = $self->LoadFromOriginal( $value );

  if ( $exists ) {
    print "Existing URL found for $value, returing it!\n";
    $self->original( $value );
    $self->shortened( $exists );
    return;
  }
  print "No existing URL found, shortening!\n";

  my $new = $self->GenerateShortenedURL($value);

  my $ret = $self->db->insert('urls',
    {
      original => $value,
      shortened => $new
    })->last_insert_id;
  unless ( $ret ) {
    print "Could not create new URL entry\n";
  }

  $self->original( $value );
  $self->shortened( $new );
}

=head2 GenerateShortenedURL C<URL>

Hashes our original URL and returns that new hash.

=cut

sub GenerateShortenedURL {
  my $self = shift;
  my $url  = shift;

  my $shortened = substr sha1_hex( $url ), 0, 10;

  return $shortened;
}

=head2 LoadFromOriginal C<Original URL>
=cut

sub LoadFromOriginal {
  my $self  = shift;
  my $value = shift;

  my $results = $self->db->select('urls', ['id'], {original => $value})->hash;
  return unless $results;

  return $results->{'id'};
}

=head2 LoadFromShortened C<shortened URL>
=cut

sub LoadFromShortened {
  my $self  = shift;
  my $value = shift;

  my $results = $self->db->select('urls', ['original'], {shortened => $value})->hash;
  return unless $results;

  return $results->{'original'};
}

1;

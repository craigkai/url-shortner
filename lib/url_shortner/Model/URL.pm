package url_shortner::Model::URL;

use Moo;
use strictures 2;
use namespace::clean;

use Digest::SHA1 qw(sha1_base64);

with 'url_shortner::Model::Record';

has content => ( is => 'rw' );
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
  my $exists = $self->LoadFromOriginal($value);

  if ( $exists ) {
    print "Existing URL found for $value, returing it!\n";
    $self->original( $value );
    $self->content( $exists );
    return;
  }
  print "No existing URL found, shortening!\n";

  my $new = $self->GenerateShortenedURL($value);

  my $ret = $self->db->insert('urls',
    {
      content  => $new,
      original => $value,
    }
  )->last_insert_id;
  unless ( $ret ) {
    print "Could not create new URL entry :/\n";
  }

  $self->original( $value );
  $self->content( $new );
}


=head2 GenerateShortenedURL C<URL>

Hashes our original URL and returns that new hash.

=cut

sub GenerateShortenedURL {
  my $self = shift;
  my $url  = shift;

  # Using SHA1 to generate a short URL because its shorter!
  my $shortened = sha1_base64( $url );

  return $shortened;
}

=head2 LoadFromOriginal C<Original URL>
=cut

sub LoadFromOriginal {
  my $self  = shift;
  my $value = shift;

  my $results = $self->db->select('urls', ['content'], {original => $value})->hash;
  return unless $results;

  return $results->{'content'};
}

=head2 LoadFromShortened C<shortened URL>
=cut

sub LoadFromShortened {
  my $self  = shift;
  my $value = shift;

  my $results = $self->db->select('urls', ['original'], {content => $value})->hash;
  return unless $results;

  return $results->{'original'};
}

1;

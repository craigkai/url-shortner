package url_shortner::Controller::Frontend;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::URL;
use url_shortner::Model::URL;

sub index {
  my $self = shift;

  $self->render('index');
}

=head2 url

Controller for submitting a new URL to be shortened.

On success render the 'new' template with the short URL.

=cut

sub url {
  my $c     = shift;
  my $value = $c->param('newURL');

  return $c->render('index') unless $value;

  # Validate our input is a valid URL
  my $url = Mojo::URL->new( $value );
  return $c->render('index', msg => "Invalid submission")
    unless $url->scheme;

  my $url_obj = url_shortner::Model::URL->new();
  my ($ret, $msg) = $url_obj->Create($value);
  unless ( $ret ) {
    print "Failed to create shortened URL for $value\n";
    return $c->render('index', msg => "Failed to create shortened URL");
  }

  $c->render('new', url => $url_obj->shortened);
}

=head2 Shortened

Controller for loading the expanded URL from the shortened URL.

On success, redirects to the original URL. On failure redirects home with
a generic error message.

=cut

sub shortened {
  my $c = shift;
  my $url = $c->param('url');

  my $url_obj = url_shortner::Model::URL->new();
  my $url_expanded = $url_obj->LoadFromShortened( $url );

  if ( $url_expanded ) {
    $c->redirect_to( $url_expanded );
  }
  else {
    print "Could not load $url from db\n";
    $c->render('index', msg => "URL not found");
  }
}

1;

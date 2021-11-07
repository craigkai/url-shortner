package url_shortner::Controller::Frontend;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::URL;
use url_shortner::Model::URL;

sub index {
  my $self = shift;

  $self->render('index');
}

=head2 new

Creates a new shortened URL in the DB and returns the new
URL string.

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

  $c->render('new', url => $url_obj->content);
}

sub shortened {
  my $c = shift;
  my $url = $c->param('url');

  my $url_obj = url_shortner::Model::URL->new();
  my $url_expanded = $url_obj->LoadFromShortened( $url );

  if ( $url_expanded ) {
    $c->redirect_to( $url_expanded );
  }
  else {
    $c->render('index', msg => "URL not found");
  }
}

1;

package url_shortner;
use Mojo::Base 'Mojolicious';
use url_shortner::Schema;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by config file
  my $config = $self->plugin('Config');

  # Configure the application
  $self->secrets($config->{secrets});

  # Create our db:
  url_shortner::Schema->Create(test => $config->{test_mode});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('Frontend#index');
  # Create a new short url, ideally we should have a better
  # named endpoint like "/api"
  $r->post('/')->to('Frontend#url');

  # Route to handle loading our shortened URLs
  $r->get('/:url')->to('Frontend#shortened');
}

1;

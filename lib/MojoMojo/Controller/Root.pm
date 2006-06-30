package MojoMojo::Controller::Root;

use base 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

=item begin (builtin)

=cut

sub begin : Private {
    my ( $self, $c ) = @_;
    if ( $c->stash->{path} ) {
        my ( $path_pages, $proto_pages ) = 
	    $c->model('DBIC::Page')->path_pages( $c->stash->{path} );
        @{$c->stash}{qw/ path_pages proto_pages /} = 
	    ( $path_pages, $proto_pages );
        $c->stash->{page} = $path_pages->[ @$path_pages - 1 ];
	# FIXME: new user stuff.
         $c->stash->{user} = $c->user->obj() if $c->user_exists && $c->user;
    }
}

=item default (global)

default action - serve the home node

=cut

sub default : Private {
    my ( $self, $c )      = @_;
    $c->stash->{message}  = "Couldn't find that page, Jimmy ".
    '('.$c->stash->{pre_hacked_uri}.')';
    ;
    $c->stash->{template} = 'message.tt';
}

=item end (builtin)

At the end of any request, forward to view unless there is a template
or response. then render the template. If param 'die' is passed, 
show a debug screen.

=cut

sub end : Private {
    my ( $self ) = shift;
    my ( $c ) = @_;
   if ($c->debug && $c->req->params->{dump_info}) {
        foreach my $item (keys %{$c->stash}) {
            undef $c->stash->{$item}->{result_source}
               if $c->stash->{$item}->isa('DBIx::Class');
        }
    }
    $c->stash->{path} ||= '/';
    $c->NEXT::end(@_);
}

=item auto

runs for all requests, checks if user is in need of validation, and 
intercepts the request if so.

=cut

sub auto : Private {
    my ($self,$c) = @_;
    return 1 unless $c->stash->{user};
    return 1 if $c->stash->{user}->active != -1;
    return 1 if $c->req->action eq 'logout';
    $c->stash->{template}='user/validate.tt';
}

1;

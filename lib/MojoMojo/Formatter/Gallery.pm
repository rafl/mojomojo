package MojoMojo::Formatter::Gallery;

use base qw/MojoMojo::Formatter/;

=head1 NAME

MojoMojo::Formatter::Comment - Include comments on your page.

=head1 DESCRIPTION

This is a hook for the page comment functionality. It allows a
comment box to be placed anywhere on your page through the =comments
tag.

=head1 METHODS

=over 4

=item format_content_order

Format order can be 1-99. The Comment formatter runs on 91

=cut

sub format_content_order { 96 }

=item format_content

calls the formatter. Takes a ref to the content as well as the
context object.

=cut

sub format_content {
    my ( $class, $content, $c, $self ) = @_;
    eval {
        $$content =~ s{\<p\>\=gallery\s*\<\/p\>}
                  {show_gallery($c,$c->stash->{page})}me;
    };
}

=item show_comments

Redispatches a subrequest to L<MojoMojo::Controller::Comment>.

=cut

sub show_gallery {
    my ( $c, $page ) = @_;
    return '<div id="gallery">' . $c->view('TT')->render( $c, 'gallery_jquery.tt' ) . '</div>';
}

=back

=head1 SEE ALSO

L<MojoMojo>,L<Module::Pluggable::Ordered>

=head1 AUTHORS

Marcus Ramberg <mramberg@cpan.org>

=head1 LICENSE

This module is licensed under the same terms as Perl itself.

=cut

1;
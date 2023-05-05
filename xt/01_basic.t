use v5.16;
use warnings;

use Test::More;
use Capture::Tiny 'capture';

package Result {
    sub new { my $class = shift; bless {@_}, $class }
    for my $attr (qw(err out exit)) {
        no strict 'refs';
        *$attr = sub { shift->{$attr} };
    }
}

sub run {
    my @argv = @_;
    my ($out, $err, $exit) = capture { system $^X, "-Ilib", "script/tldr", @argv };
    Result->new(out => $out, err => $err, exit => $exit);
}

ok run()->exit != 0;
ok run("--help")->exit == 0;
ok run("--version")->exit == 0;

like run("tar")->out, qr/Archiving utility/;
like run("brew", "-o", "osx")->out, qr/Package manager for macOS/;

done_testing;

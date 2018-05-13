#!/usr/bin/env perl

use 5.016;
use warnings;
use strict;
use IO::Socket;
use Getopt::Long;
use DDP;

sub netcat {
    my $setting = shift;
    my $socket = IO::Socket::INET->new(
        PeerAddr => $setting->{Addr},
        PeerPort => $setting->{Port},
        Proto    => $setting->{Proto},
        Type     => $setting->{Type}
    ) or die "Can't connect to host";
    
    while (<STDIN>) {
        print {$socket} $_;
    }

    local $SIG{ALRM} = sub {say "Сonnection time is out!"; exit;};
    alarm 2;
    while (<$socket>) {
        print $_;
    }	
}

my $setting = {};
GetOptions('u' => \	$setting->{Proto});
if (defined($setting->{Proto})) {
    ($setting->{Proto}, $setting->{Type}) = ('udp', SOCK_DGRAM);
} else {
    ($setting->{Proto}, $setting->{Type}) = ('tcp', SOCK_STREAM);
}
($setting->{Addr}, $setting->{Port}) = @ARGV;

netcat($setting);
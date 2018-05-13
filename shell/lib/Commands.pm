package Commands;

use 5.016;
use warnings;
use strict;

use utf8;
binmode STDOUT, ":utf8";
binmode STDIN, ":utf8";

use Cwd qw(getcwd);

sub use_command {
    my $line = shift;

    if ($line =~ m/^echo\s/) {
        $line =~ s/^echo\s//;
        say $line;
        return 1;
    }

    elsif ($line =~ m/^kill\s/) {
        $line =~ s/^kill\s//;
        $line =~ s/\s+/ /g;
        my $sep = " ";
        my @line = split /$sep/, $line;
        foreach my $proc (@line) {
            eval {kill 'KILL', $proc} or do {say "Wrong signal";};
        }
        return 1;
    }

    elsif ($line =~ m/^cd\s/) {
        $line =~ s/^cd\s//;
        if ($line eq "") {$line = "..";} 
        eval {chdir ($line)} or do {say "Wrong dir";};
        return 1;
    }

    elsif ($line eq "pwd") {
        say getcwd;
        return 1;
    }

    elsif ($line ne "") {
        exec $line or exit;
    }
}

sub execute_command {
    my $self = shift;
    my $pipes = shift;
    my $io_file = shift;
    my $count = @{$pipes};
    my $is_common = 0; # если 0, то команда не наша, а системная

    if ($count == 1 && $pipes->[0] ne "") {
        my $line = shift (@{$pipes});
        $count--;
        pipe (my $in, my $out);

        if (my $pid = fork()) {
            close $out;
            waitpid($pid, 0);
            $is_common = <$in>;
            $is_common = 0 unless defined($is_common);
            exit if $is_common == 1;
            close $in;
        }
        else {
            close $in;
            $is_common = use_command($line);
            print $out $is_common;
            close $out;
        }  
    }

    while ($count > 0) {
        $count--;
        my $line = shift (@{$pipes});
        if (my $pid = fork()) {
            waitpid($pid, 0);
        }
        else {
            pipe(my $from_parent, my $to_child) or die;
            pipe(my $from_child, my $to_parent) or die;
            local $| = 1;

            if (my $pid2 = fork()) {                    
                close $from_parent; close $to_parent;
                open (my $temp_file, "<", $io_file) or exit;
                while (<$temp_file>){
                    print $to_child $_;
                }
                close ($temp_file); close $to_child;
                waitpid($pid2,0);
                open ($temp_file, ">", $io_file) or warn;
                while (<$from_child>){
                    print $temp_file $_;
                }
                close $from_child; close ($temp_file);
                exit;
            } else {
                die "cannot fork: $!" unless defined $pid;
                close $from_child; close $to_child;
                open STDIN, '<&', $from_parent;
                open STDOUT, '>&', $to_parent;
                close $from_parent; close $to_parent;
                use_command($line);
                exit;
            }
        }        
    }
}

1;
#!/usr/bin/env perl

use 5.016;
use warnings;
use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";
use Commands;

use utf8;
binmode STDOUT, ":utf8";
binmode STDIN,  ":utf8";

use Cwd qw(getcwd);

# colors:
my $BLUE = "\x1b[36m";
my $END  = "\x1b[0m";

my $about_shell  = $BLUE."crafting-shell".$END;
my $user_name    = $ENV{LOGNAME} || $ENV{USER} || getpwuid($<);
my $os_separator = File::Spec->catfile('', '');

my $line            = "";
my $pipe_sign       = quotemeta("|");
my @pipes;

my $file_name   = ".io.buffer";
my $pwd_to_file = getcwd;
my $io_file = $pwd_to_file.$os_separator.$file_name;
open (my $temp_file, ">", $io_file) or warn; # создаем файл

while ($line ne "exit") {
    $SIG{INT} = 'IGNORE';

    # Обработка команд
    if ($line =~ m/\|/) {
        @pipes = split /$pipe_sign/, $line;
        foreach my $command (@pipes){
            $command =~ s/^\s+//;
            $command =~ s/\s+$//;
        }
    } else {
        @pipes = ($line);
    }
    Commands->execute_command(\@pipes, $io_file);
    open ($temp_file, "<", $io_file) or warn; # вывод из буфиризированного
    while (<$temp_file>) {
        print $_;
    }
    open ($temp_file, ">", $io_file) or warn; # очищаем содержимое файла

    # Внешний вид 
    if (getcwd ne $os_separator) {
        my @local_dir = split /$os_separator/, getcwd;
        printf("%s:%s %s$BLUE\$$END ", $about_shell, $local_dir[-1], $user_name);
    } else {
        printf("%s: %s$BLUE\$$END ", $about_shell, $user_name);
    }

    # Обработка строки
    $line = <STDIN>;
    if (defined($line)) {
        chomp($line);
        $line =~ s/^\s+//;
    } else {
        $line = "";
        print "\n";
    }
}

close ($temp_file);
unlink $io_file or warn;
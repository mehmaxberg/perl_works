#!/usr/bin/env perl

use 5.016;
use warnings;
use strict;
# В качестве аргумента можно подавать комплексное число в виде реальная часть мнимая часть, если нужны только действительные числа
# каждый четный аргумент можно задавать как 0
# error processing

die "\x1b[31m"."Sorry, but you must push 6 arguments, where every odd number is real, but an even image number\nFor example:
1) perl equation.pl 1 -3 3.4 3.2 2 3\n2) perl equation.pl 2 -3 3 0 0 4"."\x1b[0m"."\n" if (@ARGV != 6);
die "\x1b[31m"."Sorry, but your first and second argument can't be 0\n"."\x1b[0m"."\n" if ($ARGV[0] == 0 && $ARGV[1] == 0);
for (my $i = 0; $i < @ARGV; $i++){
    die "\x1b[31m"."Sorry, but your arguments must be real numbers\nFor example:
    1) perl equation.pl 5.3\n2) perl equation.pl 11 34.3 2.5"."\x1b[0m"."\n" if !("".(0 + $ARGV[$i]) eq $ARGV[$i]) && $ARGV[$i] ne "";
}

sub imagesqrt {
    my $reD = shift; # imagesqrt не работает с мнимой частью
    if ($reD >= 0) {
        return sqrt($reD), 0;
    } else {
        return 0, sqrt(-$reD);
    }
}
sub imagemult { #умножение мнимых чисел
    my $re1 = shift;
    my $im1 = shift;
    my $re2 = shift;
    my $im2 = shift;
    return $re1*$re2 - $im1*$im2, $re1*$im2 + $re2*$im1;
}
sub imagedivide { #сложение мнимых чисел
    my $re1 = shift;
    my $im1 = shift;
    my $re2 = shift;
    my $im2 = shift;
    return ($re1*$re2 + $im1*$im2)/($re2 ** 2 + $im2 ** 2), ($re2*$im1 - $re1*$im2)/($re2 ** 2 + $im2 ** 2);
}
sub imageadd { #деление мнимых чисел
    my $re1 = shift;
    my $im1 = shift;
    my $re2 = shift;
    my $im2 = shift;
    return $re1+$re2,$im1+$im2;
}
for (my $i = 0; $i < 6; $i++) {if ($ARGV[$i] eq "") {$ARGV[$i]=0}} # обнуляем коэффициенты, если они были равны пустой сроке
my ($a, $ia, $b, $ib, $c, $ic) = ($ARGV[0], $ARGV[1], $ARGV[2], $ARGV[3], $ARGV[4], $ARGV[5]);
print "You write ($a + $ia*i)*x*x + ($b + $ib*i)*x + ($c + $ic*i)\n";
my ($rex1, $imx1, $rex2, $imx2); # объявляем корни уравнения в формате: реальная часть мнимая часть
my $tempsign1 = "+"; # если мнимая часть 1 корня будет положительна
my $tempsign2 = "+"; # если мнимая часть 2 корня будет положительна
my ($reD, $imD) = imageadd(imagemult($b, $ib, $b, $ib),imagemult(imagemult($a, $ia, $c, $ic), -4, 0)); # D = b*b - 4*a*c
my ($sqreD,$sqimD) = imagesqrt($reD); #sqrtD
($rex1, $imx1) = imagedivide(imageadd(-$b,-$ib, $sqreD, $sqimD),2*$a,2*$ia); #x1 = (-b + sqrtD)/2*a
($rex2, $imx2) = imagedivide(imageadd(-$b,-$ib, -$sqreD, -$sqimD),2*$a,2*$ia); #x2 = (-b - sqrtD)/2*a

if ($imx1 < 0) {$tempsign1 = ""}; # смотри line 47
if ($imx2 < 0) {$tempsign2 = ""}; # смотри line 48
if ($rex1 == $rex2 && $imx1 == $imx2) { # проверка на еквиволентность корней, если равны -> выводим один
    print "x=".$rex1.$tempsign1.$imx1."*i"."\n";
} else {print "x1=".$rex1.$tempsign1.$imx1."*i"." x2=".$rex2.$tempsign2.$imx2."*i"."\n";}


#!/usr/bin/env perl
use 5.016;
use warnings;
use strict;
use Getopt::Long; 
use Scalar::Util 'looks_like_number';

my %arrayofmonth = ("JAN" => 0,"FEB" => 1,"MAR" => 2,"APR" => 3,"MAY" => 4,"JUN" => 5,
"JUL" => 6,"AUG" => 7,"SEP" => 8,"OCT" => 9,"NOV" => 10,"DEC" => 11);
my ($key_k, $key_n, $key_r, $key_u, $key_M, $key_b, $key_c, $key_h) = ('', '', '', '', '', '', '', '');
GetOptions('k:i'=> \$key_k,'n'=> \$key_n,'r'=> \$key_r,'u'=> \$key_u,'M'=> \$key_M,'b'=> \$key_b,'c'=> \$key_c,'h'=> \$key_h);
if ($key_k ne "") {die "k must be more than 0" if ($key_k < 1);}
my @all_lines;
my @untouched_all_lines;

do {
    push (@untouched_all_lines, <>);
} while (<>);

@all_lines = sort @untouched_all_lines;

if ($key_b){key_b_sub(\@all_lines)}
if ($key_h){key_n_sub(\@all_lines)}
if ($key_n){key_n_sub(\@all_lines)}
if ($key_k){key_k_sub_string(\@all_lines, $key_k)}
if ($key_k && ($key_n || $key_h)){key_k_sub(\@all_lines, $key_k)}
if ($key_M){key_M_sub(\@all_lines, $key_k)}
if ($key_r){key_r_sub(\@all_lines)}
if ($key_u){key_u_sub(\@all_lines)}
if ($key_c){key_c_sub()}

say @all_lines;

sub smartmonthsub { # возвращает номер месяца
    my $line = shift;
    my $number = shift;
    if ($key_h){
        $line =~ s/\d\Kk/000/g; # кило
        $line =~ s/\d\KM/000000/g; # мега
        $line =~ s/\d\KG/000000000/g; # гига 
        $line =~ s/\d\KT/000000000000/g; # тера 
    }
    if ($key_b){ 
        $line =~ s/\s+/ /g;
        $line =~ s/\A\s//g;
        }
    $line =~ s/\S\K\s/<,>/g; # <,> - разделитель, по которому будем разбивать слова в массив
    my @line = split /<,>/, $line;    
    my $firstsign = rindex($line[$number - 1], " ") + 1; # берем индекс самого последнего пробела перед словом
    my $hashval = $arrayofmonth{uc(substr($line[$number - 1], $firstsign, 3))}; # сравниваем первые 3 символа слова с ключом хэша месяцев
    if ($number <= @line && $hashval){
        return $hashval;
    } 
    else {return 0};
}
sub smartnumbersub_n { # возвращает числовое значение строки
    my $line = shift;
    if ($key_h){
        $line =~ s/\d\Kk/000/g; # кило
        $line =~ s/\d\KM/000000/g; # мега
        $line =~ s/\d\KG/000000000/g; # гига 
        $line =~ s/\d\KT/000000000000/g; # тера 
    }
    $line =~ s/\s+//g;    # ликвидируем стандартные разделители
    $line =~ s/\w\K[+-]/<,>/g;    # отбрасываем, встречающиеся в середине строке + и -
    $line =~ s/[A-Za-z]+/<,>/g;    # заменяем нечисловые символы разделителями, чтобы потом отсечь первое число
    my @line = split /<,>/, $line;    
    if (index($line[0],'+') != -1){  # если число начинается с +, то обрабатываем как строку
        return 0;
    }
    if (looks_like_number($line[0])){ 
        return $line[0];
    } else {return 0};
}
sub smartsubstring { # возвращает указанный аргумент из строки по номеру
    my $line = shift;
    my $number = shift;
    my $choice = shift; # принимает 0 или 1, при 0 работает с числами, при 1 со строками
    if ($key_h){
        $line =~ s/\d\Kk/000/g; # кило
        $line =~ s/\d\KM/000000/g; # мега
        $line =~ s/\d\KG/000000000/g; # гига 
        $line =~ s/\d\KT/000000000000/g; # тера 
    }
    if ($key_b){ 
        $line =~ s/\s+/ /g;
        $line =~ s/\A\s//g;
        }
    $line =~ s/\S\K\s/<,>/g; # <,> - разделитель, по которому будем разбивать слова в массив
    my @line = split /<,>/, $line; 
    if ($choice == 1){
        if ($number <= @line){
            return fc($line[$number - 1]);
        } else {return ""}
    }
    else {
        if ($number > @line) {return 0}
        $line[$number - 1] =~ s/\w\K[+-]/<,>/g;    # отбрасываем, встречающиеся в середине строки + и -
        if (index($line[$number - 1], "<,>") != -1){
            $line[$number - 1] = substr ($line[$number - 1], 0, index($line[$number - 1], "<,>"));
        }
        if (index($line[$number - 1],'+') != -1){  # если число начинается с +, то обрабатываем как строку  
            return 0;
        }

        $line[$number - 1] =~ s/[A-Za-z]\K/<,>/g; # от числа оставляем только то, что идет до первой буквы
        if (index($line[$number - 1], "<,>") != -1){
            $line[$number - 1] = substr ($line[$number - 1], 0, index($line[$number - 1], "<,>")-1);
        }   
        if (looks_like_number($line[$number - 1])){ 
            return $line[$number - 1];
        } else {return 0};
    }
}

sub key_k_sub { # сортировка чисел по колонке 
    my $ref_on_all_lines = shift;
    my $index_k = shift;
    @{$ref_on_all_lines} = sort {
    smartsubstring($a, $index_k, 0) <=> smartsubstring($b, $index_k, 0)
    ||
    smartsubstring($a, $index_k, 1) cmp smartsubstring($b, $index_k, 1)
    } @{$ref_on_all_lines};
    return 1;
}

sub key_k_sub_string { # сортировка строк по колонке  
    my $ref_on_all_lines = shift;
    my $index_k = shift;
    @{$ref_on_all_lines} = sort {smartsubstring($a, $index_k, 1) cmp smartsubstring($b, $index_k, 1)} @{$ref_on_all_lines};
    return 1;
}

sub key_n_sub { # сортировка по числовому значению
    my $ref_on_all_lines = shift;
    @{$ref_on_all_lines} = sort {smartnumbersub_n($a) <=> smartnumbersub_n($b) || fc($a) cmp fc($b)} @{$ref_on_all_lines};
    return 1;
}

sub key_b_sub { # сортировка без начальных пробелов
    my $ref_on_all_lines = shift;
    @{$ref_on_all_lines} = sort {smartsub_b($a) cmp smartsub_b($b)} @{$ref_on_all_lines};
    return 1;
}
sub smartsub_b {
    my $line = shift;
    if ($key_h){
        $line =~ s/\d\Kk/000/g; # кило
        $line =~ s/\d\KM/000000/g; # мега
        $line =~ s/\d\KG/000000000/g; # гига 
        $line =~ s/\d\KT/000000000000/g; # тера 
    }
    $line =~ s/\s+//g;    # ликвидируем стандартные разделители  
    return fc($line);
}

sub key_r_sub { # обратная сортировка
    my $ref_on_all_lines = shift;
    @{$ref_on_all_lines} = reverse @{$ref_on_all_lines};
    return 1;
}

sub key_u_sub { # удаление одинаковых строк
    my $ref_on_all_lines = shift;
    for my $i (1..@{$ref_on_all_lines}-1){
        if (@{$ref_on_all_lines}[$i] eq @{$ref_on_all_lines}[$i-1]){
            @{$ref_on_all_lines}[$i-1] = "";
        }
    }
    return 1;
}

sub key_M_sub { # сортировка по месяцу
    my $ref_on_all_lines = shift;
    my $index_k = shift;
    if ($index_k eq "") {$index_k = 1}
    @{$ref_on_all_lines} = sort {smartmonthsub($a, $index_k) <=> smartmonthsub($b, $index_k)} @{$ref_on_all_lines};
    return 1;
}

sub key_c_sub { # отсортированы ли данные
    for my $i (0..@all_lines-1){
        if ($all_lines[$i] ne $untouched_all_lines[$i]){
        say "Wrong order: line ", $i+1;
        return 0;}
    }
    say "Correct order";
    return 1;
}
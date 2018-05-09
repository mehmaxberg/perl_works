package DeepClone;
# vim: noet:

use 5.016;
use warnings;
use strict;

=encoding UTF8

=head1 SYNOPSIS

Клонирование сложных структур данных

=head1 clone($orig)

Функция принимает на вход ссылку на какую либо структуру данных и отдаюет, в качестве результата, ее точную независимую копию.
Это значит, что ни один элемент результирующей структуры, не может ссылаться на элементы исходной, но при этом она должна в точности повторять ее схему.

Входные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив и хеш, могут быть любые из указанных выше конструкций.
Любые отличные от указанных типы данных -- недопустимы. В этом случае результатом клонирования должен быть undef.

Выходные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив или хеш, не могут быть ссылки на массивы и хеши исходной структуры данных.

=cut
sub clone {
	my $orig = shift;
	my $hash_val = {};
	my $cloned = create_arr($orig, $hash_val);
	return $cloned;
}

sub create_arr {
	my $orig = shift;
	my $hash_val = shift;
	if (defined($orig)){
		return $orig;
	}
	if (!defined($orig)){
		return undef;
	}
	if (ref($orig) eq "REF"){
		$hash_val->{$orig} = $orig;
		if (exists($hash_val->{$$orig})){
			return \$hash_val->{$$orig};
		}
		return \create_arr($$orig,$hash_val);
	}
	if (ref($orig) eq "SCALAR"){
		return \create_arr($$orig,$hash_val);
	}
	if (ref($orig) eq "ARRAY"){
		my $temp_arr = [];
		$hash_val->{$orig} = $temp_arr;
		foreach my $var (@$orig){
			if (exists($hash_val->{$var})){
				push (@$temp_arr, $hash_val->{$var});
			} else{
				push (@$temp_arr, create_arr($var,$hash_val));
			}
		}
		return $temp_arr;
	}
	if (ref($orig) eq "HASH"){
		my $temp_hash = {};
		$hash_val->{$orig} = $temp_hash;
		for my $k (sort keys %$orig){
			my $v = $orig->{$k};
			if (exists($hash_val->{$v})){
				$temp_hash->{$k} = $hash_val->{$v};
			} else {
				$temp_hash->{$k} = create_arr($v,$hash_val);
			}
		}
		return $temp_hash;
	}
}

1;
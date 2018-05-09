package Anagram;
# vim: noet:

use 5.016;
use warnings;
use strict;
use utf8;
binmode STDOUT, ":utf8";
binmode STDIN, ":utf8";

=encoding UTF8

=head1 SYNOPSIS

Поиск анаграмм

=head1 anagram($arrayref)

Функция поиска всех множеств анаграмм по словарю.

Входные данные для функции: ссылка на массив - каждый элемент которого - слово на русском языке в кодировке utf8

Выходные данные: Ссылка на хеш множеств анаграмм.

Ключ - первое встретившееся в словаре слово из множества
Значение - ссылка на массив, каждый элемент которого слово из множества, в том порядке в котором оно встретилось в словаре в первый раз.

Множества из одного элемента не должны попасть в результат.

Все слова должны быть приведены к нижнему регистру.
В результирующем множестве каждое слово должно встречаться только один раз.
Например

anagram(['пятак', 'ЛиСток', 'пятка', 'стул', 'ПяТаК', 'слиток', 'тяпка', 'столик', 'слиток'])

должен вернуть ссылку на хеш


{
	'пятак'  => ['пятак', 'пятка', 'тяпка'],
	'листок' => ['листок', 'слиток', 'столик'],
}

=cut
sub lc_world { # меняет исходное слово
	my $world = shift;
	chomp($$world);
	$$world = lc($$world);
	return ($$world);
}

sub world_return { # исходное слово не меняется
	my $world = shift;
	my @world = split(//, $world);
	@world = sort @world;
	$world = join('', @world);
	return $world;
}

sub anagram {
	my $list = shift;
	my %result;
	my @firstworld_arr;
	foreach my $var (@$list){
		my $world = lc_world(\$var);
		my $sorted_world = world_return($var);
		unless (exists $result{$sorted_world}){ # первое попадение слова
			$result{$sorted_world} = $result{$world};
			push (@firstworld_arr, $sorted_world); # ключи сразу сохраняем в новый массив, их имена исправим позже
		}
		push (@{$result{$sorted_world}}, $world) unless grep {$_ eq $world}@{$result{$sorted_world}};
	}

	foreach my $world (@firstworld_arr){ # проходимся второй раз для корректировки названия ключей
		if (@{$result{$world}} == 1){
			delete $result{$world};
			next;
		}
		$result{${$result{$world}}[0]} = $result{$world};
		delete $result{$world};
	}
	return \%result;
}

1;

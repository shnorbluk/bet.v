module read_csv

fn readcsv(str string) []Game {
	ret := read_csv.read_csv_no_header(str) or {
		panic(err)
	}
	check_all_games_have_odds(ret)
	return ret
}

fn test_empty_string_means_no_row() {
	arr := []Game{}
	games := readcsv('')
	assert games == arr
}

fn check_all_games_have_odds (games []Game) {
	for game in games {
		game.arr.len > 0
	}
}

fn test_1line_gives_1row() {
	assert readcsv('toto;2;3;1').len == 1
}

fn test_3lines_gives_3rows() {
	assert readcsv('1;1;1;1\n2;2;2;2\n3;3;3;3').len == 3
}

fn test_fields_are_separated_by_semicolon() {
	s1 := '1,2,3,1'
	read_csv.read_csv_no_header(s1) or {
		return
	}
	assert false
}

fn test_1st_column_is_dom() {
	assert readcsv('1;2;3;1')[0].get_odds(.dom).ratio == 1.
}

fn test_2nd_field_is_nul() {
	assert readcsv('1;2;3;1')[0].get_odds(.nul).ratio == 2.
}

fn test_3rd_field_is_ext() {
	assert readcsv('1;2;3.1;1')[0].get_odds(.ext).ratio == f32(3.1)
}

fn test_1_on_4th_field_means_dom_wins() {
	assert readcsv('1;2;3;1')[0].get_odds(.dom).winning == true
	assert readcsv('1;2;3;2')[0].get_odds(.dom).winning == false
}

fn test_2_on_4th_field_means_nul_wins() {
	assert readcsv('1;2;3;2')[0].get_odds(.nul).winning == true
	assert readcsv('1;2;3;1')[0].get_odds(.nul).winning == false
}

fn test_3_on_4th_field_means_nul_wins() {
	assert readcsv('1;2;3;3')[0].get_odds(.ext).winning == true
	assert readcsv('1;2;3;1')[0].get_odds(.ext).winning == false
}

fn test_ignore_first_line_when_csv_has_header() {
	games := read_csv.read_csv_with_header('header\n1;2;3;3') or {
		panic(err)
	}
	assert games[0].get_odds(.ext).winning == true
	check_all_games_have_odds(games)
}

// TODO Ajouter un flag "has header" à la ligne de commande
// TODO Sortir du main tout ce qui est testable (parsing d'arguments)
// TODO Faire un implem.v qui contient LocalFileReader implémentant FileReader et SimpleDisplay

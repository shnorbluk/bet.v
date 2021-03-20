module read_csv

pub fn read_csv_no_header(str string) ?[]Game {
	return read_csv_starting_at_line(str, 0)
}

//TODO remplacer les []Game par un Games dont le constructeur vérifie que tous
//les champs obligatoires sont remplis

fn read_csv_starting_at_line(str string, start byte) ?[]Game {
	lines := str.split('\n')
	nb_lines := lines.len - start
	mut rows := []Game{len: nb_lines}
	if lines.len > start {
	for i, line in lines[start..lines.len] {
		rows[i] = game_from_line(line) ?
	}
	}
	return rows
}

pub fn read_csv_with_header(str string) ?[]Game {
	return read_csv_starting_at_line(str, 1)
}

pub struct Game {
	arr []Odds
}

struct Odds {
pub:
	ratio   f32
	winning bool
}

fn (o Odds) equals(ot Odds) bool {
	return o.ratio == ot.ratio && o.winning == ot.winning
}

pub fn (g Game) equals(o Game) bool {
	for i, _ in g.arr {
		if !g.arr[i].equals(o.arr[i]) {
			return false
		}
	}
	return true
}

pub fn (g Game) get_odds(r GameResult) Odds {
	i := match r {
		.dom { 0 }
		.nul { 1 }
		.ext { 2 }
	}
	return g.arr[i]
}

fn game_from_line(line string) ?Game {
	fields := line.split(';')
	if fields.len < 4 {
		return error('Line does not contain 4 semicolon delimited fields: $line')
	}
	array := [
		odds_from_field(fields, 1),
		odds_from_field(fields, 2),
		odds_from_field(fields, 3),
	]
	return Game{
		arr: array
	}
}

fn odds_from_field(fields []string, index int) Odds {
	return Odds{
		ratio: fields[index - 1].f32()
		winning: fields[3] == index.str()
	}
}

pub enum GameResult {
	dom
	nul
	ext
}
fn readcsv1 (csv string, has_header bool) ?[]Game {
	/*
	mut result := []read_csv.Game{}
	if has_header {
		result = read_csv.read_csv_with_header(csv)?
	} else {
		result = read_csv.read_csv_no_header(csv)?
	}
	*/
        result := if has_header {
	       read_csv_with_header(csv)
	} else {
		read_csv_no_header(csv)
	} 
	return result
}
pub fn readcsv(csv string, has_header bool) []Game {
	result := readcsv1(csv, has_header) or {

		println("Erreur d'analyse du csv")
		println(csv)
		panic(err)
	}

	return result
}


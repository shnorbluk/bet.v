module strategy

import read_csv { Game }
import bet { Bet }
import log { Log }

pub interface Strategy {
	place_bets(g Game) []Bet
	description() string
	to_str() string 
}

fn arr_to_str(a []Strategy) string {
	mut result := "["
	for o in a {
		result += ", ${o.to_str()}"
	}
	return result + "]"
}

pub struct HomeStrategy {
}

pub fn (s HomeStrategy) description() string {
	return 'Toutes les victoires à domicile'
}

pub fn (s HomeStrategy) to_str() string {
	return s.description()
}

pub fn (s HomeStrategy) place_bets(g Game) []Bet {
	return [Bet{
		game: g
		game_result: .dom
		amount: 1
	}]
}
//pub struct Amount{val f32}
//pub type Amount = f32
//pub fn (a Amount) str() string {
	//return "toto" //a.to_str()
//}

//pub fn (a Amount) to_str() string {
	//return f32(a).str()
	//return "toto" //f64(a).str()
//}

/*
fn useless_function() Strategy {
	return PassiveStrategy{}
}

struct PassiveStrategy {}

pub fn (s PassiveStrategy) description() string {
	return 'passif'
}

fn (s PassiveStrategy) place_bets(_ Game) []Bet {
	return []Bet{}
}

fn (s PassiveStrategy) to_str() string {
	return "PassiveStrategy{}"
}
type StratSum = HomeStrategy | PassiveStrategy

fn (s StratSum) description() string {
	return descr(s)
}

*/
//TODO Intégrer dans un betplay.v
interface Displayer {
	display(strategy string, balance f32) 
	to_str() string
}

/*

fn fonction_inutile(d Displayer, s Strategy) Displayer {
	return NoneDisplayer{}
}
*/

fn displayer_arr_to_str(a []Displayer) string {
	mut result := "["
	for displayer in a {
		result += ", ${displayer.to_str()}"
	}
	return result + "]"
}

pub struct SimpleDisplayer {
}

pub fn (mut d SimpleDisplayer) display(strategy string, balance f32) {
	println("${strategy}: ${balance}")
}

fn (d SimpleDisplayer) to_str() string {
	return "SimpleDisplayer{}"
}

/*
*/
/*
fn descr(s StratSum) string {
	match s {
		HomeStrategy {
			return s.description()
		}
		PassiveStrategy {
			return s.description()
		}
	}
	panic("Object type unknown")
}
*/

//TODO remplacer PlayOptions par Strategy.play(BetPlay):f32 et
//BetPlay{init_balance, games}, et playAll(stategies, BetPlay,
//OutputWriter, log) et Csv{source string, has_header}.parse():[]Game
struct PlayOptions {
	csv string
	init_balance f32
	strategies []Strategy
	displayer Displayer
	csv_has_header bool
}

fn (o PlayOptions) str() string {
	return "PlayOptions{csv:'${o.csv}', init_balance:${o.init_balance}, strategies:'${arr_to_str(o.strategies)}', displayer:'${o.displayer.to_str()}', csv_has_header:${o.csv_has_header}}"
}

interface OutputWriter {
	write(str string) 
}
struct ConsoleWriter {}
fn (_ ConsoleWriter) write(str string) {
	println(str)
}
struct BetPlayResult {
	strategy Strategy
	balance f32
}
fn (r BetPlayResult) str() string {
	return "${r.strategy.description()}: ${r.balance}"
}
pub fn play(opt PlayOptions, mut logger log.Log) []BetPlayResult {
	logger.debug("play() opt=$opt")
	games := read_csv.readcsv(opt.csv, opt.csv_has_header) 
	logger.debug("play() games=$games")
	mut result := []BetPlayResult{}
	for strategy in opt.strategies {
		mut balance := opt.init_balance
		for game in games {
			//if game.arr.len==0 {
				//panic("Error with csv: ${opt.csv}")
			//}
			bets := strategy.place_bets(game)
			for mut bet in bets {
				balance = bet.new_balance_after(balance)
			}
		}
		logger.debug("play() strategy=${strategy.to_str()} balance=${balance}")
		//opt.displayer.display((strategy).description(), balance)
		result << BetPlayResult{strategy: strategy, balance: balance}
	}
	return result	
}
	/*
	*/

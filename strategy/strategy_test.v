module strategy

import read_csv { Game }
import log { Log }

fn place_bets(s Strategy) []Bet {
	games := read_csv.read_csv_no_header('2.2;2;3;1') or {
		println("Error parsing csv")
		panic(err)
	}
	return s.place_bets(games[0])
}

// TODO traduire dom, nul, ext dans l'enum
// TODO Remplacer les f32 par un type Amount et un type Rate
fn test_passive_strategy_places_no_bet() {
	strat := PassiveStrategy{}
	game := Game{}
	bets := strat.place_bets(game)
	assert bets.len == 0
}

struct PassiveStrategy {
}

fn (s PassiveStrategy) place_bets(_ Game) []Bet {
	return []Bet{}
}

fn (s PassiveStrategy) description() string {
	return 'passive'
}

pub fn (s PassiveStrategy) to_str() string {
	return (s).description()
}


pub struct NoneDisplayer {
mut:
	strategy []string
	balance  []f32
}

pub fn (mut d NoneDisplayer) display(strategy string, balance f32) {
	d.strategy << strategy
	d.balance << balance
}

fn (d NoneDisplayer) to_str() string {
	return "NoneDisplayer{strategies:${d.strategy}, balances:${d.balance}}"
}


//TODO ajouter un type csv_string
//TODO test_csv_with_header_has_at_least_2_lines
fn test_home_strategy_places_bet_at_home() {
	strat := HomeStrategy{}
	bets := place_bets(strat)
	assert bets.len == 1
	assert bets[0].game_result == .dom
}

fn test_keep_first_line_when_csv_has_no_header() {
	csv := '2.2;2;3;1\n2.2;2;3;2\n2.2;2;3;1'
	mut strategies := []Strategy{}
	strategies << PassiveStrategy{}
	strategies << HomeStrategy{}
	mut logger := Log {level:.info}
	logger.debug('strategies.len=${strategies.len}')
	displayer := NoneDisplayer{}
	mut displayers := []Displayer{}
	displayers << displayer
	opt := PlayOptions{csv:csv, init_balance: f32(1000), strategies: strategies, displayer: displayers[0], csv_has_header: false}
	result := play(opt, mut logger)
	expected_balance := f32(1000 + 2.2 + 2.2 - 3)
	assert result[1].balance == expected_balance
}

fn test_ignore_first_line_when_has_header() {
	csv := '2.2;2;3;1\n2.2;2;3;2\n2.2;2;3;1'
	mut strategies := []Strategy{}
	strategies << PassiveStrategy{}
	strategies << HomeStrategy{}
	displayer := NoneDisplayer{}
	mut displayers := []Displayer{}
	displayers << displayer
	opt := PlayOptions{csv:csv, init_balance: 1000, strategies: strategies, displayer: displayers[0], csv_has_header: true}
	mut logger := log.Log{}
	result := play(opt, mut logger)
	assert result[1].balance == f32(1000 + 2.2 - 2)
}

fn test_play_applies_all_strategies_on_all_games() {
	csv := '2.2;2;3;1\n2.2;2;3;2\n2.2;2;3;1'
	mut strategies := []Strategy{}
	strategies << PassiveStrategy{}
	strategies << HomeStrategy{}
	displayer := NoneDisplayer{}
	mut displayers := []Displayer{}
	displayers << displayer
	mut logger := Log{}
	opt := PlayOptions{csv:csv, init_balance: 1000, strategies: strategies, displayer: displayers[0], csv_has_header: false}
	result := play(opt, mut logger)
	assert result[0].strategy.description() == strategies[0].description()
	assert result[0].balance == 1000
	assert result[1].strategy.description() == strategies[1].description()
	assert result[1].balance == f32(1000 + 2.2 + 2.2 - 3)
}
/*
*/
fn passive_strategy() Strategy {
	return PassiveStrategy{}
}

fn test_simple_display_shows_strategy_colon_balance_results() {
	result := BetPlayResult{strategy: passive_strategy(), balance: 1.1}
	assert result.str() == "passive: 1.1"

}

import bet { Bet }
import read_csv

fn bet(amount f32, game_result read_csv.GameResult) Bet {
	games := read_csv.read_csv_no_header('2.2;2;3;1') or {
		panic(err)
	}
	return Bet{
		amount: amount
		game: games[0]
		game_result: game_result
	}
}

fn test_bet_on_winning_odds_wins() {
	result := bet(1, .dom).result()
	assert result > 0
}

fn test_bet_on_losing_odds_loses() {
	result := bet(1, .ext).result()
	assert result == 0
}

fn test_gain_is_bet_times_winning_coeff() {
	result := bet(1.1, .dom).result()
	assert result == f32(1.1 * 2.2)
}

fn test_net_loss_is_bet_amount() {
	mut the_bet := bet(1.1, .nul)
	result := the_bet.new_balance_after(f32(1000.))
	assert result == f32(998.9)
}

fn test_balance_is_loss_and_gain_cumul() {
	mut balance := f32(1000.)
	mut the_bet := bet(1,.dom)
	balance = the_bet.new_balance_after(balance)
	the_bet = bet(1,.nul)
	balance = the_bet.new_balance_after(balance)
	the_bet = bet(1, .ext)
	balance = the_bet.new_balance_after(balance)
	assert balance == f32(1000. - 3 + 2.2)
}

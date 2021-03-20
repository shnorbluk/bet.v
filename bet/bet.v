module bet

import read_csv
import log //{ Log }

pub fn (bet Bet) result() f32 {
	odds := bet.game.get_odds(bet.game_result)
	return f32(if odds.winning {
		bet.amount * odds.ratio
	} else {
		0
	})
}

fn (mut bet Bet) new_balance_after(current_balance f32) f32 {
	bet.logger.debug("current_balance=$current_balance")
	new_balance := current_balance + bet.result() - bet.amount
	bet.logger.debug("new_balance=$new_balance")
	return new_balance
}

pub struct Bet {
	amount      f32
	game        read_csv.Game
	game_result read_csv.GameResult
	mut:
	logger log.Log
}

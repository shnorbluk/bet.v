module integ

pub fn play_all(opt PlayOptions, mut logger log.Log) []BetPlayResult {
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


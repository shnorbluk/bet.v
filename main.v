import cli { Command, Flag }
import os
import strategy { HomeStrategy, play, Amount }

fn main() {
	parse_args()
}

fn parse_args() {
	mut cmd := Command{
		name: 'pari'
		description: 'Application de simulation de paris paris sportifs'
		execute: run
		version: '0.0.1'
	}
	cmd.add_flag(Flag{
		flag: .string
		required: true
		name: 'csv-file'
		abbrev: 'f'
		description: 'CSV file'
	})
	cmd.add_flag(Flag{
		flag: .int
		required: false
		name: 'balance'
		abbrev: 'b'
		value: '1000'
		description: 'Initial balance'
	})
	cmd.parse(os.args)
}

fn run(cmd Command) {
	path := cmd.flags.get_string('csv-file') or {
		panic(err)
	}
	balance_int := cmd.flags.get_int('balance') or {
		panic(err)
	}
	balance := f32(balance_int)
	println('file=$path balance=$balance')
	csv := os.read_file(path.trim_space()) or {
		println('failed to open $path')
		exit(1)
	}
	mut strategies := []strategy.Strategy{}
	strategies << strategy.HomeStrategy{}
	play(csv: csv, init_balance: (balance), strategies: strategies, display: SimpleDisplay{}, has_header: true)
}

struct SimpleDisplay {
}

fn (_ SimpleDisplay) display(strategy string, balance strategy.Amount) {
	println('$strategy: $balance')
}

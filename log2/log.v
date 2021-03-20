
module log

interface OutputWriter {
	write (msg string)
}
struct ConsoleWriter{}
fn (w ConsoleWriter) write(msg string) {
	println(msg)
}
pub struct Logger {
	writer OutputWriter
	mut:
	debug_enabled bool
}
pub fn new(writer OutputWriter) Logger {
	return Logger{ writer: writer}
}
pub fn console_logger() Logger {
       return new(ConsoleWriter{})
}
pub fn (l Logger) debug(msg string) {
	if l.debug_enabled {
	l.writer.write(msg)
	}
}

pub fn (mut l Logger) enable_debug() {
	l.debug_enabled = true
}

pub fn (mut l Logger) disable_debug() {
	l.debug_enabled = false
}

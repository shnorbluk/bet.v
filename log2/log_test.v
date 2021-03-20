module log

struct FakeOutputWriter {
	mut:
	text []string
}
fn (mut w FakeOutputWriter) write(msg string) {
	w.text << msg
}

fn test_log_debug_logs_if_debug_enabled() {
	writer := FakeOutputWriter{text: []string{} }
	mut logger := new(writer)
	logger.enable_debug()
	logger.debug("toto")
	assert(writer.text[0] == "toto")
}

fn test_log_debug_doesnt_log_if_debug_disabled() {
	writer := FakeOutputWriter{text: []string{} }
	mut logger := new(writer)
	logger.disable_debug()
	logger.debug("toto")
	assert writer.text.len == 0
}

fn test_debug_disabled_by_default() {
	logger := Logger{}
	assert !logger.debug_enabled
}

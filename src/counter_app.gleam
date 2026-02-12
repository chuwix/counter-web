import gleam/io
import counter_display as display
import counter_input as input
import counter_web as web

pub fn main() -> Nil {
  io.println("counter_web boot")
  display.show_placeholder()
  input.log_startup()
  web.start()
}

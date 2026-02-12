import gleam/io

pub type ButtonEvent {
  Up
  Down
  Confirm
}

pub fn log_startup() -> Nil {
  io.println("[input] ready to log button presses")
}

pub fn log_event(event: ButtonEvent) -> Nil {
  io.println("[input] button " <> event_label(event))
}

fn event_label(event: ButtonEvent) -> String {
  case event {
    Up -> "up"
    Down -> "down"
    Confirm -> "confirm"
  }
}

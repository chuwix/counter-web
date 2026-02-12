import gleam/io

pub fn start() -> Nil {
  io.println("[web] /health returns 200 OK")
}

pub fn health_response() -> String {
  "OK"
}

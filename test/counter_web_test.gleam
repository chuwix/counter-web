import gleeunit
import gleeunit/should
import counter_web

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn health_response_is_ok() -> Nil {
  counter_web.health_response()
  |> should.equal("OK")
}

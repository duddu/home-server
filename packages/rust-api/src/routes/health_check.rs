#[get("/")]
pub fn get_health_check() -> &'static str {
    "OK"
}
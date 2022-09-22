#[cfg(test)] mod test;

#[get("/health")]
pub fn get_health_check() -> &'static str {
    "OK"
}
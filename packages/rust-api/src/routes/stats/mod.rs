use rocket::serde::{json::Json, Deserialize, Serialize};
use systemstat::{System, Platform};

#[cfg(test)] mod test;

const BYTES_IN_MB: u64 = 1048576;

#[derive(Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(crate = "rocket::serde")]
pub struct Stats {
    ram_free_mb: u64,
    ram_total_mb: u64,
    boot_time_unix: i64,
    uptime_mins: u64,
}

#[get("/stats")]
pub fn get_stats() -> Json<Stats> {
    let sys = System::new();

    Json(Stats {
        ram_free_mb: sys.memory().unwrap().free.as_u64() / BYTES_IN_MB,
        ram_total_mb: sys.memory().unwrap().total.as_u64() / BYTES_IN_MB,
        boot_time_unix: sys.boot_time().unwrap().unix_timestamp(),
        uptime_mins: sys.uptime().unwrap().as_secs() / 60,
    })
}
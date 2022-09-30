use rocket::serde::{json::Json, Deserialize, Serialize};
use sysinfo::{CpuExt, System, SystemExt};

#[derive(Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(crate = "rocket::serde")]
pub struct Stats {
    ram: u64,
    cpu: String,
}

#[get("/stats")]
pub fn get_stats() -> Json<Stats> {
    let mut sys = System::new_all();
    sys.refresh_all();

    Json(Stats {
        ram: sys.total_memory(),
        cpu: String::from(sys.global_cpu_info().brand()),
    })
}
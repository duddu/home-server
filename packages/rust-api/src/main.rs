#[macro_use] extern crate rocket;
use rocket::{Build, fairing::AdHoc, Rocket, serde::Deserialize};

mod routes;

#[derive(Deserialize)]
#[serde(crate = "rocket::serde")]
pub struct Config {
    machine_localhost: String,
}

#[launch]
fn rocket() -> Rocket<Build> {
    rocket::build()
        .mount("/", routes![
            routes::health_check::get_health_check,
            routes::processes::get_processes,
            routes::stats::get_stats,
            routes::version::get_version
        ])
        .attach(AdHoc::config::<Config>())
}
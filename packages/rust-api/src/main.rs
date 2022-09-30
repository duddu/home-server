#[macro_use] extern crate rocket;
mod routes;

const BASE_PATH: &str = "/api";

#[launch]
fn rocket() -> _ {
    rocket::build()
        .mount(BASE_PATH, routes![
            routes::health_check::get_health_check,
            routes::processes::get_processes,
            routes::stats::get_stats,
            routes::version::get_version
        ])
}
#[macro_use] extern crate rocket;
mod routes;

#[launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/health", routes![routes::health_check::get_health_check])
        .mount("/version", routes![routes::version::get_version])
        .mount("/processes", routes![routes::processes::get_processes])
}

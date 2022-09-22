#[macro_use] extern crate rocket;
mod routes;

#[launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/", routes![
            routes::health_check::get_health_check,
            routes::processes::get_processes,
            routes::version::get_version
        ])
}
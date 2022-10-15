use crate::rocket;

#[cfg(test)]
mod integration_test {
    use super::rocket;
    use rocket::local::blocking::Client;
    use rocket::http::{ContentType, Status};
    use std::any::{Any, TypeId};
    use crate::routes::stats::{self, Stats};

    #[test]
    fn get() {      
        let client = Client::tracked(rocket()).expect("valid rocket instance");
        let response = client.get(uri!(stats::get_stats)).dispatch();

        assert_eq!(response.status(), Status::Ok);
        assert_eq!(response.content_type().unwrap(), ContentType::JSON);
        let json = response.into_json::<Stats>().unwrap();

        assert_eq!(json.ram_free_mb.type_id(), TypeId::of::<u64>());
        assert_eq!(json.ram_total_mb.type_id(), TypeId::of::<u64>());
        assert_eq!(json.boot_time_unix.type_id(), TypeId::of::<i64>());
        assert_eq!(json.uptime_mins.type_id(), TypeId::of::<u64>());
    }
}
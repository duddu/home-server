use crate::rocket;

#[cfg(test)]
mod integration_test {
    use super::rocket;
    use rocket::local::blocking::Client;
    use rocket::http::{ContentType, Status};
    use rocket::serde::json::serde_json;
    use std::env;
    use crate::routes::processes::{self, Process, PROCESSES};

    #[test]
    fn get() {      
        let expected_response: [Process; 5] = PROCESSES;

        let invalid_ip = "127.0.0.2";
        env::set_var("ROCKET_MACHINE_LOCALHOST", invalid_ip);
        env::set_var("ROCKET_DOMAIN_NAME", invalid_ip);

        let client = Client::tracked(rocket()).expect("valid rocket instance");
        let response = client.get(uri!(processes::get_processes)).dispatch();

        assert_eq!(response.status(), Status::Ok);
        assert_eq!(response.content_type().unwrap(), ContentType::JSON);
        assert_eq!(
            String::from_utf8(response.into_bytes().unwrap()),
            String::from_utf8(serde_json::to_vec(&expected_response).unwrap())
        );
    }
}
use crate::rocket;

#[cfg(test)]
mod integration_test {
    use super::rocket;
    use rocket::local::blocking::Client;
    use rocket::http::{ContentType, Status};
    use rocket::serde::json::serde_json;
    use std::env;
    use crate::routes::processes::{self, Process};

    #[test]
    fn get() {      
        let expected_response: Vec<Process> = vec![
            Process {
                name: "SSH",
                port: 22,
                running: false
            },
            Process {
                name: "Samba",
                port: 445,
                running: false
            },
            Process {
                name: "Apple Remote Desktop",
                port: 3283,
                running: false
            },
            Process {
                name: "Screen Sharing",
                port: 5900,
                running: false
            },
            Process {
                name: "Plex Server",
                port: 32400,
                running: false
            }
        ];

        env::set_var("ROCKET_MACHINE_LOCALHOST", "127.0.0.2");

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
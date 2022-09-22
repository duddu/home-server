use crate::rocket;

#[cfg(test)]
mod integration_test {
    use super::rocket;
    use rocket::local::blocking::Client;
    use rocket::http::{ContentType, Status};
    use crate::routes::version::{self, VersionInfo};

    #[test]
    fn get() {
        let client = Client::tracked(rocket()).expect("valid rocket instance");
        let response = client.get(uri!(version::get_version)).dispatch();

        assert_eq!(response.status(), Status::Ok);
        assert_eq!(response.content_type().unwrap(), ContentType::JSON);
        assert_eq!(response.into_json::<VersionInfo>().unwrap(), VersionInfo {
            name: env!("CARGO_PKG_NAME").to_string(),
            version: env!("CARGO_PKG_VERSION").to_string()
        })
    }
}
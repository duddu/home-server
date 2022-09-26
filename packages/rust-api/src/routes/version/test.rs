use crate::rocket;

#[cfg(test)]
mod integration_test {
    use super::rocket;
    use rocket::local::blocking::Client;
    use rocket::http::{ContentType, uri::Origin, Status};
    use crate::{BASE_PATH, routes::version::{self, VersionInfo}};

    #[test]
    fn get() {
        let client = Client::tracked(rocket()).expect("valid rocket instance");
        let path = BASE_PATH.to_owned() + &uri!(version::get_version).to_string();
        let uri = Origin::parse(&path).expect("valid URI");
        let response = client.get(uri).dispatch();

        assert_eq!(response.status(), Status::Ok);
        assert_eq!(response.content_type().unwrap(), ContentType::JSON);
        assert_eq!(response.into_json::<VersionInfo>().unwrap(), VersionInfo {
            name: env!("CARGO_PKG_NAME").to_string(),
            version: env!("CARGO_PKG_VERSION").to_string()
        })
    }
}
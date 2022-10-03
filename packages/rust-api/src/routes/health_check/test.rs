use crate::rocket;

#[cfg(test)]
mod integration_test {
    use super::rocket;
    use rocket::local::blocking::Client;
    use rocket::http::{ContentType, Status};
    use crate::routes::health_check;

    #[test]
    fn get() {
        let client = Client::tracked(rocket()).expect("valid rocket instance");
        let response = client.get(uri!(health_check::get_health_check)).dispatch();

        assert_eq!(response.status(), Status::Ok);
        assert_eq!(response.content_type().unwrap(), ContentType::Text);
        assert_eq!(response.into_string().unwrap(), "OK");
    }
}
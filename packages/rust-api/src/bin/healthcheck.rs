use reqwest::blocking::Client;
use std::process::exit;

const HEALTHCHECK_URL: &str = "http://localhost:8000/health";

fn main () {
    let message: String;
    let client = Client::builder()
        .build()
        .unwrap();

    match client.get(HEALTHCHECK_URL).send() {
        Ok(response) => {
            if response.status().is_success() {
                match response.text() {
                    Ok(text) => {
                        if text == "OK" {
                            println!("{}", text);
                            exit(0);
                        } else {
                            message = text;
                        }
                    },
                    Err(e) => message = e.to_string()
                }
            } else {
                message = response.status().to_string();
            }
        },
        Err(e) => message = e.to_string()
    }

    println!("{}", message);
    exit(69);
}
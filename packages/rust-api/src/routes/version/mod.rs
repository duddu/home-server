use rocket::serde::{json::Json, Deserialize, Serialize};

#[cfg(test)] mod test;

#[derive(Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(crate = "rocket::serde")]
pub struct VersionInfo {
    name: String,
    version: String,
}

#[get("/version")]
pub fn get_version() -> Json<VersionInfo> {
    Json(VersionInfo {
        name: env!("CARGO_PKG_NAME").to_string(),
        version: env!("CARGO_PKG_VERSION").to_string()
    })
}
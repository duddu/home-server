use futures::stream::{self, StreamExt};
use rocket::serde::{json::Json, Deserialize, Serialize};
use std::{env, net::{TcpStream, ToSocketAddrs}, time::Duration};

#[cfg(test)] mod test;

const SSH_PORT: u16 = 22;
const SMB_PORT: u16 = 445;
const ARD_PORT: u16 = 3283;
const VNC_PORT: u16 = 5900;
const PLEX_PORT: u16 = 32400;

const PORTS: [u16; 5] = [
    SSH_PORT,
    SMB_PORT,
    ARD_PORT,
    VNC_PORT,
    PLEX_PORT
];

const fn get_port_description(port: u16) -> &'static str {
    match port {
        SSH_PORT => "SSH",
        SMB_PORT => "Samba",
        ARD_PORT => "Apple Remote Desktop",
        VNC_PORT => "Screen Sharing",
        PLEX_PORT => "Plex Server",
        _ => "",
    }
}

const ENV_KEY_HOST: &str = "CONTAINERS_HOST";
const CONNECTION_TIMEOUT: Duration = Duration::from_secs(1);
const CONCURRENT_LIMIT: usize = 100;

#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
#[serde(crate = "rocket::serde")]
pub struct Process {
    name: &'static str,
    port: u16,
    running: bool,
}

#[get("/processes")]
pub async fn get_processes() -> Json<Vec<Process>> {
    let mut processes = PORTS.map(|port| Process {
        name: get_port_description(port),
        port,
        running: false,
    });
    let processes_iter = stream::iter(&mut processes);

    processes_iter.for_each_concurrent(CONCURRENT_LIMIT, |process| async move {
        let host = env::var(ENV_KEY_HOST).unwrap();
        let host_addrs = (host, process.port).to_socket_addrs().unwrap();
        for host_addr in host_addrs {
            if let Ok(_stream) = TcpStream::connect_timeout(&host_addr, CONNECTION_TIMEOUT) {
                process.running = true;
                break;
            }    
        }
    }).await;

    Json(processes.to_vec())
}
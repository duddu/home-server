use futures::stream::{self, StreamExt};
use rocket::serde::{json::Json, Deserialize, Serialize};
use std::{env, net::{TcpStream, ToSocketAddrs}, time::Duration};

#[cfg(test)] mod test;

const PROCESSES: [Process; 5] = [
    Process::new(22,    "SSH"),
    Process::new(445,   "Samba"),
    Process::new(3283,  "Apple Remote Desktop"),
    Process::new(5900,  "Screen Sharing"),
    Process::new(32400, "Plex Server"),
];

const ENV_KEY_HOST: &str = "CONTAINERS_HOST";
const CONNECTION_TIMEOUT: Duration = Duration::from_secs(1);
const CONCURRENT_LIMIT: usize = 100;

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(crate = "rocket::serde")]
pub struct Process {
    name: &'static str,
    port: u16,
    running: bool,
}

impl Process {
    const fn new (port: u16, name: &'static str) -> Process {
        Process {
            name,
            port,
            running: false,
        }
    }

    fn set_running (&mut self) {
        self.running = true;
    }
}

#[get("/processes")]
pub async fn get_processes() -> Json<Vec<Process>> {
    let mut processes = PROCESSES.to_vec();
    let processes_iter = stream::iter(&mut processes);

    processes_iter.for_each_concurrent(CONCURRENT_LIMIT, |process| async move {
        let host = env::var(ENV_KEY_HOST).unwrap();
        let host_addrs = (host, process.port).to_socket_addrs().unwrap();
        for host_addr in host_addrs {
            if let Ok(_stream) = TcpStream::connect_timeout(&host_addr, CONNECTION_TIMEOUT) {
                process.set_running();
                break;
            }    
        }
    }).await;

    Json(processes)
}
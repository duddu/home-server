use futures::stream::{self, StreamExt};
use rocket::{serde::{json::Json, Deserialize, Serialize}, State};
use std::{net::{TcpStream, ToSocketAddrs}, time::Duration};
use crate::Config;

#[cfg(test)] mod test;

const PROCESSES: [Process; 5] = [
    Process::new("SSH",                  22,    22),
    Process::new("Samba",                445,   445),
    Process::new("Apple Remote Desktop", 3283,  3283),
    Process::new("Screen Sharing",       5900,  5900),
    Process::new("Plex Server",          32400, 32400),
];

const CONNECTION_TIMEOUT: Duration = Duration::from_secs(1);
const CONCURRENT_LIMIT: usize = 100;

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(crate = "rocket::serde")]
pub struct Process {
    name: &'static str,
    internal: Port,
    external: Port,
}

impl Process {
    const fn new (name: &'static str, internal_port: u16, external_port: u16) -> Process {
        Process {
            name,
            internal: Port {
                port: internal_port,
                open: false,
            },
            external: Port {
                port: external_port,
                open: false,
            },
        }
    }

    fn set_internal_open (&mut self) {
        self.internal.open = true;
    }

    fn set_external_open (&mut self) {
        self.external.open = true;
    }
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(crate = "rocket::serde")]
pub struct Port {
    port: u16,
    open: bool,
}

#[get("/processes")]
pub async fn get_processes(config: &State<Config>) -> Json<Vec<Process>> {
    let mut processes = PROCESSES.to_vec();
    let processes_iter = stream::iter(&mut processes);
    let internal_host = config.machine_localhost.as_str();
    let external_host = config.domain_name.as_str();

    processes_iter.for_each_concurrent(CONCURRENT_LIMIT, |process| async move {
        let internal_host_addrs = (internal_host, process.internal.port).to_socket_addrs().unwrap();
        for host_addr in internal_host_addrs {
            if let Ok(_stream) = TcpStream::connect_timeout(&host_addr, CONNECTION_TIMEOUT) {
                process.set_internal_open();
                break;
            }    
        }

        let external_host_addrs = (external_host, process.external.port).to_socket_addrs().unwrap();
        for host_addr in external_host_addrs {
            if let Ok(_stream) = TcpStream::connect_timeout(&host_addr, CONNECTION_TIMEOUT) {
                process.set_external_open();
                break;
            }    
        }
    }).await;

    Json(processes)
}
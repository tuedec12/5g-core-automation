# 5G Core Network Simulation & Telemetry Lab

## 📡 Architecture Overview
This project is a fully containerized, end-to-end 5G network deployed on a local Kubernetes cluster. It simulates a complete 5G Standalone (SA) environment, including the core control plane, radio access network, and connected user equipment, alongside enterprise-grade infrastructure monitoring.

**Tech Stack:**
* **5G Core:** Open5GS (Deployed via Helm)
* **RAN / UE Simulation:** UERANSIM
* **Orchestration:** Kubernetes (Minikube)
* **Telemetry & Monitoring:** Prometheus & Grafana
* **CI/CD Pipeline:** GitHub Actions (Self-Hosted Runner)

---

## 🚀 The Cold Boot Runbook

When starting the environment from a powered-off state, follow these phases in exact order:

### Phase 1: Wake Up the Core
Initialize the Kubernetes cluster and verify all 15 Open5GS microservices are running.
```bash
minikube start
kubectl get pods -A

Phase 2: Provision the Database (Web UI)

Kubernetes databases are ephemeral. Map the secure tunnel to the Web UI and add the test SIM cards to the VIP list.
Bash

kubectl port-forward svc/open5gs-core-webui 9999:9999

    Access: http://localhost:9999 (admin / 1423)

    Action: Provision IMSIs 999700000000001, 999700000000002, and 999700000000003.

Phase 3: Start the Radio Access Network (gNB)

Initialize the cell tower to broadcast the 5G signal and listen for incoming connections.
Bash

cd ~/UERANSIM
sudo build/nr-gnb -c config/open5gs-gnb.yaml

Phase 4: Start the Cloud Listener (GitHub Actions)

Boot up the local listener so GitHub can trigger the automated test pipeline remotely.
Bash

cd ~/actions-runner
./run.sh

Phase 5: The God-Mode Dashboard (Grafana)

Open the secure tunnel to the Prometheus/Grafana monitoring stack to track CPU, RAM, and internal cluster network traffic.
Bash

kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring

    Access: http://localhost:3000

    Dashboard ID: 1860 (Node Exporter Full)

Phase 6: Execute the Load Test

Spawn 3 virtual smartphones to connect to the gNB, authenticate with the AMF, and establish secure PDU data tunnels with the UPF.
Bash

# Manual multi-user simulation:
cd ~/UERANSIM
sudo build/nr-ue -c config/open5gs-ue.yaml -n 3

# Or trigger the automated pipeline:
bash ~/project/scripts/test.sh

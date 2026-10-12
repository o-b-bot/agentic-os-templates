# Compute plane: deployment diagram

Generated from the configuration and the surveyed inventory (see `COMPUTE_PLANE.md`). Primary pool solid, burst pool dashed; each edge carries the number of routes from a capability class to a pool; critical gaps in red.

```mermaid
flowchart LR
  GW["gateway"]
  subgraph P_apple_primary["pool: apple-primary (primary)"]
    N_apple_ws_1["apple-ws-1<br/>apple-silicon"]
    N_apple_ws_2["apple-ws-2<br/>apple-silicon"]
    N_apple_ws_3["apple-ws-3<br/>apple-silicon"]
  end
  subgraph P_lead_hardware_dedicated["pool: lead-hardware-dedicated (primary)"]
  end
  subgraph P_lead_security_dedicated["pool: lead-security-dedicated (primary)"]
  end
  subgraph P_remote_gpu_burst["pool: remote-gpu-burst (burst)"]
    N_gpu_burst_1["gpu-burst-1<br/>standby"]
    N_gpu_burst_2["gpu-burst-2<br/>standby"]
    N_gpu_burst_3["gpu-burst-3<br/>standby"]
    N_gpu_burst_4["gpu-burst-4<br/>standby"]
  end
  subgraph P_shared_gpu["pool: shared-gpu (primary)"]
  end
  subgraph P_unpooled["unpooled"]
    N_cpu_exec_1["cpu-exec-1<br/>cpu-server"]
  end
  style P_remote_gpu_burst stroke-dasharray: 5 5
  GW --> C_architecture_and_final_review["architecture-and-final-review"]
  C_architecture_and_final_review -->|3 routes| P_apple_primary
  GW --> C_code_build["code-build"]
  C_code_build -->|3 routes| P_apple_primary
  C_code_build -.->|burst, 4 routes| P_remote_gpu_burst
  GW --> C_code_review["code-review"]
  C_code_review -->|3 routes| P_apple_primary
  C_code_review -.->|burst, 4 routes| P_remote_gpu_burst
  GW --> C_correspondence_drafting["correspondence-drafting"]
  C_correspondence_drafting -->|3 routes| P_apple_primary
  C_correspondence_drafting -.->|burst, 4 routes| P_remote_gpu_burst
  GW --> C_embedding["embedding"]
  C_embedding -->|3 routes| P_apple_primary
  C_embedding -.->|burst, 4 routes| P_remote_gpu_burst
  GW --> C_health_check["health-check"]
  C_health_check -->|3 routes| P_apple_primary
  C_health_check -.->|burst, 4 routes| P_remote_gpu_burst
  GW --> C_intake_classification["intake-classification"]
  C_intake_classification -->|3 routes| P_apple_primary
  C_intake_classification -.->|burst, 4 routes| P_remote_gpu_burst
  GW --> C_se_review["se-review"]
  C_se_review -->|3 routes| P_apple_primary
  C_se_review -.->|burst, 4 routes| P_remote_gpu_burst
  GW --> C_se_synthesis["se-synthesis"]
  C_se_synthesis -->|3 routes| P_apple_primary
  C_se_synthesis -.->|burst, 4 routes| P_remote_gpu_burst
  E_llamacpp_cpu_1["llamacpp-cpu-1"] --> N_cpu_exec_1
  G_restricted_cannot_burst_architecture_and_final_review["critical: restricted-cannot-burst architecture-and-final-review"]
  style G_restricted_cannot_burst_architecture_and_final_review fill:#ffcccc,stroke:#b00020,color:#000
  C_architecture_and_final_review -.-> G_restricted_cannot_burst_architecture_and_final_review
```

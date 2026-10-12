package ComputePlane {
    part def Node {
        attribute id : String;
        attribute kind : String;
        attribute reachability : String;
        attribute segment : String;
    }
    part def ServingEndpoint {
        attribute id : String;
        attribute engineKind : String;
        attribute bindScope : String;
        attribute authenticated : Boolean;
    }
    part def Gateway {
        attribute entryPoint : String;
        attribute authentication : String;
    }
    part def Route {
        attribute id : String;
        attribute capabilityClass : String;
        attribute priority : Integer;
    }
    part def Pool {
        attribute id : String;
        attribute role : String;
        attribute burstLocation : String;
        attribute maxNodes : Integer;
        attribute warmUpSeconds : Integer;
    }
    part gateway : Gateway;
    part apple_ws_1 : Node;
    doc /* node apple-ws-1 */
    part apple_ws_2 : Node;
    doc /* node apple-ws-2 */
    part apple_ws_3 : Node;
    doc /* node apple-ws-3 */
    part cpu_exec_1 : Node;
    doc /* node cpu-exec-1 */
    part gpu_burst_1 : Node;
    doc /* node gpu-burst-1 */
    part gpu_burst_2 : Node;
    doc /* node gpu-burst-2 */
    part gpu_burst_3 : Node;
    doc /* node gpu-burst-3 */
    part gpu_burst_4 : Node;
    doc /* node gpu-burst-4 */
    part pool_apple_primary : Pool;
    doc /* pool apple-primary role primary */
    part pool_lead_hardware_dedicated : Pool;
    doc /* pool lead-hardware-dedicated role primary */
    part pool_lead_security_dedicated : Pool;
    doc /* pool lead-security-dedicated role primary */
    part pool_remote_gpu_burst : Pool;
    doc /* pool remote-gpu-burst role burst */
    part pool_shared_gpu : Pool;
    doc /* pool shared-gpu role primary */
    part llamacpp_cpu_1 : ServingEndpoint;
    doc /* endpoint llamacpp-cpu-1 */
    part mlx_apple_1 : ServingEndpoint;
    doc /* endpoint mlx-apple-1 */
    part mlx_apple_2 : ServingEndpoint;
    doc /* endpoint mlx-apple-2 */
    part mlx_apple_3 : ServingEndpoint;
    doc /* endpoint mlx-apple-3 */
    part vllm_burst_1 : ServingEndpoint;
    doc /* endpoint vllm-burst-1 */
    part vllm_burst_2 : ServingEndpoint;
    doc /* endpoint vllm-burst-2 */
    part vllm_burst_3 : ServingEndpoint;
    doc /* endpoint vllm-burst-3 */
    part vllm_burst_4 : ServingEndpoint;
    doc /* endpoint vllm-burst-4 */
    part r_architecture_and_final_review_apple_1 : Route;
    doc /* route r-architecture-and-final-review-apple-1 */
    part r_architecture_and_final_review_apple_2 : Route;
    doc /* route r-architecture-and-final-review-apple-2 */
    part r_architecture_and_final_review_apple_3 : Route;
    doc /* route r-architecture-and-final-review-apple-3 */
    part r_code_build_apple_1 : Route;
    doc /* route r-code-build-apple-1 */
    part r_code_build_apple_2 : Route;
    doc /* route r-code-build-apple-2 */
    part r_code_build_apple_3 : Route;
    doc /* route r-code-build-apple-3 */
    part r_code_build_burst_1 : Route;
    doc /* route r-code-build-burst-1 */
    part r_code_build_burst_2 : Route;
    doc /* route r-code-build-burst-2 */
    part r_code_build_burst_3 : Route;
    doc /* route r-code-build-burst-3 */
    part r_code_build_burst_4 : Route;
    doc /* route r-code-build-burst-4 */
    part r_code_review_apple_1 : Route;
    doc /* route r-code-review-apple-1 */
    part r_code_review_apple_2 : Route;
    doc /* route r-code-review-apple-2 */
    part r_code_review_apple_3 : Route;
    doc /* route r-code-review-apple-3 */
    part r_code_review_burst_1 : Route;
    doc /* route r-code-review-burst-1 */
    part r_code_review_burst_2 : Route;
    doc /* route r-code-review-burst-2 */
    part r_code_review_burst_3 : Route;
    doc /* route r-code-review-burst-3 */
    part r_code_review_burst_4 : Route;
    doc /* route r-code-review-burst-4 */
    part r_correspondence_drafting_apple_1 : Route;
    doc /* route r-correspondence-drafting-apple-1 */
    part r_correspondence_drafting_apple_2 : Route;
    doc /* route r-correspondence-drafting-apple-2 */
    part r_correspondence_drafting_apple_3 : Route;
    doc /* route r-correspondence-drafting-apple-3 */
    part r_correspondence_drafting_burst_1 : Route;
    doc /* route r-correspondence-drafting-burst-1 */
    part r_correspondence_drafting_burst_2 : Route;
    doc /* route r-correspondence-drafting-burst-2 */
    part r_correspondence_drafting_burst_3 : Route;
    doc /* route r-correspondence-drafting-burst-3 */
    part r_correspondence_drafting_burst_4 : Route;
    doc /* route r-correspondence-drafting-burst-4 */
    part r_embedding_apple_1 : Route;
    doc /* route r-embedding-apple-1 */
    part r_embedding_apple_2 : Route;
    doc /* route r-embedding-apple-2 */
    part r_embedding_apple_3 : Route;
    doc /* route r-embedding-apple-3 */
    part r_embedding_burst_1 : Route;
    doc /* route r-embedding-burst-1 */
    part r_embedding_burst_2 : Route;
    doc /* route r-embedding-burst-2 */
    part r_embedding_burst_3 : Route;
    doc /* route r-embedding-burst-3 */
    part r_embedding_burst_4 : Route;
    doc /* route r-embedding-burst-4 */
    part r_health_check_apple_1 : Route;
    doc /* route r-health-check-apple-1 */
    part r_health_check_apple_2 : Route;
    doc /* route r-health-check-apple-2 */
    part r_health_check_apple_3 : Route;
    doc /* route r-health-check-apple-3 */
    part r_health_check_burst_1 : Route;
    doc /* route r-health-check-burst-1 */
    part r_health_check_burst_2 : Route;
    doc /* route r-health-check-burst-2 */
    part r_health_check_burst_3 : Route;
    doc /* route r-health-check-burst-3 */
    part r_health_check_burst_4 : Route;
    doc /* route r-health-check-burst-4 */
    part r_intake_classification_apple_1 : Route;
    doc /* route r-intake-classification-apple-1 */
    part r_intake_classification_apple_2 : Route;
    doc /* route r-intake-classification-apple-2 */
    part r_intake_classification_apple_3 : Route;
    doc /* route r-intake-classification-apple-3 */
    part r_intake_classification_burst_1 : Route;
    doc /* route r-intake-classification-burst-1 */
    part r_intake_classification_burst_2 : Route;
    doc /* route r-intake-classification-burst-2 */
    part r_intake_classification_burst_3 : Route;
    doc /* route r-intake-classification-burst-3 */
    part r_intake_classification_burst_4 : Route;
    doc /* route r-intake-classification-burst-4 */
    part r_se_review_apple_1 : Route;
    doc /* route r-se-review-apple-1 */
    part r_se_review_apple_2 : Route;
    doc /* route r-se-review-apple-2 */
    part r_se_review_apple_3 : Route;
    doc /* route r-se-review-apple-3 */
    part r_se_review_burst_1 : Route;
    doc /* route r-se-review-burst-1 */
    part r_se_review_burst_2 : Route;
    doc /* route r-se-review-burst-2 */
    part r_se_review_burst_3 : Route;
    doc /* route r-se-review-burst-3 */
    part r_se_review_burst_4 : Route;
    doc /* route r-se-review-burst-4 */
    part r_se_synthesis_apple_1 : Route;
    doc /* route r-se-synthesis-apple-1 */
    part r_se_synthesis_apple_2 : Route;
    doc /* route r-se-synthesis-apple-2 */
    part r_se_synthesis_apple_3 : Route;
    doc /* route r-se-synthesis-apple-3 */
    part r_se_synthesis_burst_1 : Route;
    doc /* route r-se-synthesis-burst-1 */
    part r_se_synthesis_burst_2 : Route;
    doc /* route r-se-synthesis-burst-2 */
    part r_se_synthesis_burst_3 : Route;
    doc /* route r-se-synthesis-burst-3 */
    part r_se_synthesis_burst_4 : Route;
    doc /* route r-se-synthesis-burst-4 */
    connect gateway to r_architecture_and_final_review_apple_1;
    connect r_architecture_and_final_review_apple_1 to mlx_apple_1;
    connect mlx_apple_1 to apple_ws_1;
    connect r_architecture_and_final_review_apple_1 to pool_apple_primary;
    connect gateway to r_architecture_and_final_review_apple_2;
    connect r_architecture_and_final_review_apple_2 to mlx_apple_2;
    connect mlx_apple_2 to apple_ws_2;
    connect r_architecture_and_final_review_apple_2 to pool_apple_primary;
    connect gateway to r_architecture_and_final_review_apple_3;
    connect r_architecture_and_final_review_apple_3 to mlx_apple_3;
    connect mlx_apple_3 to apple_ws_3;
    connect r_architecture_and_final_review_apple_3 to pool_apple_primary;
    connect gateway to r_code_build_apple_1;
    connect r_code_build_apple_1 to mlx_apple_1;
    connect mlx_apple_1 to apple_ws_1;
    connect r_code_build_apple_1 to pool_apple_primary;
    connect gateway to r_code_build_apple_2;
    connect r_code_build_apple_2 to mlx_apple_2;
    connect mlx_apple_2 to apple_ws_2;
    connect r_code_build_apple_2 to pool_apple_primary;
    connect gateway to r_code_build_apple_3;
    connect r_code_build_apple_3 to mlx_apple_3;
    connect mlx_apple_3 to apple_ws_3;
    connect r_code_build_apple_3 to pool_apple_primary;
    connect gateway to r_code_build_burst_1;
    connect r_code_build_burst_1 to vllm_burst_1;
    connect vllm_burst_1 to gpu_burst_1;
    connect r_code_build_burst_1 to pool_remote_gpu_burst;
    connect gateway to r_code_build_burst_2;
    connect r_code_build_burst_2 to vllm_burst_2;
    connect vllm_burst_2 to gpu_burst_2;
    connect r_code_build_burst_2 to pool_remote_gpu_burst;
    connect gateway to r_code_build_burst_3;
    connect r_code_build_burst_3 to vllm_burst_3;
    connect vllm_burst_3 to gpu_burst_3;
    connect r_code_build_burst_3 to pool_remote_gpu_burst;
    connect gateway to r_code_build_burst_4;
    connect r_code_build_burst_4 to vllm_burst_4;
    connect vllm_burst_4 to gpu_burst_4;
    connect r_code_build_burst_4 to pool_remote_gpu_burst;
    connect gateway to r_code_review_apple_1;
    connect r_code_review_apple_1 to mlx_apple_1;
    connect mlx_apple_1 to apple_ws_1;
    connect r_code_review_apple_1 to pool_apple_primary;
    connect gateway to r_code_review_apple_2;
    connect r_code_review_apple_2 to mlx_apple_2;
    connect mlx_apple_2 to apple_ws_2;
    connect r_code_review_apple_2 to pool_apple_primary;
    connect gateway to r_code_review_apple_3;
    connect r_code_review_apple_3 to mlx_apple_3;
    connect mlx_apple_3 to apple_ws_3;
    connect r_code_review_apple_3 to pool_apple_primary;
    connect gateway to r_code_review_burst_1;
    connect r_code_review_burst_1 to vllm_burst_1;
    connect vllm_burst_1 to gpu_burst_1;
    connect r_code_review_burst_1 to pool_remote_gpu_burst;
    connect gateway to r_code_review_burst_2;
    connect r_code_review_burst_2 to vllm_burst_2;
    connect vllm_burst_2 to gpu_burst_2;
    connect r_code_review_burst_2 to pool_remote_gpu_burst;
    connect gateway to r_code_review_burst_3;
    connect r_code_review_burst_3 to vllm_burst_3;
    connect vllm_burst_3 to gpu_burst_3;
    connect r_code_review_burst_3 to pool_remote_gpu_burst;
    connect gateway to r_code_review_burst_4;
    connect r_code_review_burst_4 to vllm_burst_4;
    connect vllm_burst_4 to gpu_burst_4;
    connect r_code_review_burst_4 to pool_remote_gpu_burst;
    connect gateway to r_correspondence_drafting_apple_1;
    connect r_correspondence_drafting_apple_1 to mlx_apple_1;
    connect mlx_apple_1 to apple_ws_1;
    connect r_correspondence_drafting_apple_1 to pool_apple_primary;
    connect gateway to r_correspondence_drafting_apple_2;
    connect r_correspondence_drafting_apple_2 to mlx_apple_2;
    connect mlx_apple_2 to apple_ws_2;
    connect r_correspondence_drafting_apple_2 to pool_apple_primary;
    connect gateway to r_correspondence_drafting_apple_3;
    connect r_correspondence_drafting_apple_3 to mlx_apple_3;
    connect mlx_apple_3 to apple_ws_3;
    connect r_correspondence_drafting_apple_3 to pool_apple_primary;
    connect gateway to r_correspondence_drafting_burst_1;
    connect r_correspondence_drafting_burst_1 to vllm_burst_1;
    connect vllm_burst_1 to gpu_burst_1;
    connect r_correspondence_drafting_burst_1 to pool_remote_gpu_burst;
    connect gateway to r_correspondence_drafting_burst_2;
    connect r_correspondence_drafting_burst_2 to vllm_burst_2;
    connect vllm_burst_2 to gpu_burst_2;
    connect r_correspondence_drafting_burst_2 to pool_remote_gpu_burst;
    connect gateway to r_correspondence_drafting_burst_3;
    connect r_correspondence_drafting_burst_3 to vllm_burst_3;
    connect vllm_burst_3 to gpu_burst_3;
    connect r_correspondence_drafting_burst_3 to pool_remote_gpu_burst;
    connect gateway to r_correspondence_drafting_burst_4;
    connect r_correspondence_drafting_burst_4 to vllm_burst_4;
    connect vllm_burst_4 to gpu_burst_4;
    connect r_correspondence_drafting_burst_4 to pool_remote_gpu_burst;
    connect gateway to r_embedding_apple_1;
    connect r_embedding_apple_1 to mlx_apple_1;
    connect mlx_apple_1 to apple_ws_1;
    connect r_embedding_apple_1 to pool_apple_primary;
    connect gateway to r_embedding_apple_2;
    connect r_embedding_apple_2 to mlx_apple_2;
    connect mlx_apple_2 to apple_ws_2;
    connect r_embedding_apple_2 to pool_apple_primary;
    connect gateway to r_embedding_apple_3;
    connect r_embedding_apple_3 to mlx_apple_3;
    connect mlx_apple_3 to apple_ws_3;
    connect r_embedding_apple_3 to pool_apple_primary;
    connect gateway to r_embedding_burst_1;
    connect r_embedding_burst_1 to vllm_burst_1;
    connect vllm_burst_1 to gpu_burst_1;
    connect r_embedding_burst_1 to pool_remote_gpu_burst;
    connect gateway to r_embedding_burst_2;
    connect r_embedding_burst_2 to vllm_burst_2;
    connect vllm_burst_2 to gpu_burst_2;
    connect r_embedding_burst_2 to pool_remote_gpu_burst;
    connect gateway to r_embedding_burst_3;
    connect r_embedding_burst_3 to vllm_burst_3;
    connect vllm_burst_3 to gpu_burst_3;
    connect r_embedding_burst_3 to pool_remote_gpu_burst;
    connect gateway to r_embedding_burst_4;
    connect r_embedding_burst_4 to vllm_burst_4;
    connect vllm_burst_4 to gpu_burst_4;
    connect r_embedding_burst_4 to pool_remote_gpu_burst;
    connect gateway to r_health_check_apple_1;
    connect r_health_check_apple_1 to mlx_apple_1;
    connect mlx_apple_1 to apple_ws_1;
    connect r_health_check_apple_1 to pool_apple_primary;
    connect gateway to r_health_check_apple_2;
    connect r_health_check_apple_2 to mlx_apple_2;
    connect mlx_apple_2 to apple_ws_2;
    connect r_health_check_apple_2 to pool_apple_primary;
    connect gateway to r_health_check_apple_3;
    connect r_health_check_apple_3 to mlx_apple_3;
    connect mlx_apple_3 to apple_ws_3;
    connect r_health_check_apple_3 to pool_apple_primary;
    connect gateway to r_health_check_burst_1;
    connect r_health_check_burst_1 to vllm_burst_1;
    connect vllm_burst_1 to gpu_burst_1;
    connect r_health_check_burst_1 to pool_remote_gpu_burst;
    connect gateway to r_health_check_burst_2;
    connect r_health_check_burst_2 to vllm_burst_2;
    connect vllm_burst_2 to gpu_burst_2;
    connect r_health_check_burst_2 to pool_remote_gpu_burst;
    connect gateway to r_health_check_burst_3;
    connect r_health_check_burst_3 to vllm_burst_3;
    connect vllm_burst_3 to gpu_burst_3;
    connect r_health_check_burst_3 to pool_remote_gpu_burst;
    connect gateway to r_health_check_burst_4;
    connect r_health_check_burst_4 to vllm_burst_4;
    connect vllm_burst_4 to gpu_burst_4;
    connect r_health_check_burst_4 to pool_remote_gpu_burst;
    connect gateway to r_intake_classification_apple_1;
    connect r_intake_classification_apple_1 to mlx_apple_1;
    connect mlx_apple_1 to apple_ws_1;
    connect r_intake_classification_apple_1 to pool_apple_primary;
    connect gateway to r_intake_classification_apple_2;
    connect r_intake_classification_apple_2 to mlx_apple_2;
    connect mlx_apple_2 to apple_ws_2;
    connect r_intake_classification_apple_2 to pool_apple_primary;
    connect gateway to r_intake_classification_apple_3;
    connect r_intake_classification_apple_3 to mlx_apple_3;
    connect mlx_apple_3 to apple_ws_3;
    connect r_intake_classification_apple_3 to pool_apple_primary;
    connect gateway to r_intake_classification_burst_1;
    connect r_intake_classification_burst_1 to vllm_burst_1;
    connect vllm_burst_1 to gpu_burst_1;
    connect r_intake_classification_burst_1 to pool_remote_gpu_burst;
    connect gateway to r_intake_classification_burst_2;
    connect r_intake_classification_burst_2 to vllm_burst_2;
    connect vllm_burst_2 to gpu_burst_2;
    connect r_intake_classification_burst_2 to pool_remote_gpu_burst;
    connect gateway to r_intake_classification_burst_3;
    connect r_intake_classification_burst_3 to vllm_burst_3;
    connect vllm_burst_3 to gpu_burst_3;
    connect r_intake_classification_burst_3 to pool_remote_gpu_burst;
    connect gateway to r_intake_classification_burst_4;
    connect r_intake_classification_burst_4 to vllm_burst_4;
    connect vllm_burst_4 to gpu_burst_4;
    connect r_intake_classification_burst_4 to pool_remote_gpu_burst;
    connect gateway to r_se_review_apple_1;
    connect r_se_review_apple_1 to mlx_apple_1;
    connect mlx_apple_1 to apple_ws_1;
    connect r_se_review_apple_1 to pool_apple_primary;
    connect gateway to r_se_review_apple_2;
    connect r_se_review_apple_2 to mlx_apple_2;
    connect mlx_apple_2 to apple_ws_2;
    connect r_se_review_apple_2 to pool_apple_primary;
    connect gateway to r_se_review_apple_3;
    connect r_se_review_apple_3 to mlx_apple_3;
    connect mlx_apple_3 to apple_ws_3;
    connect r_se_review_apple_3 to pool_apple_primary;
    connect gateway to r_se_review_burst_1;
    connect r_se_review_burst_1 to vllm_burst_1;
    connect vllm_burst_1 to gpu_burst_1;
    connect r_se_review_burst_1 to pool_remote_gpu_burst;
    connect gateway to r_se_review_burst_2;
    connect r_se_review_burst_2 to vllm_burst_2;
    connect vllm_burst_2 to gpu_burst_2;
    connect r_se_review_burst_2 to pool_remote_gpu_burst;
    connect gateway to r_se_review_burst_3;
    connect r_se_review_burst_3 to vllm_burst_3;
    connect vllm_burst_3 to gpu_burst_3;
    connect r_se_review_burst_3 to pool_remote_gpu_burst;
    connect gateway to r_se_review_burst_4;
    connect r_se_review_burst_4 to vllm_burst_4;
    connect vllm_burst_4 to gpu_burst_4;
    connect r_se_review_burst_4 to pool_remote_gpu_burst;
    connect gateway to r_se_synthesis_apple_1;
    connect r_se_synthesis_apple_1 to mlx_apple_1;
    connect mlx_apple_1 to apple_ws_1;
    connect r_se_synthesis_apple_1 to pool_apple_primary;
    connect gateway to r_se_synthesis_apple_2;
    connect r_se_synthesis_apple_2 to mlx_apple_2;
    connect mlx_apple_2 to apple_ws_2;
    connect r_se_synthesis_apple_2 to pool_apple_primary;
    connect gateway to r_se_synthesis_apple_3;
    connect r_se_synthesis_apple_3 to mlx_apple_3;
    connect mlx_apple_3 to apple_ws_3;
    connect r_se_synthesis_apple_3 to pool_apple_primary;
    connect gateway to r_se_synthesis_burst_1;
    connect r_se_synthesis_burst_1 to vllm_burst_1;
    connect vllm_burst_1 to gpu_burst_1;
    connect r_se_synthesis_burst_1 to pool_remote_gpu_burst;
    connect gateway to r_se_synthesis_burst_2;
    connect r_se_synthesis_burst_2 to vllm_burst_2;
    connect vllm_burst_2 to gpu_burst_2;
    connect r_se_synthesis_burst_2 to pool_remote_gpu_burst;
    connect gateway to r_se_synthesis_burst_3;
    connect r_se_synthesis_burst_3 to vllm_burst_3;
    connect vllm_burst_3 to gpu_burst_3;
    connect r_se_synthesis_burst_3 to pool_remote_gpu_burst;
    connect gateway to r_se_synthesis_burst_4;
    connect r_se_synthesis_burst_4 to vllm_burst_4;
    connect vllm_burst_4 to gpu_burst_4;
    connect r_se_synthesis_burst_4 to pool_remote_gpu_burst;
    connect llamacpp_cpu_1 to cpu_exec_1;
    requirement def NoUnauthenticatedNonLoopback {
        doc /* Unauthenticated serving endpoints must bind loopback. */
    }
    requirement def NoPublicBind {
        doc /* Serving endpoints must not bind a public address. */
    }
    requirement def NoTierViolation {
        doc /* A route whose tier exceeds its node or provider dataTiersAllowed is refused. */
    }
    requirement def FitDeclared {
        doc /* A model without declared memoryGb is unknown, never fits. */
    }
    requirement def NoSilentOvercommit {
        doc /* Overcommitted and cpu-fallback models are high gaps, never fits. */
    }
}

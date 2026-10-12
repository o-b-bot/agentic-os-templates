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
    part gateway : Gateway;
    part apple_node_1 : Node;
    doc /* node apple-node-1 */
    part apple_node_2 : Node;
    doc /* node apple-node-2 */
    part cpu_node_1 : Node;
    doc /* node cpu-node-1 */
    part gpu_node_1 : Node;
    doc /* node gpu-node-1 */
    part gpu_node_2 : Node;
    doc /* node gpu-node-2 */
    part gpu_node_3 : Node;
    doc /* node gpu-node-3 */
    part gpu_node_4 : Node;
    doc /* node gpu-node-4 */
    part lab_node_1 : Node;
    doc /* node lab-node-1 */
    part cloud_gap : ServingEndpoint;
    doc /* endpoint cloud-gap */
    part llamacpp_cpu_1 : ServingEndpoint;
    doc /* endpoint llamacpp-cpu-1 */
    part llamacpp_gpu_2 : ServingEndpoint;
    doc /* endpoint llamacpp-gpu-2 */
    part mlx_apple_1 : ServingEndpoint;
    doc /* endpoint mlx-apple-1 */
    part mlx_apple_2 : ServingEndpoint;
    doc /* endpoint mlx-apple-2 */
    part public_gap : ServingEndpoint;
    doc /* endpoint public-gap */
    part vllm_gpu_1 : ServingEndpoint;
    doc /* endpoint vllm-gpu-1 */
    part vllm_gpu_3 : ServingEndpoint;
    doc /* endpoint vllm-gpu-3 */
    part vllm_gpu_4 : ServingEndpoint;
    doc /* endpoint vllm-gpu-4 */
    part r_final : Route;
    doc /* route r-final */
    part r_code_build : Route;
    doc /* route r-code-build */
    part r_code_review : Route;
    doc /* route r-code-review */
    part r_cloud : Route;
    doc /* route r-cloud */
    part r_public : Route;
    doc /* route r-public */
    part r_embed : Route;
    doc /* route r-embed */
    part r_health_a : Route;
    doc /* route r-health-a */
    part r_health_b : Route;
    doc /* route r-health-b */
    part r_intake : Route;
    doc /* route r-intake */
    part r_review_a : Route;
    doc /* route r-review-a */
    part r_review_b : Route;
    doc /* route r-review-b */
    part r_synth_a : Route;
    doc /* route r-synth-a */
    part r_synth_b : Route;
    doc /* route r-synth-b */
    connect gateway to r_final;
    connect r_final to mlx_apple_1;
    connect mlx_apple_1 to apple_node_1;
    connect gateway to r_code_build;
    connect r_code_build to vllm_gpu_3;
    connect vllm_gpu_3 to gpu_node_3;
    connect gateway to r_code_review;
    connect r_code_review to mlx_apple_2;
    connect mlx_apple_2 to apple_node_2;
    connect gateway to r_cloud;
    connect r_cloud to cloud_gap;
    connect cloud_gap to gpu_node_2;
    connect gateway to r_public;
    connect r_public to public_gap;
    connect public_gap to cpu_node_1;
    connect gateway to r_embed;
    connect r_embed to llamacpp_cpu_1;
    connect llamacpp_cpu_1 to cpu_node_1;
    connect gateway to r_health_a;
    connect r_health_a to vllm_gpu_1;
    connect vllm_gpu_1 to gpu_node_1;
    connect gateway to r_health_b;
    connect r_health_b to mlx_apple_1;
    connect mlx_apple_1 to apple_node_1;
    connect gateway to r_intake;
    connect r_intake to vllm_gpu_1;
    connect vllm_gpu_1 to gpu_node_1;
    connect gateway to r_review_a;
    connect r_review_a to llamacpp_gpu_2;
    connect llamacpp_gpu_2 to gpu_node_2;
    connect gateway to r_review_b;
    connect r_review_b to mlx_apple_1;
    connect mlx_apple_1 to apple_node_1;
    connect gateway to r_synth_a;
    connect r_synth_a to vllm_gpu_1;
    connect vllm_gpu_1 to gpu_node_1;
    connect gateway to r_synth_b;
    connect r_synth_b to vllm_gpu_4;
    connect vllm_gpu_4 to gpu_node_4;
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

# Compute plane (example)

A generated compute-plane design for the reference directorate: Apple-silicon workstations (Mac Studio class, 192 GB
unified memory each) as the always-on primary pool, and remote GPU servers held in standby as a burst pool that comes up
only when demand needs it. Demand is sized from the people using the OS (six in the reference directorate): total peak
concurrent model requests = people x concurrent journeys per person x peak factor x requests in flight per journey,
split across capability classes by their share of the work and checked against each pool's shared slots. Restricted
work never bursts to a remote pool.

| File | What it is |
|---|---|
| `COMPUTE_PLANE.md` | The design: topology, pools, demand and capacity, sizing, memory fit, gateway route table, network and identity, gaps with next actions |
| `DIAGRAM.md` | The deployment diagram (renders on GitHub) |
| `compute-plane.mmd` | The same diagram as a Mermaid source file |
| `compute-plane.sysml` | The SysML v2 textual model of the deployment |
| `WHAT_IF_PEAK_FACTOR_3.md` | What changes if the peak factor rises from 2 to 3: the burst pool hits its cap and a gap opens |

The example inventory is illustrative. A real design is regenerated from a survey of the actual machines, and again
whenever the survey or the configuration changes.

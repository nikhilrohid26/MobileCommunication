What I Have Done (Short Summary)
UE-GNB Configurations:

Tested combinations of UEs (50–200) and gNodeBs (5–40).

UE Mobility:

Realistic random walk movement in a bounded area.

gNB Assignment & Handovers:

Dynamic handover tracking per UE.

Federated Learning (FedAvg + MLP):

Local training at each UE, global aggregation every round.

FL Accuracy/Loss Tracking:

Recorded for each round; plotted for visualization.

CSV Logging (SLA-aware):

Detailed per-UE features and labels logged every round.

Mobility Animation with gNB Boundaries:

GIF showing UE movement and gNB areas.


| # gNodeBs | # UEs | Area Size | FL Rounds |
| --------- | ----- | --------- | --------- |
| 5         | 50    | 500×500   | 30        |
| 5         | 100   | 500×500   | 30        |
| 5         | 150   | 500×500   | 30        |
| 5         | 200   | 500×500   | 30        |
| 10        | 50    | 500×500   | 30        |
| 20        | 100   | 500×500   | 30        |
| 30        | 150   | 500×500   | 30        |
| 40        | 200   | 500×500   | 30        |





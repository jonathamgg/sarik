In the current directory, you will find a folder that contains the following PODs for monitoring system performance:

Grafana: This POD is responsible for providing a visualization and monitoring platform for metrics. It allows the 
creation of custom dashboards to display real-time data, including information about memory and CPU usage of other PODs.

Prometheus: This POD plays a crucial role in collecting and storing metrics. It is responsible for gathering and recording 
information related to memory and CPU of all running PODs in the environment.

Metrics: This POD is responsible for collecting detailed information about the memory and CPU usage of each of the other PODs. 
It provides this data to Prometheus, which in turn stores this information for later analysis and visualization.

Additionally, to facilitate the visualization and analysis of the collected data, a custom dashboard is provided for Grafana. 
This dashboard allows graphical visualization of the memory and CPU metrics of the monitored PODs. With it, you can monitor 
the system performance in real-time and identify potential bottlenecks or resource issues.

These components are essential for continuous monitoring and analysis of the system, providing valuable insights into the 
memory and CPU consumption of the PODs. With this information, proactive measures can be taken to optimize the performance, 
scalability, and efficiency of the Kubernetes environment.
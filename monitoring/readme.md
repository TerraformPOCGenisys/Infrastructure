## grafana
user : admin
password : you will get it from " kubectl edit secret grafana"
 
setting -> datasource -> search loki and add loki datasource -> add url : http://loki-loki-distributed-gateway.monitoring.svc.cluster.local     -> save and test



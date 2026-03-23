# Thunder

Thunder is a lightweight identity and access management product designed for managing different types of identities including customers, employees, businesses, and AI agents. It allows building secure and customizable authentication experiences across applications, services, and AI agents, and governing access control on those systems. 

This is a debugging setup where all traffic goes through the proxy for wire-dump.

## Connections

Browser \-\> ui-to-backend:8091 \-\> backend:8090

## Wire-dump

Debugging proxy and db dump writes all traffic to `net-dump/logs/requests/`: `{timestamp}_{source}_{METHOD}_{path}_{status}.txt` or `{timestamp}_db-cdc_{OP}_{table}_{key}.txt`. Delete these as needed.

## UI

Console \- Configuration portal

- https://localhost:8090/console  admin:admin 

Gate \- Authentication portal

- https://localhost:8090/gate 

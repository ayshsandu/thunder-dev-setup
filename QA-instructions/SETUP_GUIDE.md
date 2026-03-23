# Thunder QA Agent Setup

This guide provides step-by-step instructions on how to set up the Thunder QA agent using a local request interceptor.

## 1. Configure Thunder Distribution

Prepare the Thunder build by pointing its services to the proxy port (`8091`):

1. Get the Thunder distribution build.
2. Open `<thunder-dist>/apps/console/config.js` and edit the backend port to **8091**.
3. Open `<thunder-dist>/apps/gate/config.js` and edit the server port to **8091**.
4. Open `<thunder-dist>/repository/conf/deployment.yaml` and make sure the following changes are made:
    - Add **https://localhost:8091** to the CORS allowed origins list.
    - Add **https://localhost:8091** to the JWT issuer list.

Once configuration is updated, run Thunder.

Or alternatively, use the `setup-agent-env.sh` script to set up the Thunder distribution for the QA agent:

```bash
./scripts/setup-agent-env.sh <path_to_thunder_distribution.zip>
```

## 2. Setup Request Interceptor (net-dump)

Clone the []`net-dump`](https://github.com/manuranga/net-dump) repository to handle traffic proxying and logging:

```bash
git clone https://github.com/manuranga/net-dump
cd net-dump
```

Add a `config.json` file in the `net-dump` directory with the following content specifying the paths to the Thunder distribution's server(`<thunder-dist>`) key and certificate:

```json
{
  "main_log": "./logs/net-dump.txt",
  "request_logs": "./logs/requests",
  "mappings": [
    {
      "name": "8090",
      "in": {
        "port": 8091,
        "interface": "0.0.0.0",
        "ssl": {
          "key": "<thunder-dist>/repository/resources/security/server.key",
          "cert": "<thunder-dist>/repository/resources/security/server.cert"
        }
      },
      "out": {
        "host": "localhost",
        "port": 8090,
        "https": true
      }
    }
  ]
}
```

Run `net-dump` using its standard execution command. Change the config if necessary.
```bash
node net-dump.js config.json
```

Now you have a Thunder distribution configured for the QA agent with a request interceptor.

```text
  +------------------+                   +------------------+                   +-----------------+
  |                  |                   |   (8091)         |                   |    (8090)       |
  |     FrontEnd     | <===============> |  net-dump Proxy  | <===============> | Thunder BackEnd |
  | (Console & Gate) |                   |                  |                   |                 |
  +------------------+                   +--------+---------+                   +-----------------+
                                                  |
                                             logs |
                                                  v
                                        +---------+--+
                                        |            |
                                        |   logs/    |
                                        |  requests  |
                                        +------------+
```

## 3. Execute QA Instructions

Make sure you coding agent has access to the Thunder distribution, net-dump/, user-stories/, and QA-instructions/.

With `net-dump` and Thunder successfully running:
- Execute the QA agent instructions provided in `QA-instructions/RALF_PROMPT.md`.
- As needed based on outcomes, update the user stories located at `user-stories/index.md`.

## 4. Understanding the Output

By routing traffic to port **8091**, `net-dump` intercepts communication between the frontend and the backend before forwarding it to Thunder running on port **8090**.
- **`./logs/net-dump.txt`**: This file contains the general proxy server application logs.
- **`./logs/requests/`**: This directory securely logs raw intercepted frontend-backend request and response data. These captures provide the necessary traffic details for the QA agent to effectively debug and validate features.

## 5. Agent Output Structure

As the QA agent executes the testing instructions, it outputs findings directly into the `user-stories/` directory, categorized by epic and story (refer to `user-stories/index.md` for defined epics/stories):

- **Story Findings (`user-stories/<epic>/<story>.md`)**:
  Documents the testing execution of individual user stories. Each file will include:
  - **UI Actions Done**: Step-by-step actions performed.
  - **Observations**: What was observed (can include positive statements and general behaviors).

- **Epic Critical Analysis (`user-stories/<epic>/critical-analysis.md`)**:
  Consolidates issues that need to be addressed for the entire epic with a priority appended.
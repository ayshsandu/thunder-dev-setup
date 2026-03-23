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

Clone the proxy tool to intercept and log traffic:

```bash
git clone https://github.com/manuranga/net-dump
cd net-dump
```

Create `config.json` inside the `net-dump` directory. *(Replace `<thunder-dir>` with the name of the thunder distribution folder):*

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
          "key": "<thunder-dir>/repository/resources/security/server.key",
          "cert": "<thunder-dir>/repository/resources/security/server.cert"
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

Run the proxy:
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
## 4. Dependencies

Install Claude Code.

Install the [Anthropic's chrome extension](https://chromewebstore.google.com/publisher/anthropic/u308d63ea0533efcf7ba778ad42da7390).

## 5. Execute QA Instructions

With both Thunder and `net-dump` running, ask your coding agent to execute the instructions in:
**`QA-instructions/RALF_PROMPT.md`**

Ensure the agent has workspace access (specifically to `net-dump/logs/` and `user-stories/`). It will run the test scenarios and save its findings in the `user-stories/` directory.

## 6. Understanding the Setup

By routing traffic to port **8091**, `net-dump` intercepts communication between the frontend and the backend before forwarding it to Thunder backend on port **8090**.
- **`./logs/net-dump.txt`**: This file contains the general proxy server application logs.
- **`./logs/requests/`**: This directory securely logs raw intercepted frontend-backend request and response data. These captures provide the necessary traffic details for the QA agent to effectively debug and validate features.

## 6. Agent Output Structure

As the QA agent executes the testing instructions, it outputs findings directly into the `user-stories/` directory, categorized by epic and story (refer to `user-stories/index.md` for defined epics/stories):

- **Story Findings (`user-stories/<epic>/<story>.md`)**:
  Documents the testing execution of individual user stories. Each file will include:
  - **UI Actions Done**: Step-by-step actions performed.
  - **Observations**: What was observed (can include positive statements and general behaviors).

- **Epic Critical Analysis (`user-stories/<epic>/critical-analysis.md`)**:
  Consolidates issues that need to be addressed for the entire epic with a priority appended.
# Thunder Dev & QA Setup

This directory provides the necessary automation scripts, user stories, and prompt configurations to run agentic QA testing against the Thunder.

## Directory Structure
- **`scripts/`**: Tools to auto-configure and prepare your Thunder target distribution.
- **`QA-instructions/`**: Prompt instructions that guide the QA agent's behavior.
- **`user-stories/`**: Markdown checklists defining the specific product epics and scenarios to be tested. Will be discovered and updated by the QA agent. Useful for manual testing as well as documentation.

## QA Agent Setup Instructions

For step-by-step instructions on preparing Thunder for the QA agent, refer to **[QA Agent Setup Guide](QA-instructions/SETUP_GUIDE.md)**.

## How to Test a Specific Flow

You can easily configure the QA agent to evaluate a specific feature or change by pointing it to a single user story. Example prompt is in [TEST_CREATE_USER_PROMPT.md](QA-instructions/CREATE_USER_PROMPT.md).


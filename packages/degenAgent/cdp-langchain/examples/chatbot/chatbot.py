import json
import os
import sys
import time
import pandas as pd
from langchain_core.messages import HumanMessage
from langchain_openai import ChatOpenAI
from langgraph.checkpoint.memory import MemorySaver
from langgraph.prebuilt import create_react_agent
from cdp_langchain.agent_toolkits import CdpToolkit
from cdp_langchain.utils import CdpAgentkitWrapper
from cdp_langchain.tools import CdpTool
from pydantic import BaseModel, Field

# Configure a file to persist the agent's CDP MPC Wallet Data.
wallet_data_file = "wallet_data.txt"

# Initialize LLM
llm = ChatOpenAI(model="gpt-4o-mini")

# Load Coinbase credentials
wallet_data = None
if os.path.exists(wallet_data_file):
    with open(wallet_data_file) as f:
        wallet_data = f.read()

# Initialize CDP AgentKit Wrapper
values = {"cdp_wallet_data": wallet_data} if wallet_data else {}
agentkit = CdpAgentkitWrapper(**values)

# Save the wallet data persistently
wallet_data = agentkit.export_wallet()
with open(wallet_data_file, "w") as f:
    f.write(wallet_data)

# Initialize CDP AgentKit Toolkit and get tools
cdp_toolkit = CdpToolkit.from_cdp_agentkit_wrapper(agentkit)
tools = cdp_toolkit.get_tools()

# Memory saver for stateful conversation
memory = MemorySaver()
config = {"configurable": {"thread_id": "Memecoin Trading Agent"}}

# Create the ReAct Agent using the LLM and CDP AgentKit tools
agent_executor = create_react_agent(
    llm,
    tools=tools,
    checkpointer=memory,
    state_modifier=(
        "You are an AI trading agent that analyzes meme coin data and "
        "executes trades using the Coinbase Developer Platform Agentkit."
        "If the price is expected to go up, prompt the user to buy. If it is expected to go down, prompt the user to sell."
    )
)

# Function to analyze memecoin data and predict price direction
def analyze_memecoin(csv_file):
    """Analyze the memecoin data to predict if the price will go up or down."""
    df = pd.read_csv(csv_file)
    # Placeholder analysis logic: use simple average trend analysis
    avg_change = df['price_change'].mean()
    return "up" if avg_change > 0 else "down"

# Function to prompt user for confirmation using the LangChain agent
def confirm_action(agent_executor, action, amount, currency, config):
    """Prompt the user to confirm the action using LangChain."""
    prompt = f"The analysis suggests to {action} {amount} {currency}. Do you want to proceed? (yes/no)"
    for chunk in agent_executor.stream(
        {"messages": [HumanMessage(content=prompt)]}, config
    ):
        if "agent" in chunk:
            response = chunk["agent"]["messages"][0].content.strip().lower()
            print(f"response: {response}")
            return response == "yes"


# Function to execute buy or sell action
def execute_trade(action, amount, currency):
    """Execute a trade using CDP AgentKit."""
    try:
        if action == "buy":
            tools["buy_crypto"](amount=amount, currency=currency)
            print(f"Successfully bought {amount} {currency}.")
        elif action == "sell":
            tools["sell_crypto"](amount=amount, currency=currency)
            print(f"Successfully sold {amount} {currency}.")
    except Exception as e:
        print(f"Error executing trade: {e}")

# Autonomous trading function
def run_trading_agent(agent_executor, config):
    """Run the AI agent to analyze and trade meme coin based on user confirmation."""
    csv_file = "memecoin_data.csv"  # Specify your CSV file with meme coin data
    currency = "DOGE"  # Example meme coin
    amount = "100"  # Amount to trade

    # Step 1: Analyze the CSV file
    prediction = analyze_memecoin(csv_file)

    # Step 2: Decide action based on prediction
    action = "buy" if prediction == "up" else "sell"

    # Step 3: Prompt user for confirmation
    # if confirm_action(agent_executor, action, amount, currency, config):
    prompt = input("Do you want to proceed? (yes/no)")

    if prompt.lower() == "yes":
        execute_trade(action, amount, currency)                
    else:
        print(f"Action {action} was not confirmed. No trade executed.")

# Main function
def main():
    """Run the AI agent interactively or autonomously."""
    print("Starting MemeCoin Trading Bot...")
    run_trading_agent(agent_executor, config)

if __name__ == "__main__":
    main()

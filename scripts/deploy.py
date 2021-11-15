from brownie import Spirit, accounts, network, config
import os



def main():
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    publish_source = True if os.getenv("ETHERSCAN_TOKEN") else False
    Spirit.deploy({"from": dev}, publish_source=publish_source)
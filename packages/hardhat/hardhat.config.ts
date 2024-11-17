import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-verify";
import { config as dotEnvConfig } from "dotenv";
import { HardhatUserConfig } from "hardhat/config";

dotEnvConfig();

const config: HardhatUserConfig = {
  networks: {
    alfajores: {
      accounts: [process.env.PRIVATE_KEY ?? "0x0"],
      url: "https://alfajores-forno.celo-testnet.org",
    },
    celo: {
      accounts: [process.env.PRIVATE_KEY ?? "0x0"],
      url: "https://forno.celo.org",
    },
    flowTestnet: {
      accounts: [process.env.PRIVATE_KEY ?? "0x0"],
      url: "https://rest-testnet.onflow.org",
    },
    baseSepolia: {
      accounts: [process.env.PRIVATE_KEY ?? "0x0"],
      url: "https://base-sepolia.public.blastapi.io",
    },
    zircuitSepolia: {
      accounts: [process.env.PRIVATE_KEY ?? "0x0"],
      url: "https://sepolia.zksync.dev",
    },
    scrollSepolia: {
      accounts: [process.env.PRIVATE_KEY ?? "0x0"],
      url: "https://sepolia-rpc.scroll.io",
    },
    bitkubTestnet: {
      accounts: [process.env.PRIVATE_KEY ?? "0x0"],
      url: "https://rpc-testnet.bitkubchain.io",
    },
    // Mantle Testnet
    mantleTestnet: {
      url: "https://rpc.testnet.mantle.xyz",
      chainId: 5001,
      accounts: [process.env.PRIVATE_KEY || ""],
    },
  },
  etherscan: {
    apiKey: {
      alfajores: process.env.CELOSCAN_API_KEY ?? "",
      celo: process.env.CELOSCAN_API_KEY ?? "",
      flowTestnet: process.env.FLOWSCAN_API_KEY ?? "",
      baseSepolia: process.env.BASESCAN_API_KEY ?? "",
      zircuitSepolia: process.env.ZIRCUITSCAN_API_KEY ?? "",
      scrollSepolia: process.env.SCROLLSCAN_API_KEY ?? "",
      bitkubTestnet: process.env.BITKUBSCAN_API_KEY ?? "",
    },
    customChains: [
      {
        chainId: 44787,
        network: "alfajores",
        urls: {
          apiURL: "https://api-alfajores.celoscan.io/api",
          browserURL: "https://alfajores.celoscan.io",
        },
      },
      {
        chainId: 42220,
        network: "celo",
        urls: {
          apiURL: "https://api.celoscan.io/api",
          browserURL: "https://celoscan.io/",
        },
      },
      {
        chainId: 545,
        network: "flowTestnet",
        urls: {
          apiURL: "https://flow-testnet.blockscan.com/api",
          browserURL: "https://flow-view-source.com/testnet",
        },
      },
      {
        chainId: 84532,
        network: "baseSepolia",
        urls: {
          apiURL: "https://api-sepolia.basescan.org/api",
          browserURL: "https://sepolia.basescan.org",
        },
      },
      {
        chainId: 280,
        network: "zircuitSepolia",
        urls: {
          apiURL: "https://api-sepolia.zksync.dev/api",
          browserURL: "https://sepolia.zksync.dev",
        },
      },
      {
        chainId: 534351,
        network: "scrollSepolia",
        urls: {
          apiURL: "https://api.scroll.io/sepolia/api",
          browserURL: "https://sepolia.scroll.io",
        },
      },
      {
        chainId: 25925,
        network: "bitkubTestnet",
        urls: {
          apiURL: "https://api-testnet.bkcscan.com/api",
          browserURL: "https://testnet.bkcscan.com",
        },
      },
      {
        network: "mantleTestnet",
        chainId: 5001,
        urls: {
          apiURL: "https://explorer.testnet.mantle.xyz/api",
          browserURL: "https://explorer.testnet.mantle.xyz",
        },
      },
    ],
  },
  sourcify: {
    enabled: false,
  },
  solidity: "0.8.24",
};

export default config;

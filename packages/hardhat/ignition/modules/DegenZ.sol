import { ethers } from "hardhat";
import * as dotenv from "dotenv";

dotenv.config();

async function main() {
  // Fetch the deployer's account using the Hardhat runtime environment
  const [deployer] = await ethers.getSigners();
  console.log(`Deploying the contract using account: ${deployer.address}`);

  // Log the deployer's balance
  const balance = await deployer.getBalance();
  console.log(`Deployer's balance: ${ethers.utils.formatEther(balance)} ETH`);

  // Specify the initial supply (e.g., 1 million DEGENZ tokens)
  const initialSupply = ethers.utils.parseEther("1000000"); // 1,000,000 DEGENZ

  // Get the contract factory and deploy the contract
  const Degenz = await ethers.getContractFactory("Degenz");
  const degenz = await Degenz.deploy(initialSupply);

  await degenz.deployed();
  console.log(`Degenz contract deployed at address: ${degenz.address}`);

  // Verify that the initial supply was correctly minted
  const totalSupply = await degenz.totalSupply();
  console.log(`Total supply after deployment: ${ethers.utils.formatEther(totalSupply)} DEGENZ`);
}

// Error handling and execution
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error during deployment:", error);
    process.exit(1);
  });

const hre = require("hardhat");

async function main() {
  const ReverseLogistics = await hre.ethers.getContractFactory("ReverseLogistics");
  const reverseLog = await ReverseLogistics.deploy();

  await reverseLog.deployed();

  console.log(
    `Contract deployed - Address: ${reverseLog.address}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

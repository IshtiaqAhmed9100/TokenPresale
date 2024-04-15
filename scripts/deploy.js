const { time } = require("console");
const { setServers } = require("dns");
const { ethers } = require("hardhat");
const { run } = require("hardhat");
async function verify(address, constructorArguments) {
  console.log(
    `verify  ${address} with arguments ${constructorArguments.join(",")}`
  );
  await run("verify:verify", {
    address,
    constructorArguments,
  });
}
async function main() {
  let token = "0xDb592b20B4d83D41f9E09a933966e0AC02E7421B"; 
  let testToken = "0x4040E16930B40bC9447257CC762E255039E3Cd6d"; 
  let testTokenWallet = "0x19A865ab3A6E9DD7ac716891B0080b2cB3ffb9fa"; 
  let fundingWallet = "0x395bFD879A3AE7eC4E469e26c8C1d7BB2F9d77B9"; 

  let price = "1000000";
  let TokenPresaleStartTime = "1713170144"; 
  let TokenPresaleEndTime =  "1713578522"; 
  


    const TokenPresale = await ethers.deployContract( 'TokenPresale' , [token, testToken,  testTokenWallet, fundingWallet, price, TokenPresaleStartTime, TokenPresaleEndTime]);

      console.log("Deploying TokenPresale...");
      await TokenPresale.waitForDeployment()

      console.log("TokenPresale deployed to:", TokenPresale.target);

      await new Promise(resolve => setTimeout(resolve, 10000));
  verify("0x70D68F42725607b0D9F8e7Cf18Bcd5C48Bf6Cda4",  [token, testToken,  testTokenWallet, fundingWallet, price, TokenPresaleStartTime, TokenPresaleEndTime]);
}
main();
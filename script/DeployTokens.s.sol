// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Script.sol";
import "../src/MockERC20.sol";

contract DeployTokens is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Fetch the deployer address
        address deployer = vm.addr(deployerPrivateKey);
        console.log("Deployer address:", deployer);

        // Fetch the MINT_ADDRESS from the environment variables
        address mintAddress = vm.envAddress("MINT_ADDRESS");
        console.log("Mint address:", mintAddress);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy tokens
        MockERC20 dusdc = new MockERC20("Deca USD", "DUSDC", 6); // Same decimals as USDC
        console.log("DUSDC deployed to:", address(dusdc));

        MockERC20 om = new MockERC20("Mantra", "OM", 18);
        console.log("OM deployed to:", address(om));

        MockERC20 ena = new MockERC20("ENA", "ENA", 18);
        console.log("ENA deployed to:", address(ena));

        // Mint tokens to a specific address
        dusdc.mint(deployer, 1_000_000 * 10 ** 6); // 1,000,000 DUSDC
        om.mint(deployer, 1_000_000 * 10 ** 18); // 1,000,000 OM
        ena.mint(deployer, 1_000_000 * 10 ** 18); // 1,000,000 ENA

        vm.stopBroadcast();
    }
}

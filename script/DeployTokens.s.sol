// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Script.sol";
import "../src/MockERC20.sol";

contract DeployTokens is Script {
    // File path to store deployment addresses
    string constant DEPLOYMENT_FILE = "./logs/deployments.json";

    struct Deployment {
        address dusdc;
        address om;
        address ena;
        address dwewe;
    }

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Fetch the deployer address
        address deployer = vm.addr(deployerPrivateKey);
        console.log("Deployer address:", deployer);

        // Fetch the MINT_ADDRESS from the environment variables
        address mintAddress = vm.envAddress("MINT_ADDRESS");
        console.log("Mint address:", mintAddress);

        Deployment memory deployment;
        bool deploymentsExist = false;

        // Load existing deployment addresses if they exist
        try vm.readFile(DEPLOYMENT_FILE) returns (string memory json) {
            deployment = abi.decode(vm.parseJson(json, ""), (Deployment));
            deploymentsExist = true;
        } catch {
            console.log("No existing deployments found. Deploying new contracts.");
        }

        vm.startBroadcast(deployerPrivateKey);

        if (!deploymentsExist) {
            // Deploy tokens
            MockERC20 dusdc = new MockERC20("Deca USD", "DUSDC", 6); // Same decimals as USDC
            deployment.dusdc = address(dusdc);
            console.log("DUSDC deployed to:", address(dusdc));

            MockERC20 om = new MockERC20("Mantra", "OM", 18);
            deployment.om = address(om);
            console.log("OM deployed to:", address(om));

            MockERC20 ena = new MockERC20("ENA", "ENA", 18);
            deployment.ena = address(ena);
            console.log("ENA deployed to:", address(ena));

            MockERC20 dwewe = new MockERC20("dWEWE", "DWEWE", 18);
            deployment.dwewe = address(dwewe);
            console.log("DWEWE deployed to:", address(dwewe));

            // Serialize the deployment addresses and save to a file
            string memory namespace = "deployment";
            vm.serializeAddress(namespace, "dusdc", deployment.dusdc);
            vm.serializeAddress(namespace, "om", deployment.om);
            vm.serializeAddress(namespace, "ena", deployment.ena);
            vm.serializeAddress(namespace, "dwewe", deployment.dwewe);

            // Manually encode the struct fields into JSON format
            string memory jsonData = string(
                abi.encodePacked(
                    "{",
                    '"dusdc":"',
                    addressToString(deployment.dusdc),
                    '",',
                    '"om":"',
                    addressToString(deployment.om),
                    '",',
                    '"ena":"',
                    addressToString(deployment.ena),
                    '",',
                    '"dwewe":"',
                    addressToString(deployment.dwewe),
                    '"',
                    "}"
                )
            );

            // Convert the serialized data into JSON and write it to the deployment file
            string memory json = vm.serializeJson(namespace, jsonData);
            vm.writeFile(DEPLOYMENT_FILE, json);
        } else {
            console.log("Using existing deployments:");
            console.log("DUSDC address:", deployment.dusdc);
            console.log("OM address:", deployment.om);
            console.log("ENA address:", deployment.ena);
            console.log("DWEWE address:", deployment.dwewe);
        }

        // Mint tokens to a specific address
        MockERC20(deployment.dusdc).mint(mintAddress, 1_000_000 * 10 ** 6); // 1,000,000 DUSDC
        MockERC20(deployment.om).mint(mintAddress, 1_000_000 * 10 ** 18); // 1,000,000 OM
        MockERC20(deployment.ena).mint(mintAddress, 1_000_000 * 10 ** 18); // 1,000,000 ENA
        MockERC20(deployment.dwewe).mint(mintAddress, 1_000_000 * 10 ** 18); // 1,000,000 DWEWE

        vm.stopBroadcast();
    }

    // Helper function to convert an address to a string
    function addressToString(address _addr) internal pure returns (string memory) {
        bytes32 value = bytes32(uint256(uint160(_addr)));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(42);
        str[0] = "0";
        str[1] = "x";
        for (uint256 i = 0; i < 20; i++) {
            str[2 + i * 2] = alphabet[uint8(value[i + 12] >> 4)];
            str[3 + i * 2] = alphabet[uint8(value[i + 12] & 0x0f)];
        }
        return string(str);
    }
}

import { HardhatUserConfig } from "hardhat/types";
import "@shardlabs/starknet-hardhat-plugin";
import * as dotenv from "dotenv";
dotenv.config();

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
const config: HardhatUserConfig = {
    starknet: {
        // dockerizedVersion: "0.11.0.1", // alternatively choose one of the two venv options below
        // uses (my-venv) defined by `python -m venv path/to/my-venv`
        // venv: "path/to/my-venv",

        // uses the currently active Python environment (hopefully with available Starknet commands!)
        venv: "active",
        recompile: false,
        // manifestPath: "path/to/Cargo.toml",
        network: "devnet",
        wallets: {
            OpenZeppelin: {
                accountName: "OpenZeppelin",
                modulePath: "starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount",
                accountPath: "~/.starknet_accounts"
            }
        }
    },
    networks: {
        alphaGoerli: {
            url: "https://alpha4.starknet.io"
        },
        devnet: {
            url: "http://127.0.0.1:5050"
        },
        integratedDevnet: {
            url: "http://127.0.0.1:5050",
            // venv: "active",
            // dockerizedVersion: "<DEVNET_VERSION>",
            args: [
                // Uncomment the lines below to activate Devnet features in your integrated-devnet instance
                // Read about Devnet options here: https://shard-labs.github.io/starknet-devnet/docs/guide/run
                //
                // *Account predeployment*
                "--seed",
                "42",
                "--timeout",
                "5000",
            ]
        },
        hardhat: {}
    }
};

export default config;
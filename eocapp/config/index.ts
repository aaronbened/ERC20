import { Contract, ContractRunner } from "ethers";
import abi from "./abi.json";

export function getContract(signer: ContractRunner) {
    return new Contract(
        "0x6dE98B211038d84FF10A68879048C33027bf3694",
        abi as any,
        signer
    );
}
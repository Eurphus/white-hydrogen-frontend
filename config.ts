
import { readFileSync } from 'fs';

export const network = readFileSync("./hydro-config/network", 'utf8');
export const rpcUrl = readFileSync("./hydro-config/rpc-url", 'utf8');
function zos_ganache() {
  ganache-cli --port 9545 --deterministic
}

function zos_address() {
  cat zos.dev-1550373994689.json | jq '.contracts.SafeDeploy.address' | tr -d '"'
}

function zos_session() {
  zos session --network local --from 0x1df62f291b2e969fb0849d99d9ce41e2f137006e --expires 3600
}


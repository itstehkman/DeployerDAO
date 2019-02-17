pragma solidity ^0.4.18;

import 'chainlink/solidity/contracts/Chainlinked.sol';
import 'zos-lib/contracts/Initializable.sol';

/**
 * @title GitHubDeployCheck
 * @dev a check that is used to gate deploys
 */
contract GitHubCheck is Initializable, Chainlinked {
    bytes32 constant GET_BYTES32_JOB = bytes32("5b280bfed77646d297fdb6e718c7127a");

    bool public passed;

    event Passed(bool passed, bytes32 additionalData);

    function initialize() initializer public {
      // Ropsten values for Chainlink
      setLinkToken(0x20fE562d797A42Dcb3399062AE9546cd06f63280);
      setOracle(0xc99B3D447826532722E41bc36e644ba3479E4365);
    }

    function pass() external returns (bool) {
        return passed;
    }

    function requestGitHubChecks() public returns (bytes32 requestId) {
      // newRequest takes a JobID, a callback address, and callback function as input
      Chainlink.Request memory req = newRequest(GET_BYTES32_JOB, this, this.gitHubChecksCallback.selector);
      // TODO: update this with an actual API endpoint, instead of ngrok
      // You must run ngrok locally, and use the endpoint that ngrok gives you (need to change this)
      req.add("get", "http://50106279.ngrok.io/assets/github_checks_response.json");
      requestId = chainlinkRequest(req, 1 * LINK);
    }

    function gitHubChecksCallback(bool _passed) external {
      passed = _passed;
      emit Passed(passed, 0x0);
    }
}

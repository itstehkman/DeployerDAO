pragma solidity ^0.5.0;

/**
 * @title IDeployCheck
 * @dev a check that is used to gate deploys
 */
interface IDeployCheck {
    function pass() external returns (bool);
    event Passed(bool passed, bytes32 additionalData);
}

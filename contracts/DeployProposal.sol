pragma solidity 0.5.0;

import 'openzeppelin-eth/contracts/ownership/Ownable.sol';
import 'openzeppelin-eth/contracts/math/SafeMath.sol';
import 'zos-lib/contracts/Initializable.sol';

import './IDeployCheck.sol';
import './SafeDeploy.sol';

// Anyone can make a Deploy Proposal. The DAO votes on checks that
// it must fulfill before going out.
contract DeployProposal is Initializable, Ownable {
    using SafeMath for uint;

    uint256 public numDeployChecks;
    IDeployCheck[] public deployChecks;
    SafeDeploy deployerDao;

    function initialize() public initializer {
      super.initialize(msg.sender);
    }

    function setDao(address payable _deployerDao) onlyOwner external {
      deployerDao = SafeDeploy(_deployerDao);
    }

    modifier onlyDao {
        require(msg.sender == address(deployerDao));
        _;
    }

    // DAO will vote on these checks - they are what have the proposals
    function addDeployCheck(IDeployCheck check) payable onlyDao external {
      // trigger SafeMath checks
      numDeployChecks.add(1);

      deployChecks[numDeployChecks] = check;
      numDeployChecks = numDeployChecks.add(1);
    }

    // Attempts to allow the deploy. Deployment tools can check
    // the registry for the status
    function attemptToAllowDeploy() onlyOwner external {
      require(deployChecks.length >= 1);

      for (uint256 i=0; i < deployChecks.length; i++) {
        require(deployChecks[i].pass());
      }

      deployerDao.setSafe(address(this));
    }
}

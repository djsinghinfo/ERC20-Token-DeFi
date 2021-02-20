// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.10;

import {IERC20} from "../interfaces/IERC20.sol";
import {SafeMath} from "../open-zeppelin/SafeMath.sol";
import {VersionedInitializable} from "../utils/VersionedInitializable.sol";


/**
* @title LendToPxldMigrator
* @notice This contract implements the migration from LEND to PXLD token
* @author PXLD 
*/
contract LendToPxldMigrator is VersionedInitializable {
    using SafeMath for uint256;

    IERC20 public immutable PXLD;
    IERC20 public immutable LEND;
    uint256 public immutable LEND_PXLD_RATIO;
    uint256 public constant REVISION = 1;
    
    uint256 public _totalLendMigrated;

    /**
    * @dev emitted on migration
    * @param sender the caller of the migration
    * @param amount the amount being migrated
    */
    event LendMigrated(address indexed sender, uint256 indexed amount);

    /**
    * @param pxld the address of the PXLD token
    * @param lend the address of the LEND token
    * @param lendPxldRatio the exchange rate between LEND and PXLD 
     */
    constructor(IERC20 pxld, IERC20 lend, uint256 lendPxldRatio) public {
        PXLD = pxld;
        LEND = lend;
        LEND_pxld_RATIO = lendPxldRatio;
    }

    /**
    * @dev initializes the implementation
    */
    function initialize() public initializer {
    }

    /**
    * @dev returns true if the migration started
    */
    function migrationStarted() external view returns(bool) {
        return lastInitializedRevision != 0;
    }


    /**
    * @dev executes the migration from LEND to PXLD. Users need to give allowance to this contract to transfer LEND before executing
    * this transaction.
    * @param amount the amount of LEND to be migrated
    */
    function migrateFromLEND(uint256 amount) external {
        require(lastInitializedRevision != 0, "MIGRATION_NOT_STARTED");

        _totalLendMigrated = _totalLendMigrated.add(amount);
        LEND.transferFrom(msg.sender, address(this), amount);
        PXLD.transfer(msg.sender, amount.div(LEND_PXLD_RATIO));
        emit LendMigrated(msg.sender, amount);
    }

    /**
    * @dev returns the implementation revision
    * @return the implementation revision
    */
    function getRevision() internal pure override returns (uint256) {
        return REVISION;
    }

}
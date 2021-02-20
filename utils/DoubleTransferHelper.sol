// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.10;

import "../interfaces/IERC20.sol";

contract DoubleTransferHelper {

    IERC20 public immutable PXLD;

    constructor(IERC20 pxld) public {
        PXLD = pxld;
    }

    function doubleSend(address to, uint256 amount1, uint256 amount2) external {
        PXLD.transfer(to, amount1);
        PXLD.transfer(to, amount2);
    }
}
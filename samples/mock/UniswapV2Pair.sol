// contracts/UniswapV2Pair.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract UniswapV2Pair {
    uint112 private _reserve0;
    uint112 private _reserve1;
    uint32 private _blockTimestampLast;

    constructor() {
       _reserve0 = 26941580678102761764492935833;
       _reserve1 = 60297003034024430932;
       _blockTimestampLast = 1707047767;
    }

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast){
        return (_reserve0, _reserve1, _blockTimestampLast);
    }
}

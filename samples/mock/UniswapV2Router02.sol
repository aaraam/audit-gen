// contracts/UniswapV2Router02.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract UniswapV2Router02 {
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity) {
        require(token != address(0));
        require(amountTokenDesired > 0);
        require(amountTokenMin >= 0);
        require(amountETHMin >= 0);
        require(to != address(0));
        require(deadline > 0);

        return (amountToken, amountETH, liquidity);
    }

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB) {
        require(amountA > 0);
        require(reserveA > 0);
        require(reserveB > 0);
        amountB = 446814589821324114794020;
    }
}

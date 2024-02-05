// contracts/IUniswapV2Router02.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IUniswapV2Router02 {
    
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
}
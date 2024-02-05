// contracts/MVDBXLiquidity.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/IUniswapV2Router02.sol";
import "./interface/IUniswapV2Pair.sol";

contract MVDBXLiquidity is Context {

    IUniswapV2Router02 internal _uniswapV2Router02;
    IUniswapV2Pair internal _mvdbxBnbPair;
    IERC20 internal _mvdbxToken;
    uint256 private constant MVDBX_BNB_RATIO = 500e6; // 1 MVDBX = 500 BNB

    struct Lending {
        uint256 deposits;
        uint256 withdrawals;
        uint256 liquidity;
    }

    mapping(address => Lending) private _lendings; // user => Lending

    event Deposit(address indexed src, uint256 amount);
    event Withdraw(address indexed src, uint256 amount);
    event Swap(address indexed src, uint256 amount, uint256 bnb);

    constructor(
        IERC20 mvdbxToken_, 
        IUniswapV2Router02 uniswapV2Router02_,
        IUniswapV2Pair mvdbxBnbPair_
    ) {
        _mvdbxToken = mvdbxToken_;
        _uniswapV2Router02 = uniswapV2Router02_;
        _mvdbxBnbPair = mvdbxBnbPair_;
        _mvdbxToken.approve(address(_uniswapV2Router02), type(uint).max); // approve max
    }

    receive() external payable {} // to receive BNB

    function depositMVDBX(uint256 amount) external {
        require(amount > 0, "MVDBXLiquidity: Zero deposit amount");
        _mvdbxToken.transferFrom(_msgSender(), address(this), amount);
        _lendings[_msgSender()].deposits += amount;
        emit Deposit(_msgSender(), amount);
    }

    function withdrawMVDBX() external {
        uint256 amount = _lendings[_msgSender()].deposits - (_lendings[_msgSender()].withdrawals + _lendings[_msgSender()].liquidity); // only withdrawable amount
        require(amount > 0, "MVDBXLiquidity: Invalid withdrawable amount");
        _lendings[_msgSender()].withdrawals += amount;
        _mvdbxToken.transfer(_msgSender(), amount);
        emit Withdraw(_msgSender(), amount);
    }

    function swap(address liquidityProvider) external payable {
        uint256 liquidityAmount = _lendings[liquidityProvider].deposits - (_lendings[liquidityProvider].withdrawals + _lendings[liquidityProvider].liquidity); // only swappable amount
        require(liquidityAmount > 0, "MVDBXLiquidity: Invalid liquidity amount");

        (uint112 reserve0, uint112 reserve1, ) = _mvdbxBnbPair.getReserves();

        uint256 mvdbxMinAmount = _uniswapV2Router02.quote(msg.value, reserve1, reserve0);

        uint256 releasableMvdbx = msg.value * MVDBX_BNB_RATIO;

        require(liquidityAmount >= mvdbxMinAmount + releasableMvdbx, "MVDBXLiquidity: Invalid mvdbx liquidity");

        _lendings[liquidityProvider].liquidity += (mvdbxMinAmount + releasableMvdbx);

        _uniswapV2Router02.addLiquidityETH{value: msg.value}(
            address(_mvdbxToken),
            mvdbxMinAmount,
            0,
            0,
            liquidityProvider,
            block.timestamp
        );

        _mvdbxToken.transfer(_msgSender(), releasableMvdbx);

        uint256 remainingBalance = address(this).balance;
        if (remainingBalance > 0) {
            payable(_msgSender()).transfer(remainingBalance);
        }

        emit Swap(_msgSender(), mvdbxMinAmount + releasableMvdbx, msg.value);
    }

    function approveSwap() external {
        _mvdbxToken.approve(address(_uniswapV2Router02), type(uint).max);
    }

    function lendingOf(address account) public view returns (
        uint256 deposits, 
        uint256 withdrawals, 
        uint256 liquidity
    ) {
        return (
            _lendings[account].deposits,
            _lendings[account].withdrawals,
            _lendings[account].liquidity
        );
    }

    function quote(uint256 bnb) external view returns (uint256 mvdbxMinAmount) {
        (uint112 reserve0, uint112 reserve1, ) = _mvdbxBnbPair.getReserves();

        mvdbxMinAmount = _uniswapV2Router02.quote(bnb, reserve1, reserve0);
    }

    function version() internal pure returns (uint256) {
        return 3;
    }
}
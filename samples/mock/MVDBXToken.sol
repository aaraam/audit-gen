// contracts/VOWToken.sol
// SPDX-License-Identifier: None
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract MVDBXToken is ERC20Burnable {
    constructor() ERC20("MVDBX", "MVDBX") {
        _mint(_msgSender(), 1e27);
    }
}
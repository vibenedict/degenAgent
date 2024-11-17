// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Degenz - A Meme Coin with Reflection and Auto-Burn Mechanisms
/// @dev This contract implements an ERC20 token with reflection and auto-burn functionality.
contract Degenz is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10 ** 18; // 1 billion tokens
    uint256 public burnRate = 2; // 2% burn on each transfer
    uint256 public reflectionRate = 2; // 2% reflection on each transfer
    uint256 public maxTxAmount = 10_000_000 * 10 ** 18; // Max 10 million tokens per transaction

    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => uint256) private _reflectedBalances;
    uint256 private _totalReflected;

    event Burn(address indexed from, uint256 amount);
    event ReflectionDistributed(uint256 amount);

    /// @notice Constructor to initialize the Degenz token with initial supply.
    /// @param initialSupply The initial amount of tokens to mint to the deployer.
    constructor(uint256 initialSupply) ERC20("Degenz", "DEGENZ") {
        require(
            initialSupply <= MAX_SUPPLY,
            "Initial supply exceeds max supply"
        );
        _mint(msg.sender, initialSupply);
        _isExcludedFromFees[msg.sender] = true; // Exclude owner from fees
    }

    /// @notice Override transfer function to include burn and reflection logic.
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
        require(
            amount <= maxTxAmount,
            "Transfer amount exceeds the maxTxAmount"
        );

        if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
            super._transfer(sender, recipient, amount);
        } else {
            // Calculate burn and reflection amounts
            uint256 burnAmount = (amount * burnRate) / 100;
            uint256 reflectionAmount = (amount * reflectionRate) / 100;
            uint256 transferAmount = amount - burnAmount - reflectionAmount;

            // Burn a portion of the tokens
            _burn(sender, burnAmount);
            emit Burn(sender, burnAmount);

            // Reflect a portion of the tokens to all holders
            _distributeReflection(reflectionAmount);
            emit ReflectionDistributed(reflectionAmount);

            // Transfer the remaining tokens to the recipient
            super._transfer(sender, recipient, transferAmount);
        }
    }

    /// @notice Distribute reflection to all token holders
    function _distributeReflection(uint256 reflectionAmount) private {
        if (totalSupply() > 0) {
            _totalReflected += reflectionAmount;
        }
    }

    /// @notice Exclude an account from fees
    function excludeFromFees(address account) external onlyOwner {
        _isExcludedFromFees[account] = true;
    }

    /// @notice Include an account for fees
    function includeInFees(address account) external onlyOwner {
        _isExcludedFromFees[account] = false;
    }

    /// @notice Update the burn rate
    function setBurnRate(uint256 newRate) external onlyOwner {
        require(newRate <= 10, "Burn rate cannot exceed 10%");
        burnRate = newRate;
    }

    /// @notice Update the reflection rate
    function setReflectionRate(uint256 newRate) external onlyOwner {
        require(newRate <= 10, "Reflection rate cannot exceed 10%");
        reflectionRate = newRate;
    }

    /// @notice Update the maximum transaction amount
    function setMaxTxAmount(uint256 newMax) external onlyOwner {
        maxTxAmount = newMax;
    }

    /// @notice Burn tokens from the caller's account
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    /// @notice Get the total reflections distributed
    function totalReflected() external view returns (uint256) {
        return _totalReflected;
    }
}

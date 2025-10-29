// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {BaseHook} from "v4-periphery/src/utils/BaseHook.sol";
import {ERC1155} from "solmate/src/tokens/ERC1155.sol";

import {PoolKey} from "v4-core/types/PoolKey.sol";
import {PoolId} from "v4-core/types/PoolId.sol";
import {BalanceDelta} from "v4-core/types/BalanceDelta.sol";


import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";

import {Hooks} from "v4-core/libraries/Hooks.sol";

contract PointsHook is BaseHook, ERC1155{
    constructor(
        IPoolManager _manager
    ) BaseHook(_manager) {}
}

contract PointsHook is BaseHook, ERC1155 {
    constructor(
        IPoolManager _manager
    ) BaseHook{_manager} {}

    // sets up hook permission to return 'true'
    // for the two hook functions we are using
    function getHookPermission() public pure override returns(Hooks.Permissions memory) {
        return Hooks.Permissions({
            beforeInitialize: false,
            afterInitialize: false,
            beforeAddLiquidity: false,
            beforeRemoveLiquidity: false,
            afterAddLiquidity: false,
            afterRemoveLiquidity: false,
            beforeSwap: false,
            afterSwap: true,
            beforeDonate: false,
            afterDonate: false,
            beforeSwapReturnDelta: false,
            afterSwapReturnDelta: false,
            afterAddLiquidityReturnDelta: false,
            afterRemoveLiquidityReturnDelta: false
        })
    }

    // Implements ERC1155 'uri' function
    function uri(uint256) public view virtual override returns(string memory) {
        return "https://api.example.com/token/{id}"
    }

    function _afterSwap(
        address, 
        PoolKey calldata key,
        SwapParams calldata swapParams,
        BalanceDelta delta,
        bytes calldata hookData
    ) internal override returns(bytes4, int128) {
        // if not a ETH-TOKEN pool then ignore
        if (!key.currency0.isAddressZero()) return (this.afterSwap.selector, 0);

        if (!swapParams.zeroForOne) return (this.afterSwap.seletor, 0);

    // Mint points equal to 20% of the amount of ETH they spent
    // Since it's a zeroForOne swap:
    // if amountSpecified < 0:
    //      this is an "exact input for output" swap
    //      amount of ETH they spent is equal to |amountSpecified|
    // if amountSpecified > 0:
    //      this is an "exact output for input" swap
    //      amount of ETH they spent is equal to BalanceDelta.amount0()

        uint256 ethSpendAmount = uint256(int256(-delta.amount0()));
        uint256 pointsForSwap = ethSpendAmount / 5;

        // Mint the points
        _assignPoints(key.toId(), hookData, pointsForSwap);

        return (this.afterSwap.selector, 0);
    }

    function _assignPoints(PoolId poolId, bytes calldata hookData, uint256 points) internal {
        // no hooks = no points
        if (hookData.length == 0) return;

        // Get current user address
        address user = abi.decode(hookData, (address));
        
        if (user == address(0)) return;

        // mint points to user
        uint256 poolIdUnit = uint256(PoolId.unwrap(poolId));
        _mint(user, poolIdUnit, points, "");
    }
        
}
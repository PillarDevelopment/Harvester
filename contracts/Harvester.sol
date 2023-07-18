// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Harvester {

    address internal pool;

    address internal constant universalRouter = 0x3fC91A3afd70395Cd496C647d5a6CC9D4B2b7FAD;

    address internal constant permit2 = 0x000000000022D473030F116dDEE9F6B43aC78BA3;

    address internal nonfungiblePositionManager = 0xC36442b4a4522E871399CD717aBDD847Ab11FE88;

    uint256 internal tokenId = 731280;

    constructor(address _pool)  {
       pool = _pool;
    }


    function performHarvest(uint256 amount0ToMint, uint256 amount1ToMint) external {
        // swap token
        // token1(pool).approve(permit2, _amount);
        bytes[] memory inputs;
        // universalRouter.execute(0x00, inputs, block.timestamp + 900);
        // Approve the position manager
        nonfungiblePositionManager.positions(tokenId).token0;
        TransferHelper.safeApprove(nonfungiblePositionManager.positions(tokenId).token0, address(nonfungiblePositionManager), amount0ToMint);
        TransferHelper.safeApprove(nonfungiblePositionManager.positions(tokenId).token1, address(nonfungiblePositionManager), amount1ToMint);

        INonfungiblePositionManager.MintParams memory params =
                            INonfungiblePositionManager.MintParams({
                token0: nonfungiblePositionManager.positions(tokenId).token0,
                token1: nonfungiblePositionManager.positions(tokenId).token1,
                fee: 3000,
                tickLower: TickMath.MIN_TICK,
                tickUpper: TickMath.MAX_TICK,
                amount0Desired: amount0ToMint,
                amount1Desired: amount1ToMint,
                amount0Min: 0,
                amount1Min: 0,
                recipient: address(this),
                deadline: block.timestamp
            });

        // Note that the pool defined by DAI/USDC and fee tier 0.3% must already be created and initialized in order to mint
        (tokenId, liquidity, amount0, amount1) = nonfungiblePositionManager.mint(params);

    }


    function reCapitalize() external {
        // CollectParams calldata params;
        // nonfungiblePositionManager.collect(params);
        // nonfungiblePositionManager.increaseLiquidity();
    }


    function stopHarvest() external {
        // nonfungiblePositionManager.decreaseLiquidity();
        // nonfungiblePositionManager.collect();
    }
}

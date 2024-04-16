// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenPresale is Ownable {
    event claim(address indexed userAddress);

    IERC20 public usdtToken;
    IERC20 public presaleToken;

    uint256 public price;
    uint256 public presaleStartTime;
    uint256 public presaleEndTime;
    address public presaleTokenWallet;
    address public fundingWallet;

    mapping(address => uint256) public userTokens;

    constructor(
        address _usdtToken,
        address _presaleToken,
        address _presaleTokenWallet,
        address _fundingWallet,
        uint256 _price,
        uint256 _presaleStartTime,
        uint256 _presaleEndTime
    ) Ownable(msg.sender) {
        usdtToken = IERC20(_usdtToken); // setting the usdt token
        presaleToken = IERC20(_presaleToken); //token Address
        presaleTokenWallet = _presaleTokenWallet; //wallet having test tokens
        fundingWallet = _fundingWallet; //funding wallet to recieve usdt;
        _price = 1 * (10 ** 6); //setttting the token price in usdt
        price = _price;
        _presaleStartTime = block.timestamp; //start time
        presaleStartTime = _presaleStartTime;
        _presaleEndTime = block.timestamp + 7 days; //end timess
        presaleEndTime = _presaleEndTime;
    }

    // fuunction for conveertin the pricee of eth into usdt
    function convertETH(uint256 amount) public pure returns (uint256) {
        uint256 ethPriceUpdated = (amount * 3500 * (10 ** 18)) / 10 ** 36; //converting et price by multiplying with usdt value (3500)
        return (ethPriceUpdated); //return usdt converted eth value price (10 ** 6)
    }

    //function for buyying token with eth
    function buyTokens() external payable {
        require( //requiring that presale is started || not ended
            block.timestamp > presaleStartTime &&
                block.timestamp <= presaleEndTime
        );
        require(msg.value > 0, "Value must be greater than 0"); //eth value should be more than 0;

        // wallet transder eth

        uint256 convertedEthToUsdt = convertETH(msg.value); //cconverteed eth value to usdt using convertETH function

        uint256 tokenAmount = convertedEthToUsdt / price; // clacuulatting token amount, cconversion

        userTokens[msg.sender] += tokenAmount; //adding tokeen value to the mapping
    }

    //funtion for buying token with usdt
    function buyTokensWithUSDT(uint256 tokenAmount) external payable {
        require(tokenAmount > 0); // ussdt value should be greater than 0

        usdtToken.transferFrom(
            msg.sender,
            fundingWallet,
            tokenAmount * (10 ** 6)
        ); // transerriing usdt valuee tto funding wallet

        uint256 TokensBoughtWithUsdt = tokenAmount * (10 ** 18)/ price; //geettting the token from th given usdt value

        userTokens[msg.sender] = userTokens[msg.sender] + TokensBoughtWithUsdt; // adding token amount
    }

    //function for claiming test tokens
    function claimTokens(address user) public {
        uint256 tokenAmount = userTokens[user]; // storing test tokens amount
        presaleToken.transferFrom(presaleTokenWallet, user, tokenAmount); //transfer to user address

        delete userTokens[user];
    }

    function checkBalance() public view returns (uint256) {
        return IERC20(usdtToken).balanceOf(address(this));
    }

    function getBalance(address _add) public view returns (uint256) {
        return IERC20(usdtToken).balanceOf(_add);
    }

    function setStartTime(uint256 newStartTime) private {
        require(
            block.timestamp < presaleEndTime ||
                block.timestamp > presaleStartTime
        );
        presaleStartTime = newStartTime;
    }

    function setEndTime(uint256 newEndTime) private {
        require(block.timestamp > presaleStartTime);
        presaleEndTime = newEndTime;
    }
}

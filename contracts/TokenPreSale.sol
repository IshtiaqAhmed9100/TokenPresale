// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenPresale is Ownable {
    event claim(address indexed userAddress);

    IERC20 public token;
    IERC20 public testToken;

    uint256 public price;
    uint256 public presaleStartTime;
    uint256 public presaleEndTime;
    address public testTokenWallet;
    address public fundingWallet;

    mapping(address => uint256) public userTokens;
    mapping(address => uint256) public claimIds;

    constructor(
    address _token,
    address _testToken,
    address _testTokenWallet,
    address _fundingWallet,

    uint256 _price,
    uint256 _presaleStartTime,
    uint256 _presaleEndTime

    ) Ownable(msg.sender) {
        token = IERC20(_token); // setting the usdt token
        testToken = IERC20(_testToken); //token Address
        testTokenWallet = _testTokenWallet; //wallet having test tokens
        fundingWallet = _fundingWallet; //funding wallet to recieve usdt;
        _price = 1 * (10 ** 6); //setttting the token price in usdt
        price = _price;
        _presaleStartTime = block.timestamp; //start time
        presaleStartTime = _presaleStartTime;
        _presaleEndTime = block.timestamp + 7 days; //end timess
        presaleEndTime = _presaleEndTime;
    }

    // fuunction for conveertin the pricee of eth into usdt
    function convertETH(uint256 amoun) public pure returns (uint256) {
        uint256 ethPriceUpdated = (amoun * 3500 * (10 ** 18)) / 10 ** 30; //converting et price by multiplying with usdt value (3500)
        return (ethPriceUpdated); //return usdt converted eth value price (10 ** 6)
    }

    //function for buyying token with eth
    function buyTokens() external payable {
        require( //requiringg that presale is started || not ended
            block.timestamp > presaleStartTime &&
                block.timestamp <= presaleEndTime
        );
        require(msg.value > 0, "Value must be greater than 0"); //eth value should be more than 0;

        // wallet transder eth

        uint256 convertedEthToUsdt = convertETH(msg.value); //cconverteed eth value to usdt using convertETH function

        uint256 tokenAmount = (convertedEthToUsdt * (10 ** 6)) / price; // clacuulatting token amount, cconversion

        userTokens[msg.sender] += tokenAmount; //adding tokeen value to the mapping
    }

    //funtion for buying token with usdt
    function buyTokensWithUSDT(uint256 am) external payable {
        require(am > 0); // ussdt value should be greater than 0

        token.transferFrom(msg.sender, fundingWallet, am * (10 ** 6)); // transerriing usdt valuee tto funding wallet

        uint256 TokensBoughtWithUsdt = am / price; //geettting the token from th given usdt value

        userTokens[msg.sender] = userTokens[msg.sender] + TokensBoughtWithUsdt; // adding token amount
    }

    //function for claiming test tokens
    function claimTokens(address ad) public {
        require(claimIds[ad] < 1, "user can claim once"); //checking the claim id status

        uint256 tokenAmount = userTokens[ad]; // storing test tokens amount
        testToken.transferFrom(testTokenWallet, ad, tokenAmount); //transfer to user address

        claimIds[ad] += 1; //updating claim status of user
    }

    function checkBalance() public view returns (uint256) {
        return IERC20(token).balanceOf(address(this));
    }

    function getBalance(address _add) public view returns (uint256) {
        return IERC20(token).balanceOf(_add);
    }

    function setStartTime(uint256 newStartTime) private {
        require(block.timestamp < presaleEndTime);
        presaleStartTime = newStartTime;
    }

    function setEndTime(uint256 newEndTime) private {
        require(block.timestamp > presaleStartTime);
        presaleEndTime = newEndTime;
    }

    function TokenSimpleValue() external view returns (uint256) {
        uint256 TokensBoughtWithUsdt = 1000000000000000000 / price;

        return TokensBoughtWithUsdt;
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/access/Ownable.sol";
import "https://github.com/Brechtpd/base64/blob/main/base64.sol";

contract studyjoin is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenCounter;

    uint256 public revealFlg = 0;
    uint256 private hitId = 100;
    bool public saleFlg = false;
    uint256 public totalSupply = 30;

    mapping(address => uint256) private _addressToApprove;

    constructor () ERC721 ("YumeKujiJikken","YKJ") {}

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        uint256 flg = 0;

        if(revealFlg==0){
            flg = 0;
        }else if(revealFlg==1){
            if(tokenId == hitId){
                flg = 2;
            }else{
                flg = 1;
            }
        }

        bytes memory json = abi.encodePacked(
            '{',
                '"name": "Yumekuji #',
                Strings.toString(tokenId),
                '",',
                '"description": "",',
                '"image": "https://gateway.pinata.cloud/ipfs/QmQQqqaWPpY2WYBxrmE1LW8YR6MbK1zA9X5t9HeyM22QSU/',
                Strings.toString(flg),
                '.jpg"',
            '}'
        );

        bytes memory metadata = abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        );

        return (string(metadata));
    }

    function mint() public {
        require(saleFlg);
        require(_addressToApprove[_msgSender()] == 0);

        _tokenCounter.increment();
        uint256 newItemId = _tokenCounter.current();

        _safeMint(_msgSender(), newItemId);
        _setTokenURI(newItemId, tokenURI(newItemId));

        _addressToApprove[_msgSender()] = 1;
    }

    function changeOnSaleFlg() public onlyOwner {
        saleFlg = true;
    }

    function changeOffSaleFlg() public onlyOwner{
        saleFlg = false;
    }

    function changeOnRevealFlg() public onlyOwner {
        revealFlg = 1;
    }

    function changeOffRevealFlg() public onlyOwner{
        revealFlg = 0;
    }

    function getAddressApprove() public view returns(uint256){
        return _addressToApprove[_msgSender()];
    }

    function getSupply()public view returns(uint256){
        return _tokenCounter.current();
    }

    function getTotalSupply()public view returns(uint256){
        return totalSupply;
    }

    function setHitId(uint256 num)public onlyOwner{
        hitId = num;
    }

}